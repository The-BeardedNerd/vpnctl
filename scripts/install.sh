#!/usr/bin/env bash

# VPNCTL Installation Script
# Installs vpnctl in user or system mode with XDG compliance

set -euo pipefail

readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

# Installation mode detection
if [[ $EUID -eq 0 ]]; then
    INSTALL_MODE="system"
    BIN_DIR="/usr/local/bin"
    CONFIG_DIR="/etc/vpnctl"
else
    INSTALL_MODE="user"
    BIN_DIR="${HOME}/.local/bin"
    CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/vpnctl"
fi

# Colors
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly BLUE='\033[0;34m'
readonly NC='\033[0m'

log() {
    local level="$1"
    local message="$2"
    
    case "$level" in
        "INFO")
            echo -e "${BLUE}[INFO]${NC} $message"
            ;;
        "SUCCESS")
            echo -e "${GREEN}[SUCCESS]${NC} $message"
            ;;
        "WARN")
            echo -e "${YELLOW}[WARN]${NC} $message"
            ;;
        "ERROR")
            echo -e "${RED}[ERROR]${NC} $message" >&2
            ;;
    esac
}

check_dependencies() {
    log "INFO" "Checking dependencies..."
    
    local missing_deps=()
    
    for cmd in openvpn wg-quick ip; do
        if ! command -v "$cmd" &> /dev/null; then
            missing_deps+=("$cmd")
        fi
    done
    
    if [[ ${#missing_deps[@]} -gt 0 ]]; then
        log "WARN" "Missing optional dependencies: ${missing_deps[*]}"
        log "INFO" "Install with your package manager:"
        log "INFO" "  Arch: sudo pacman -S openvpn wireguard-tools iproute2"
        log "INFO" "  Ubuntu: sudo apt install openvpn wireguard-tools iproute2"
        log "INFO" "  Fedora: sudo dnf install openvpn wireguard-tools iproute"
    else
        log "SUCCESS" "All dependencies found"
    fi
}

install_vpnctl() {
    log "INFO" "Installing vpnctl ($INSTALL_MODE mode)..."
    
    # Create directories
    mkdir -p "$BIN_DIR"
    mkdir -p "$CONFIG_DIR/profiles"
    
    # Install binary
    cp "$PROJECT_ROOT/bin/vpnctl" "$BIN_DIR/vpnctl"
    chmod +x "$BIN_DIR/vpnctl"
    log "SUCCESS" "Installed vpnctl to $BIN_DIR/vpnctl"
    
    # Install default config if it doesn't exist
    if [[ ! -f "$CONFIG_DIR/config.ini" ]]; then
        cp "$PROJECT_ROOT/config/config.ini" "$CONFIG_DIR/config.ini"
        log "SUCCESS" "Installed config to $CONFIG_DIR/config.ini"
    else
        log "INFO" "Config already exists at $CONFIG_DIR/config.ini"
    fi
    
    # Install example profile if profiles directory is empty
    if [[ ! "$(ls -A "$CONFIG_DIR/profiles" 2>/dev/null)" ]]; then
        cp "$PROJECT_ROOT/config/profiles/example.ovpn" "$CONFIG_DIR/profiles/"
        log "SUCCESS" "Installed example profile to $CONFIG_DIR/profiles/"
    fi
}

show_post_install() {
    log "SUCCESS" "Installation complete!"
    echo
    echo "Configuration:"
    echo "  Config:   $CONFIG_DIR/config.ini"
    echo "  Profiles: $CONFIG_DIR/profiles/"
    echo
    echo "Usage:"
    echo "  vpnctl help       # Show help"
    echo "  vpnctl list       # List profiles"
    echo "  vpnctl version    # Show version"
    echo
    
    if [[ "$INSTALL_MODE" == "user" ]]; then
        echo "Make sure ~/.local/bin is in your PATH:"
        echo "  export PATH=\"\$HOME/.local/bin:\$PATH\""
    fi
}

main() {
    log "INFO" "VPNCTL Installation Script"
    log "INFO" "Mode: $INSTALL_MODE"
    log "INFO" "Target: $BIN_DIR"
    echo
    
    check_dependencies
    install_vpnctl
    show_post_install
}

main "$@"