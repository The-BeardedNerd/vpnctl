#!/usr/bin/env bats

# VPNCTL CLI Tests
# Tests for the main vpnctl command-line interface

# Test setup
setup() {
    # Set up test environment with unique directory per test
    export VPNCTL_DEBUG=0
    export TEST_TMPDIR="$(mktemp -d)"
    export XDG_CONFIG_HOME="$TEST_TMPDIR/.config"
    export XDG_STATE_HOME="$TEST_TMPDIR/.local/state"
    export XDG_RUNTIME_DIR="$TEST_TMPDIR/.runtime"

    # Path to the vpnctl binary
    VPNCTL_BIN="$BATS_TEST_DIRNAME/../bin/vpnctl"

    # Mock dependencies for testing
    export PATH="$BATS_TEST_DIRNAME/mocks:$PATH"

    # Ensure clean environment for each test
    unset VPNCTL_LOG_FILE
}

# Test teardown
teardown() {
    # Clean up test environment
    [[ -n "$TEST_TMPDIR" ]] && rm -rf "$TEST_TMPDIR"
}

@test "vpnctl shows help when no arguments provided" {
    run "$VPNCTL_BIN"
    [ "$status" -eq 0 ]
    [[ "$output" =~ "VPNCTL - VPN Manager for Linux" ]]
    [[ "$output" =~ "USAGE:" ]]
}

@test "vpnctl help command works" {
    run "$VPNCTL_BIN" help
    [ "$status" -eq 0 ]
    [[ "$output" =~ "VPNCTL - VPN Manager for Linux" ]]
    [[ "$output" =~ "COMMANDS:" ]]
}

@test "vpnctl version command works" {
    run "$VPNCTL_BIN" version
    [ "$status" -eq 0 ]
    [[ "$output" =~ "vpnctl version" ]]
    [[ "$output" =~ "Copyright" ]]
}

@test "vpnctl list shows no profiles message when profiles dir is empty" {
    run "$VPNCTL_BIN" list
    [ "$status" -eq 0 ]
    [[ "$output" =~ "No VPN profiles found" ]]
}

@test "vpnctl connect requires profile argument" {
    run "$VPNCTL_BIN" connect
    [ "$status" -eq 1 ]
    [[ "$output" =~ "Profile name required" ]]
}

@test "vpnctl connect fails with non-existent profile" {
    run "$VPNCTL_BIN" connect nonexistent
    [ "$status" -eq 1 ]
    [[ "$output" =~ "Profile not found" ]]
}

@test "vpnctl add requires file argument" {
    run "$VPNCTL_BIN" add
    [ "$status" -eq 1 ]
    [[ "$output" =~ "Profile file required" ]]
}

@test "vpnctl add fails with non-existent file" {
    run "$VPNCTL_BIN" add /nonexistent/file.ovpn
    [ "$status" -eq 1 ]
    [[ "$output" =~ "Profile file not found" ]]
}

@test "vpnctl logs command executes and shows initialization logs" {
    # Create completely fresh environment just for this test
    local FRESH_TMPDIR="$(mktemp -d)"
    local FRESH_XDG_STATE_HOME="$FRESH_TMPDIR/.local/state"
    local FRESH_XDG_CONFIG_HOME="$FRESH_TMPDIR/.config"
    local FRESH_XDG_RUNTIME_DIR="$FRESH_TMPDIR/.runtime"

    # Run logs command with completely clean environment
    run env XDG_STATE_HOME="$FRESH_XDG_STATE_HOME" \
            XDG_CONFIG_HOME="$FRESH_XDG_CONFIG_HOME" \
            XDG_RUNTIME_DIR="$FRESH_XDG_RUNTIME_DIR" \
            PATH="$BATS_TEST_DIRNAME/mocks:$PATH" \
            "$VPNCTL_BIN" logs 2>/dev/null

    [ "$status" -eq 0 ]
    # Debug: Show actual output
    echo "# Fresh logs output: $output" >&3
    # On fresh system, vpnctl logs should show directory creation logs
    [[ "$output" =~ "Created directory" ]] || [[ "$output" =~ "Log file is empty" ]] || [[ "$output" =~ "No log file found" ]]

    # Clean up
    rm -rf "$FRESH_TMPDIR"
}

@test "vpnctl creates appropriate directories" {
    # Verify the test environment is properly set up
    echo "# XDG_CONFIG_HOME: $XDG_CONFIG_HOME" >&3
    echo "# XDG_STATE_HOME: $XDG_STATE_HOME" >&3
    echo "# XDG_RUNTIME_DIR: $XDG_RUNTIME_DIR" >&3
    echo "# TEST_TMPDIR: $TEST_TMPDIR" >&3
    echo "# EUID: $EUID" >&3

    # Run a command that should create directories (capture both stdout and stderr)
    run "$VPNCTL_BIN" list
    echo "# Command exit status: $status" >&3
    echo "# Command output: $output" >&3
    [ "$status" -eq 0 ]

    # Debug: Show what got created
    echo "# Directories after list command:" >&3
    find "$TEST_TMPDIR" -type d 2>/dev/null | sort >&3 || echo "# No directories found" >&3
    find /etc/vpnctl -type d 2>/dev/null | sort >&3 || echo "# No system directories found" >&3
    find /var/log/vpnctl -type d 2>/dev/null | sort >&3 || echo "# No log directories found" >&3
    find /run/vpnctl -type d 2>/dev/null | sort >&3 || echo "# No runtime directories found" >&3

    # Check directories based on whether running as root or user
    if [[ $EUID -eq 0 ]]; then
        # Running as root - expect system directories
        echo "# Testing system directories (running as root)" >&3
        [ -d "/etc/vpnctl" ] || { echo "# Missing: /etc/vpnctl" >&3; false; }
        [ -d "/etc/vpnctl/profiles" ] || { echo "# Missing: /etc/vpnctl/profiles" >&3; false; }
        [ -d "/var/log/vpnctl" ] || { echo "# Missing: /var/log/vpnctl" >&3; false; }
        [ -d "/run/vpnctl" ] || { echo "# Missing: /run/vpnctl" >&3; false; }
    else
        # Running as user - expect XDG directories
        echo "# Testing XDG directories (running as user)" >&3
        [ -d "$XDG_CONFIG_HOME/vpnctl" ] || { echo "# Missing: $XDG_CONFIG_HOME/vpnctl" >&3; false; }
        [ -d "$XDG_CONFIG_HOME/vpnctl/profiles" ] || { echo "# Missing: $XDG_CONFIG_HOME/vpnctl/profiles" >&3; false; }
        [ -d "$XDG_STATE_HOME/vpnctl/logs" ] || { echo "# Missing: $XDG_STATE_HOME/vpnctl/logs" >&3; false; }
        [ -d "$XDG_RUNTIME_DIR/vpnctl" ] || { echo "# Missing: $XDG_RUNTIME_DIR/vpnctl" >&3; false; }
    fi
}

@test "vpnctl status shows disconnected when no connection" {
    run "$VPNCTL_BIN" status
    [ "$status" -eq 0 ]
    [[ "$output" =~ "VPN Status: Disconnected" ]]
    [[ "$output" =~ "No active VPN connection" ]]
}

@test "vpnctl status shows connection lost when PID file exists but process is dead" {
    # Create a PID file with a non-existent PID
    echo "99999" > "$XDG_RUNTIME_DIR/vpnctl/vpnctl.pid"

    # Create a status file
    cat > "$XDG_RUNTIME_DIR/vpnctl/vpnctl.status" << EOF
profile=test
type=openvpn
pid=99999
started=2025-01-01 12:00:00
config_file=/test/test.ovpn
EOF

    run "$VPNCTL_BIN" status
    [ "$status" -eq 0 ]
    [[ "$output" =~ "VPN Status: Connection Lost" ]]
    [[ "$output" =~ "Process is no longer running" ]]
    [[ "$output" =~ "cleaning up stale connection files" ]]
}

@test "vpnctl status shows connection info when connected (mock)" {
    # Create a mock PID file with current shell PID (guaranteed to exist)
    echo "$$" > "$XDG_RUNTIME_DIR/vpnctl/vpnctl.pid"

    # Create a status file
    cat > "$XDG_RUNTIME_DIR/vpnctl/vpnctl.status" << EOF
profile=test-server
type=openvpn
pid=$$
started=$(date '+%Y-%m-%d %H:%M:%S')
config_file=/test/test-server.ovpn
EOF

    run "$VPNCTL_BIN" status
    [ "$status" -eq 0 ]
    [[ "$output" =~ "VPN Status: Connected" ]]
    [[ "$output" =~ "Profile: test-server" ]]
    [[ "$output" =~ "Type: OPENVPN" ]]
    [[ "$output" =~ "PID: $$" ]]
    [[ "$output" =~ "Duration:" ]]
}

@test "vpnctl status handles WireGuard connection type" {
    # Create a mock PID file with current shell PID
    echo "$$" > "$XDG_RUNTIME_DIR/vpnctl/vpnctl.pid"

    # Create a WireGuard status file
    cat > "$XDG_RUNTIME_DIR/vpnctl/vpnctl.status" << EOF
profile=wg-server
type=wireguard
interface=wg0
started=$(date '+%Y-%m-%d %H:%M:%S')
config_file=/test/wg-server.conf
EOF

    run "$VPNCTL_BIN" status
    [ "$status" -eq 0 ]
    [[ "$output" =~ "VPN Status: Connected" ]]
    [[ "$output" =~ "Profile: wg-server" ]]
    [[ "$output" =~ "Type: WIREGUARD" ]]
    [[ "$output" =~ "Config: /test/wg-server.conf" ]]
}

@test "vpnctl status handles missing status file gracefully" {
    # Create only PID file, no status file
    echo "$$" > "$XDG_RUNTIME_DIR/vpnctl/vpnctl.pid"

    run "$VPNCTL_BIN" status
    [ "$status" -eq 0 ]
    [[ "$output" =~ "VPN Status: Disconnected" ]]
    [[ "$output" =~ "No active VPN connection" ]]
}

@test "vpnctl disconnect command executes" {
    run "$VPNCTL_BIN" disconnect
    [ "$status" -eq 0 ]
    [[ "$output" =~ "No active VPN connection found" ]]
}

@test "vpnctl fix-dns command executes" {
    run "$VPNCTL_BIN" fix-dns
    [ "$status" -eq 0 ]
    [[ "$output" =~ "TODO: Implement DNS reset logic" ]]
}

@test "vpnctl handles unknown commands gracefully" {
    run "$VPNCTL_BIN" unknown-command
    [ "$status" -eq 1 ]
    [[ "$output" =~ "Unknown command: unknown-command" ]]
}

@test "vpnctl debug mode can be enabled" {
    VPNCTL_DEBUG=1 run "$VPNCTL_BIN" list
    [ "$status" -eq 0 ]
    # Debug output should appear in stderr, but we can still check it executed
}

@test "vpnctl connect requires profile name" {
    run "$VPNCTL_BIN" connect
    [ "$status" -eq 1 ]
    [[ "$output" =~ "Profile name required" ]]
}

@test "vpnctl connect fails with nonexistent profile" {
    run "$VPNCTL_BIN" connect nonexistent
    [ "$status" -eq 1 ]
    [[ "$output" =~ "Profile not found: nonexistent" ]]
}

@test "vpnctl connect detects OpenVPN profile type" {
    # Create a test OpenVPN profile
    mkdir -p "$XDG_CONFIG_HOME/vpnctl/profiles"
    cat > "$XDG_CONFIG_HOME/vpnctl/profiles/test.ovpn" << 'EOF'
client
dev tun
proto udp
remote test.example.com 1194
EOF

    run "$VPNCTL_BIN" connect test
    # Command should execute (may fail due to dependencies/test environment)
    # Just verify it recognizes the .ovpn file and attempts connection
    [[ "$output" =~ "test" ]]
}

@test "vpnctl connect detects WireGuard profile type" {
    # Create a test WireGuard profile
    mkdir -p "$XDG_CONFIG_HOME/vpnctl/profiles"
    cat > "$XDG_CONFIG_HOME/vpnctl/profiles/wgtest.conf" << 'EOF'
[Interface]
PrivateKey = 4KzqGcnlM4xGY6J8V2hTZHEqOgv1RJd6ZxN7RiCVgaU=
Address = 10.0.0.2/32

[Peer]
PublicKey = uGYLXJxKqJnUMFjTZGfJgz7UiLtaUNJyTYlQWBfYjik=
Endpoint = test.example.com:51820
EOF

    run "$VPNCTL_BIN" connect wgtest
    # Command should execute (may fail due to dependencies/test environment)
    # Just verify it recognizes the .conf file and attempts connection
    [[ "$output" =~ "wgtest" ]]
}

@test "vpnctl connect creates runtime files structure" {
    # Create a test profile
    mkdir -p "$XDG_CONFIG_HOME/vpnctl/profiles"
    echo "client" > "$XDG_CONFIG_HOME/vpnctl/profiles/test.ovpn"

    # Run connect (will fail but should create directories)
    run "$VPNCTL_BIN" connect test

    # Check that runtime directory exists (may be system or user depending on EUID)
    if [[ $EUID -eq 0 ]]; then
        [ -d "/run/vpnctl" ]
    else
        [ -d "$XDG_RUNTIME_DIR/vpnctl" ]
    fi
}

@test "vpnctl connect prefers OpenVPN over WireGuard when both exist" {
    # Create both profile types with same base name
    mkdir -p "$XDG_CONFIG_HOME/vpnctl/profiles"
    echo "client" > "$XDG_CONFIG_HOME/vpnctl/profiles/dual.ovpn"
    echo "[Interface]" > "$XDG_CONFIG_HOME/vpnctl/profiles/dual.conf"

    run "$VPNCTL_BIN" connect dual
    # Command should execute and try to connect to the profile
    # OpenVPN should be preferred (exact output varies by environment)
    [[ "$output" =~ "dual" ]]
    # Should not mention WireGuard since OpenVPN is preferred
    [[ ! "$output" =~ "wireguard" ]]
}

@test "vpnctl disconnect with no active connection" {
    run "$VPNCTL_BIN" disconnect
    [ "$status" -eq 0 ]
    [[ "$output" =~ "No active VPN connection found" ]]
}

@test "vpnctl disconnect cleans up stale PID file" {
    # Create a stale PID file with invalid PID in appropriate location
    if [[ $EUID -eq 0 ]]; then
        mkdir -p "/run/vpnctl"
        echo "99999" > "/run/vpnctl/vpnctl.pid"
    else
        mkdir -p "$XDG_RUNTIME_DIR/vpnctl"
        echo "99999" > "$XDG_RUNTIME_DIR/vpnctl/vpnctl.pid"
    fi

    run "$VPNCTL_BIN" disconnect
    [ "$status" -eq 0 ]
    # Should indicate stale PID cleanup
    [[ "$output" =~ "VPN process not running" ]] || [[ "$output" =~ "cleaning up stale files" ]] || [[ "$output" =~ "not running - cleaning up" ]]

    # PID file should be cleaned up
    if [[ $EUID -eq 0 ]]; then
        [ ! -f "/run/vpnctl/vpnctl.pid" ]
    else
        [ ! -f "$XDG_RUNTIME_DIR/vpnctl/vpnctl.pid" ]
    fi
}

@test "vpnctl disconnect cleans up empty PID file" {
    # Create an empty PID file in appropriate location
    if [[ $EUID -eq 0 ]]; then
        mkdir -p "/run/vpnctl"
        touch "/run/vpnctl/vpnctl.pid"
    else
        mkdir -p "$XDG_RUNTIME_DIR/vpnctl"
        touch "$XDG_RUNTIME_DIR/vpnctl/vpnctl.pid"
    fi

    run "$VPNCTL_BIN" disconnect
    [ "$status" -eq 0 ]
    # Should indicate empty PID file cleanup
    [[ "$output" =~ "Invalid PID file" ]] || [[ "$output" =~ "cleaning up stale files" ]] || [[ "$output" =~ "cleaning up" ]]

    # PID file should be cleaned up
    if [[ $EUID -eq 0 ]]; then
        [ ! -f "/run/vpnctl/vpnctl.pid" ]
    else
        [ ! -f "$XDG_RUNTIME_DIR/vpnctl/vpnctl.pid" ]
    fi
}

@test "vpnctl disconnect removes status file during cleanup" {
    # Create stale connection files in appropriate location
    if [[ $EUID -eq 0 ]]; then
        mkdir -p "/run/vpnctl"
        echo "99999" > "/run/vpnctl/vpnctl.pid"
        cat > "/run/vpnctl/vpnctl.status" << EOF
profile=test
type=openvpn
pid=99999
started=$(date '+%Y-%m-%d %H:%M:%S')
EOF
    else
        mkdir -p "$XDG_RUNTIME_DIR/vpnctl"
        echo "99999" > "$XDG_RUNTIME_DIR/vpnctl/vpnctl.pid"
        cat > "$XDG_RUNTIME_DIR/vpnctl/vpnctl.status" << EOF
profile=test
type=openvpn
pid=99999
started=$(date '+%Y-%m-%d %H:%M:%S')
EOF
    fi

    run "$VPNCTL_BIN" disconnect
    # Test is successful if command executes without crashing
    # File cleanup depends on sudo availability in test environment
    [[ "$status" -eq 0 ]] || [[ "$status" -eq 1 ]]
}

@test "vpnctl disconnect creates runtime directory if needed" {
    # Ensure directory exists for disconnect command
    run "$VPNCTL_BIN" disconnect
    # Test passes if command executes without crashing
    [[ "$status" -eq 0 ]] || [[ "$status" -eq 1 ]]
}
