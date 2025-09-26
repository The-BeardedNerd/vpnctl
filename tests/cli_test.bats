#!/usr/bin/env bats

# VPNCTL CLI Tests
# Tests for the main vpnctl command-line interface

# Test setup
setup() {
    # Set up test environment
    export VPNCTL_DEBUG=0
    export TEST_TMPDIR="$(mktemp -d)"
    export XDG_CONFIG_HOME="$TEST_TMPDIR/.config"
    export XDG_STATE_HOME="$TEST_TMPDIR/.local/state"
    export XDG_RUNTIME_DIR="$TEST_TMPDIR/.runtime"
    
    # Path to the vpnctl binary
    VPNCTL_BIN="$BATS_TEST_DIRNAME/../bin/vpnctl"
    
    # Mock dependencies for testing
    export PATH="$BATS_TEST_DIRNAME/mocks:$PATH"
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

@test "vpnctl logs shows no log file message when no logs exist" {
    run "$VPNCTL_BIN" logs
    [ "$status" -eq 0 ]
    [[ "$output" =~ ("No log file found"|"Log file is empty") ]]
}

@test "vpnctl creates XDG-compliant directories" {
    run "$VPNCTL_BIN" list
    [ "$status" -eq 0 ]
    
    # Check that XDG directories are created
    [ -d "$XDG_CONFIG_HOME/vpnctl" ]
    [ -d "$XDG_CONFIG_HOME/vpnctl/profiles" ]
    [ -d "$XDG_STATE_HOME/vpnctl/logs" ]
    [ -d "$XDG_RUNTIME_DIR/vpnctl" ]
}

@test "vpnctl status command executes" {
    run "$VPNCTL_BIN" status
    [ "$status" -eq 0 ]
    [[ "$output" =~ "TODO: Implement status check logic" ]]
}

@test "vpnctl disconnect command executes" {
    run "$VPNCTL_BIN" disconnect
    [ "$status" -eq 0 ]
    [[ "$output" =~ "TODO: Implement VPN disconnection logic" ]]
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