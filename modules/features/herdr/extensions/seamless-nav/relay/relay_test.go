package main

import (
	"bufio"
	"context"
	"errors"
	"io"
	"log"
	"net"
	"net/netip"
	"os"
	"path/filepath"
	"strings"
	"testing"
	"time"
)

func testRelay(t *testing.T, allowed bool, run Runner) string {
	t.Helper()
	ln, err := net.Listen("tcp", "127.0.0.1:0")
	if err != nil {
		t.Fatal(err)
	}
	relay := &Relay{
		Allowed: func(netip.Addr) bool { return allowed },
		Run:     run,
		Timeout: time.Second,
		Log:     log.New(io.Discard, "", 0),
	}
	go relay.Serve(ln)
	t.Cleanup(func() { ln.Close() })
	return ln.Addr().String()
}

func ask(t *testing.T, addr, request string) string {
	t.Helper()
	conn, err := net.Dial("tcp", addr)
	if err != nil {
		t.Fatal(err)
	}
	defer conn.Close()
	if _, err := io.WriteString(conn, request); err != nil {
		t.Fatal(err)
	}
	_ = conn.SetReadDeadline(time.Now().Add(2 * time.Second))
	reply, _ := bufio.NewReader(conn).ReadString('\n')
	return strings.TrimSpace(reply)
}

func TestRequests(t *testing.T) {
	tests := []struct {
		request string
		moved   bool
		err     error
		want    string
		args    string
	}{
		{"ping\n", false, nil, "pong", ""},
		{"edge left\n", true, nil, "moved", "edge left"},
		{"edge down\r\n", true, nil, "moved", "edge down"},
		{"edge right\n", false, nil, "edge", "edge right"},
		{"sidebar left\n", true, nil, "moved", "sidebar left"},
		{"edge up\n", false, errors.New("boom"), "error edge failed", "edge up"},
		{"edge sideways\n", true, nil, "error unknown request", ""},
		{"sidebar right\n", true, nil, "error unknown request", ""},
		{"EDGE LEFT\n", true, nil, "error unknown request", ""},
		{"edge left", true, nil, "error bad request", ""},
		{strings.Repeat("x", maxRequestBytes+1) + "\n", true, nil, "error bad request", ""},
	}
	for _, tt := range tests {
		t.Run(strings.TrimSpace(tt.request), func(t *testing.T) {
			var got []string
			addr := testRelay(t, true, func(_ context.Context, args []string) (bool, error) {
				got = args
				return tt.moved, tt.err
			})
			if reply := ask(t, addr, tt.request); reply != tt.want {
				t.Errorf("reply = %q, want %q", reply, tt.want)
			}
			if strings.Join(got, " ") != tt.args {
				t.Errorf("ran %q, want %q", got, tt.args)
			}
		})
	}
}

func TestRejectsMachinesNotAllowed(t *testing.T) {
	ran := false
	addr := testRelay(t, false, func(context.Context, []string) (bool, error) {
		ran = true
		return true, nil
	})
	if reply := ask(t, addr, "edge left\n"); reply != "" {
		t.Errorf("reply = %q, want the connection closed", reply)
	}
	if ran {
		t.Error("ran navigate.sh for a machine not on the allowlist")
	}
}

func TestAllowlistUsesIPAddressesAsGiven(t *testing.T) {
	a := &Allowlist{Names: []string{"100.64.0.1", "::ffff:127.0.0.1"}, Tailscale: "/nonexistent"}
	for addr, want := range map[string]bool{"100.64.0.1": true, "127.0.0.1": true, "100.64.0.2": false} {
		if got := a.Allowed(netip.MustParseAddr(addr)); got != want {
			t.Errorf("Allowed(%s) = %v, want %v", addr, got, want)
		}
	}
}

func TestAllowlistResolvesNamesWithTailscale(t *testing.T) {
	fake := filepath.Join(t.TempDir(), "tailscale")
	script := "#!/bin/sh\n[ \"$1 $2\" = \"ip my-vm\" ] && printf '100.64.0.10\\nfd7a:115c::1\\n'\n"
	if err := os.WriteFile(fake, []byte(script), 0o755); err != nil {
		t.Fatal(err)
	}
	a := &Allowlist{Names: []string{"my-vm"}, Tailscale: fake}
	for addr, want := range map[string]bool{"100.64.0.10": true, "fd7a:115c::1": true, "100.64.0.20": false} {
		if got := a.Allowed(netip.MustParseAddr(addr)); got != want {
			t.Errorf("Allowed(%s) = %v, want %v", addr, got, want)
		}
	}
}

func TestNavigateRunnerMapsExitCodes(t *testing.T) {
	script := filepath.Join(t.TempDir(), "navigate.sh")
	body := `[ "$SEAMLESS_NAV_MAX_IDLE_MS" = 1500 ] || exit 9
case "$1 $2" in "edge left") exit 0 ;; "edge right") exit 1 ;; *) exit 2 ;; esac
`
	if err := os.WriteFile(script, []byte(body), 0o755); err != nil {
		t.Fatal(err)
	}
	run := NavigateRunner(script, 1500*time.Millisecond)
	ctx := context.Background()
	if moved, err := run(ctx, []string{"edge", "left"}); !moved || err != nil {
		t.Errorf("exit 0: moved=%v err=%v, want moved", moved, err)
	}
	if moved, err := run(ctx, []string{"edge", "right"}); moved || err != nil {
		t.Errorf("exit 1: moved=%v err=%v, want nothing to do", moved, err)
	}
	if _, err := run(ctx, []string{"edge", "up"}); err == nil {
		t.Error("exit 2: want an error")
	}
}
