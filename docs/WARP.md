# WARP.md - AI/Developer Reference Guide for VPNCTL

**Generated**: 2025-09-26T06:43:08Z  
**Project**: VPNCTL - VPN Manager for Linux  
**Location**: `/home/devphreek/dev/vpnctl/`

---

## 📋 Project Overview

**VPNCTL** is a CLI/TUI tool for managing VPN connections on Linux with XDG compliance and hybrid user/system access. It supports ProtonVPN, OpenVPN, and WireGuard configurations with privilege-aware operations.

### Key Features
- ✅ Hybrid Install: Works for single users or system-wide
- ✅ XDG Compliant: Configs/logs in standard locations
- ✅ Privilege-Aware: Uses `sudo` only when necessary
- ✅ Multi-VPN Support: ProtonVPN, OpenVPN, WireGuard
- ✅ Interactive TUI: Optional dialog-based interface

---

## 🏗️ Project Structure

```
vpnctl/
├── docs/                    # Documentation
│   ├── development/         # Development-specific docs
│   │   ├── PROJECT-STRUCTURE.md
│   │   ├── ARCHITECTURE.md
│   │   ├── PLAN.md
│   │   └── CONVENTIONAL-COMMITS.md
│   ├── WARP.md             # This file (AI/Dev guide)
│   └── README.md           # User-facing documentation
├── bin/                    # [PLANNED] Executables
│   ├── vpnctl              # Main CLI script
│   └── vpnctl-tui          # Optional TUI wrapper
├── config/                 # [PLANNED] Default configs
│   ├── config.ini          # Default settings
│   └── profiles/           # Example VPN profiles
├── lib/                    # [PLANNED] Shared libraries
│   └── helpers.sh          # Reusable functions
├── src/                    # [PLANNED] Source code
├── tests/                  # [PLANNED] Test scripts (BATS)
├── scripts/                # [PLANNED] Utility scripts
├── Containerfile           # Container definition (Alpine-based)
├── justfile               # Task automation (recommended)
├── Makefile               # Task automation (fallback)
└── [.gitignore, LICENSE]   # [PLANNED] Standard project files
```

---

## 🚀 Development Setup

### Prerequisites
- **OS**: Arch Linux (current environment)
- **Shell**: bash 5.3.3
- **Required Tools**:
  - `openvpn` - VPN client
  - `wireguard-tools` - WireGuard support
  - `dialog` - TUI components
  - `bats` - Testing framework
  - `shellcheck` - Shell linting
  - `just` - Task runner (recommended)

### Initial Setup

1. **Initialize Git Repository**:
   ```bash
   git init
   git add .
   git commit -m "feat: initial project structure"
   ```

2. **Install Dependencies**:
   ```bash
   # Arch Linux
   sudo pacman -S openvpn wireguard-tools dialog bats shellcheck just
   ```

3. **Create Missing Directories**:
   ```bash
   mkdir -p {bin,src,config,lib,tests,scripts}
   mkdir -p config/profiles
   ```

---

## 🔧 Containerized Development

### Container Environment
- **Base Image**: Alpine Linux
- **Container Tool**: Podman (recommended) or Docker
- **Purpose**: Isolated development/testing environment

### Container Commands

```bash
# Build container
just build-container    # or: make build-container

# Run tests in container
just test-container     # or: make test-container

# Development shell
just shell-container    # or: make shell-container
```

### Container Definition
The `Containerfile` includes:
- Alpine Linux base
- OpenVPN, WireGuard, dialog
- Development tools (bats, shellcheck, just)
- Working directory: `/vpnctl`

---

## ⚙️ Task Automation

### Recommended: `just` Commands
```bash
just --list              # Show all available tasks
just install-user        # Install for current user
just install-system      # Install system-wide (requires sudo)
just lint                # Lint shell scripts
just test                # Run BATS tests
just release VERSION     # Create release tarball
just clean               # Clean artifacts
```

### Fallback: `make` Commands
```bash
make help                # Show available targets
make install-user        # Install for current user
make install-system      # Install system-wide
make lint                # Lint shell scripts
make test                # Run tests
make release             # Create release
make clean               # Clean up
```

---

## 📁 File Locations & XDG Compliance

### User-Level Installation
- **Executables**: `~/.local/bin/vpnctl`
- **Config**: `~/.config/vpnctl/config.ini`
- **Profiles**: `~/.config/vpnctl/profiles/`
- **Logs**: `~/.local/state/vpnctl/logs/`

### System-Wide Installation
- **Executables**: `/usr/local/bin/vpnctl`
- **Config**: `/etc/vpnctl/config.ini`
- **Profiles**: `/etc/vpnctl/profiles/`
- **Logs**: `/var/log/vpnctl/`

---

## 🏗️ Development Workflow

### Branch Strategy
- **`main`**: Stable releases
- **`develop`**: Integration branch
- **`feature/`**: New features
- **`fix/`**: Bug fixes
- **`docs/`**: Documentation updates

### Commit Convention
Following [Conventional Commits](https://www.conventionalcommits.org/):

```bash
# Format
<type>[optional scope]: <description>
[optional body]
[optional footer(s)]

# Examples
feat: add WireGuard support
fix(dns): resolve DNS reset issue
docs: update installation guide
feat!: breaking change to config format
```

### Common Types
- `feat:` - New features (MINOR version)
- `fix:` - Bug fixes (PATCH version)
- `docs:` - Documentation changes
- `test:` - Test additions/updates
- `chore:` - Maintenance tasks
- `BREAKING CHANGE:` - API breaking changes (MAJOR version)

---

## 🧪 Testing Strategy

### Test Framework: BATS
```bash
# Run all tests
bats tests/

# Run specific test file
bats tests/cli_test.bats

# Debug mode
bats --tap tests/
```

### Test Structure (Planned)
```
tests/
├── cli_test.bats           # CLI command tests
├── tui_test.bats          # TUI interaction tests
├── config_test.bats       # Configuration tests
└── helpers/               # Test utilities
    └── test_helpers.bash
```

---

## 📦 Architecture & Components

### Core Components
1. **CLI (`vpnctl`)** - Main command-line interface
2. **TUI (`vpnctl-tui`)** - Interactive terminal interface
3. **Configuration System** - XDG-compliant config management
4. **Profile Manager** - VPN configuration handling
5. **Privilege Manager** - Smart sudo usage

### Key Commands (Planned)
| Command | Purpose | Privileges |
|---------|---------|------------|
| `connect` | Start VPN connection | sudo (if system) |
| `disconnect` | Stop VPN connection | sudo (if system) |
| `status` | Show connection status | None |
| `fix-dns` | Reset DNS settings | sudo |
| `list` | List available profiles | None |
| `add` | Add new profile | None |

---

## 🔍 Troubleshooting

### Common Issues

1. **Permission Errors**
   ```bash
   # Check file permissions
   ls -la ~/.local/bin/vpnctl
   
   # Fix executable permissions
   chmod +x ~/.local/bin/vpnctl
   ```

2. **Missing Dependencies**
   ```bash
   # Check for required tools
   just deps  # or: make deps
   
   # Install missing packages (Arch)
   sudo pacman -S openvpn wireguard-tools dialog
   ```

3. **XDG Directory Issues**
   ```bash
   # Check XDG environment
   echo $XDG_CONFIG_HOME
   echo $XDG_STATE_HOME
   
   # Create directories if missing
   mkdir -p ~/.config/vpnctl ~/.local/state/vpnctl
   ```

### Debug Mode
Enable debug logging:
```bash
VPNCTL_DEBUG=1 vpnctl connect my-profile
```

### Log Locations
- **User**: `~/.local/state/vpnctl/logs/`
- **System**: `/var/log/vpnctl/`

---

## 🚢 Release Process

### Semantic Versioning
- **MAJOR**: Breaking changes
- **MINOR**: New features (backward-compatible)
- **PATCH**: Bug fixes

### Release Commands
```bash
# Create release
just release 1.0.0
git tag -a v1.0.0 -m "Release v1.0.0"
git push origin v1.0.0
```

---

## 🔐 Security Considerations

### Credential Management
```bash
# Encrypt sensitive configs with GPG
gpg --encrypt --recipient your@email.com config.ini
```

### Privilege Separation
- Minimize root access
- Use `sudo` only for DNS/firewall tasks
- User-level operations when possible

---

## 📋 Development Checklist

### Phase 1: Core CLI
- [ ] Initialize Git repository
- [ ] Create project structure
- [ ] Implement `vpnctl connect`
- [ ] Implement `vpnctl fix-dns`
- [ ] Implement `vpnctl status`
- [ ] Add XDG-compliant logging

### Phase 2: TUI & User Experience
- [ ] Background monitor service
- [ ] Multi-VPN support
- [ ] Firewall integration

### Phase 3: Advanced Features
- [ ] TUI wrapper with dialog
- [ ] Error handling and retry logic
- [ ] GPG encryption support

### Phase 4: Testing & Release
- [ ] BATS test suite
- [ ] Multi-distro testing
- [ ] Package for AUR/DEB/RPM
- [ ] Documentation completion

---

## 📞 Quick Commands Reference

```bash
# Development
just --list              # Show all tasks
just lint                # Check code quality
just test                # Run tests

# Installation
just install-user        # User installation
just install-system      # System installation

# Container Development
just build-container      # Build dev container
just test-container      # Test in container
just shell-container     # Dev shell

# Release
just release 1.0.0       # Create release
git tag -a v1.0.0        # Tag release
```

---

## 🔗 Related Files

- [`README.md`](../README.md) - User documentation
- [`docs/development/ARCHITECTURE.md`](development/ARCHITECTURE.md) - Technical architecture
- [`docs/development/PLAN.md`](development/PLAN.md) - Development roadmap
- [`justfile`](../justfile) - Task automation
- [`Containerfile`](../Containerfile) - Container definition

---

**Last Updated**: 2025-09-26T06:43:08Z  
**Maintainer**: AI Assistant (claude 4 sonnet)