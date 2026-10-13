// Command seamless-nav-relay lets seamless-nav on a remote machine (a VM on
// your tailnet) hand navigation edges back to the machine you're typing on,
// where herdr's client and WezTerm run.
//
// When Ctrl+h/j/k/l reaches the edge of a remote workspace, the remote plugin
// connects and sends one line:
//
//	ping | edge <left|right|up|down> | sidebar left
//
// The relay runs scripts/navigate.sh for that edge here and answers with one
// line: pong, moved (focus moved or the sidebar opened), edge (nothing to do,
// so the remote plugin passes the key to the app) or error <reason>.
package main

import (
	"flag"
	"fmt"
	"log"
	"net"
	"os"
	"os/exec"
	"os/signal"
	"path/filepath"
	"strings"
	"syscall"
	"time"
)

func main() {
	listen := flag.String("listen", "tailscale:47100",
		`address to listen on; host "tailscale" means this machine's Tailscale IPv4 address`)
	allow := flag.String("allow", "",
		"machines allowed to send edges: Tailscale names or IP addresses, separated by spaces or commas")
	navigate := flag.String("navigate", "", "seamless-nav's scripts/navigate.sh (default: next to this binary)")
	tailscale := flag.String("tailscale", "", "tailscale CLI (default: on PATH or in Tailscale.app)")
	maxIdle := flag.Duration("max-idle", 1500*time.Millisecond,
		"act only if WezTerm saw input this recently, so only the machine you're typing on acts")
	timeout := flag.Duration("timeout", 2*time.Second, "time limit for handling one edge")
	flag.Parse()

	logger := log.New(os.Stderr, "seamless-nav-relay: ", log.LstdFlags)
	names := strings.FieldsFunc(*allow, func(r rune) bool { return r == ',' || r == ' ' })
	if len(names) == 0 {
		logger.Fatal("-allow is required")
	}
	if *navigate == "" {
		exe, err := os.Executable()
		if err != nil {
			logger.Fatal(err)
		}
		*navigate = filepath.Join(filepath.Dir(exe), "..", "scripts", "navigate.sh")
	}
	if _, err := os.Stat(*navigate); err != nil {
		logger.Fatal(err)
	}
	if *tailscale == "" {
		*tailscale = findTailscale()
	}

	ln := listenRetry(*listen, *tailscale, logger)
	logger.Printf("listening on %s, allowing %s", ln.Addr(), strings.Join(names, " "))

	signals := make(chan os.Signal, 1)
	signal.Notify(signals, syscall.SIGINT, syscall.SIGTERM)
	go func() {
		<-signals
		ln.Close()
	}()

	relay := &Relay{
		Allowed: (&Allowlist{Names: names, Tailscale: *tailscale}).Allowed,
		Run:     NavigateRunner(*navigate, *maxIdle),
		Timeout: *timeout,
		Log:     logger,
	}
	if err := relay.Serve(ln); err != nil {
		logger.Fatal(err)
	}
}

// listenRetry listens on address, waiting for Tailscale to come up when the
// host is "tailscale".
func listenRetry(address, tailscale string, logger *log.Logger) net.Listener {
	for warned := false; ; warned = true {
		ln, err := listen(address, tailscale)
		if err == nil {
			return ln
		}
		if !warned {
			logger.Printf("%v; retrying every 5s", err)
		}
		time.Sleep(5 * time.Second)
	}
}

func listen(address, tailscale string) (net.Listener, error) {
	host, port, err := net.SplitHostPort(address)
	if err != nil {
		return nil, err
	}
	if host == "tailscale" {
		out, err := exec.Command(tailscale, "ip", "-4").Output()
		fields := strings.Fields(string(out))
		if err != nil || len(fields) == 0 {
			return nil, fmt.Errorf("no Tailscale IPv4 address from %s ip -4: %v", tailscale, err)
		}
		host = fields[0]
	}
	return net.Listen("tcp", net.JoinHostPort(host, port))
}

func findTailscale() string {
	if path, err := exec.LookPath("tailscale"); err == nil {
		return path
	}
	return "/Applications/Tailscale.app/Contents/MacOS/Tailscale"
}
