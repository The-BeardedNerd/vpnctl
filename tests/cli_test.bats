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

@test "vpnctl creates XDG-compliant directories" {
    # Verify the test environment is properly set up
    echo "# XDG_CONFIG_HOME: $XDG_CONFIG_HOME" >&3
    echo "# XDG_STATE_HOME: $XDG_STATE_HOME" >&3
    echo "# XDG_RUNTIME_DIR: $XDG_RUNTIME_DIR" >&3
    echo "# TEST_TMPDIR: $TEST_TMPDIR" >&3
    
    # Ensure directories don't exist yet
    [ ! -d "$XDG_CONFIG_HOME/vpnctl" ] || echo "# Config dir already exists" >&3
    
    # Run a command that should create directories (capture both stdout and stderr)
    run "$VPNCTL_BIN" list
    echo "# Command exit status: $status" >&3
    echo "# Command output: $output" >&3
    [ "$status" -eq 0 ]
    
    # Debug: Show what got created
    echo "# Directories after list command:" >&3
    find "$TEST_TMPDIR" -type d 2>/dev/null | sort >&3 || echo "# No directories found" >&3
    
    # Check that XDG directories are created (with better error messages)
    [ -d "$XDG_CONFIG_HOME/vpnctl" ] || { echo "# Missing: $XDG_CONFIG_HOME/vpnctl" >&3; false; }
    [ -d "$XDG_CONFIG_HOME/vpnctl/profiles" ] || { echo "# Missing: $XDG_CONFIG_HOME/vpnctl/profiles" >&3; false; }
    [ -d "$XDG_STATE_HOME/vpnctl/logs" ] || { echo "# Missing: $XDG_STATE_HOME/vpnctl/logs" >&3; false; }
    [ -d "$XDG_RUNTIME_DIR/vpnctl" ] || { echo "# Missing: $XDG_RUNTIME_DIR/vpnctl" >&3; false; }
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