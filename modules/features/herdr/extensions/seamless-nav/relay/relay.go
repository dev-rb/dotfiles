package main

import (
	"bufio"
	"context"
	"errors"
	"fmt"
	"io"
	"log"
	"net"
	"net/netip"
	"os"
	"os/exec"
	"strings"
	"sync"
	"time"
)

const (
	maxRequestBytes = 64
	readTimeout     = time.Second
	writeTimeout    = time.Second
)

// requests maps each accepted request line to navigate.sh arguments. Nothing
// else is ever run: a remote machine can only move focus or open the sidebar.
var requests = map[string][]string{
	"edge left":    {"edge", "left"},
	"edge right":   {"edge", "right"},
	"edge up":      {"edge", "up"},
	"edge down":    {"edge", "down"},
	"sidebar left": {"sidebar", "left"},
}

// Runner handles one edge on this machine and reports whether focus moved.
type Runner func(ctx context.Context, args []string) (moved bool, err error)

// Relay answers edge requests from allowlisted machines.
type Relay struct {
	Allowed func(netip.Addr) bool
	Run     Runner
	Timeout time.Duration
	Log     *log.Logger

	mu sync.Mutex // one edge at a time, so focus moves never interleave
}

// Serve accepts connections until the listener is closed.
func (r *Relay) Serve(ln net.Listener) error {
	for {
		conn, err := ln.Accept()
		if err != nil {
			if errors.Is(err, net.ErrClosed) {
				return nil
			}
			return err
		}
		go r.handle(conn)
	}
}

func (r *Relay) handle(conn net.Conn) {
	defer conn.Close()
	peer := peerAddr(conn)
	if !peer.IsValid() || !r.Allowed(peer) {
		r.Log.Printf("rejected %s: not on the allowlist", conn.RemoteAddr())
		return
	}
	_ = conn.SetReadDeadline(time.Now().Add(readTimeout))
	line, err := readLine(conn)
	reply := "error bad request"
	if err != nil {
		r.Log.Printf("%s: %v", peer, err)
	} else {
		reply = r.respond(line, peer)
	}
	_ = conn.SetWriteDeadline(time.Now().Add(writeTimeout))
	_, _ = io.WriteString(conn, reply+"\n")
}

func (r *Relay) respond(line string, peer netip.Addr) string {
	if line == "ping" {
		return "pong"
	}
	args, ok := requests[line]
	if !ok {
		r.Log.Printf("%s: unknown request %q", peer, line)
		return "error unknown request"
	}

	r.mu.Lock()
	defer r.mu.Unlock()
	ctx, cancel := context.WithTimeout(context.Background(), r.Timeout)
	defer cancel()
	moved, err := r.Run(ctx, args)
	switch {
	case err != nil:
		r.Log.Printf("%s: %s: %v", peer, line, err)
		return "error edge failed"
	case moved:
		r.Log.Printf("%s: %s: moved", peer, line)
		return "moved"
	default:
		r.Log.Printf("%s: %s: nothing to do", peer, line)
		return "edge"
	}
}

func readLine(conn net.Conn) (string, error) {
	line, err := bufio.NewReader(io.LimitReader(conn, maxRequestBytes+1)).ReadString('\n')
	if err != nil {
		return "", fmt.Errorf("reading request: %w", err)
	}
	return strings.TrimRight(line, "\r\n"), nil
}

func peerAddr(conn net.Conn) netip.Addr {
	addrPort, err := netip.ParseAddrPort(conn.RemoteAddr().String())
	if err != nil {
		return netip.Addr{}
	}
	return addrPort.Addr().Unmap()
}

// NavigateRunner runs seamless-nav's navigate.sh, which exits 0 when it moved
// focus and 1 when there was nothing to do. maxIdle limits it to the machine
// whose WezTerm saw input that recently: the one you're typing on.
func NavigateRunner(script string, maxIdle time.Duration) Runner {
	return func(ctx context.Context, args []string) (bool, error) {
		cmd := exec.CommandContext(ctx, "bash", append([]string{script}, args...)...)
		cmd.Env = append(os.Environ(), fmt.Sprintf("SEAMLESS_NAV_MAX_IDLE_MS=%d", maxIdle.Milliseconds()))
		err := cmd.Run()
		var exit *exec.ExitError
		switch {
		case err == nil:
			return true, nil
		case errors.As(err, &exit) && exit.ExitCode() == 1:
			return false, nil
		default:
			return false, err
		}
	}
}

// Allowlist holds the addresses allowed to send edges, resolved from Tailscale
// machine names with `tailscale ip`. IP addresses are used as given.
type Allowlist struct {
	Names     []string
	Tailscale string

	mu        sync.Mutex
	addrs     map[netip.Addr]bool
	refreshed time.Time
}

// Allowed reports whether addr may send edges. An unknown address triggers a
// re-resolve at most every 30 seconds, in case a machine's address changed.
func (a *Allowlist) Allowed(addr netip.Addr) bool {
	a.mu.Lock()
	defer a.mu.Unlock()
	if a.addrs[addr] {
		return true
	}
	if a.addrs == nil || time.Since(a.refreshed) > 30*time.Second {
		a.resolveLocked()
	}
	return a.addrs[addr]
}

func (a *Allowlist) resolveLocked() {
	addrs := map[netip.Addr]bool{}
	for _, name := range a.Names {
		if ip, err := netip.ParseAddr(name); err == nil {
			addrs[ip.Unmap()] = true
			continue
		}
		out, err := exec.Command(a.Tailscale, "ip", name).Output()
		if err != nil {
			continue
		}
		for _, field := range strings.Fields(string(out)) {
			if ip, err := netip.ParseAddr(field); err == nil {
				addrs[ip.Unmap()] = true
			}
		}
	}
	a.addrs = addrs
	a.refreshed = time.Now()
}
