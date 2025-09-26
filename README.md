# VPNCTL: VPN Manager for Linux

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![CI/CD Pipeline](https://github.com/The-BeardedNerd/vpnctl/actions/workflows/ci.yml/badge.svg)](https://github.com/The-BeardedNerd/vpnctl/actions/workflows/ci.yml)
[![GitHub release (latest SemVer)](https://img.shields.io/github/v/release/The-BeardedNerd/vpnctl)](https://github.com/The-BeardedNerd/vpnctl/releases)

**A CLI/TUI tool to manage VPN connections with XDG compliance and hybrid user/system access.**

> **⚠️ Development Status**: This project is in active development. Core functionality is being implemented. See [Project Plan](docs/development/PLAN.md) for current status and roadmap.

---

## **Features**
- ✅ **Hybrid Install**: Works for single users or system-wide.
- ✅ **XDG Compliant**: Configs/logs in standard locations.
- ✅ **Privilege-Aware**: Uses `sudo` only when necessary.
- ✅ **ProtonVPN/OpenVPN/WireGuard Support**.
- ✅ **Interactive TUI** (optional).

---

## **Installation**
### **User-Level (Recommended)**
```bash
git clone https://github.com/The-BeardedNerd/vpnctl.git
cd vpnctl
./scripts/install.sh
```

### **System-Wide**
```bash
sudo ./scripts/install.sh
```

### **Uninstall**
```bash
# TODO: Create uninstall script
# ./scripts/uninstall.sh  # or sudo ./scripts/uninstall.sh
```

---

## **Usage**
### **CLI**
```bash
vpnctl connect my-profile      # Connect to VPN
vpnctl fix-dns                 # Reset DNS
vpnctl status                  # Show connection info
```

### **TUI**
```bash
vpnctl-tui  # Launch interactive menu
```

---

## **Configuration**
- **User Config**: `~/.config/vpnctl/config.ini`
- **System Config**: `/etc/vpnctl/config.ini`
- **Profiles**: Store `.ovpn`/`.conf` files in `profiles/` subdir.

---

## **Examples**
1. **Add a Profile**:
   ```bash
   vpnctl add ~/Downloads/proton.ovpn
   ```
2. **Connect**:
   ```bash
   vpnctl connect proton
   ```
3. **Monitor (Background)**:
   ```bash
   sudo systemctl enable --now vpnctl-monitor  # System-wide
   systemctl --user enable --now vpnctl-monitor  # User-level
   ```

---

## **Troubleshooting**
- **Logs**: Check `$XDG_STATE_HOME/vpnctl/logs/` or `/var/log/vpnctl/`.
- **Debug Mode**: Run with `VPNCTL_DEBUG=1`.

---
## **Contributing**

We welcome contributions! Please see our [Contributing Guide](CONTRIBUTING.md) for details.

**Quick Start for Contributors:**
1. Fork the [repository](https://github.com/The-BeardedNerd/vpnctl)
2. Create a feature branch: `git checkout -b feature/amazing-feature`
3. Make your changes and test: `just test` or `make test`
4. Commit with [Conventional Commits](https://www.conventionalcommits.org/)
5. Push and create a Pull Request

**Development Environment:**
- Multi-distribution testing (Arch, Ubuntu, Fedora)
- Containerized development with Podman
- BATS testing framework
- Automated CI/CD pipeline

---
## **Releases**
Follows [Semantic Versioning](https://semver.org/).
- Check the [releases page](https://github.com/The-BeardedNerd/vpnctl/releases) for stable versions.
- Stable: `v1.0.0`
- Pre-release: `v0.2.0-alpha` (may include experimental features)

---
## **Secure Configs**
Encrypt with GPG:
```bash
gpg --encrypt --recipient your@email.com config.ini
```

## Automation
This project supports both `just` and `make` for task automation.

### Using `just` (Recommneded)
1. Install `just`:
              `cargo install just` or use your package manager.
2. Run Tasks:
    ```
    just install-user     # Install for current user
    just test             # Run tests
    just lint             # Lint shell scripts
    ```

### Using `make` (Fallback)
if you don't have `just`, use `make`:
```
make install      # Install `vpnctl`
make test         # Run tests
make lint         # Lint shell scripts
make release      # Package a release
```

### Available Tasks
| Task             | `just` Command         | `make` Command        |
-----------------------------------------------------------------
| Install (user)   | `just install-user`    | `make install-user`   |
| Install (system) | `just install-system`  | `make install-system` |
| Lint             | `just lint`            | `make lint`           |
| Test             | `just test`            | `make test`           |
| Release          | `just release 1.0.0`   | `make release`        |
| Clean            | `just clean`           | `make clean`          |

---
## **Containerized Development**
Use Docker or Podman to run `vpnctl` in an isolated environment.

### **Prerequisites**
- Install [Docker](https://docs.docker.com/get-docker/), [Podman](https://podman.io/) (Recommneded), or Distrobox (for faster development).

### **Build the Container**
```bash
just build-container  # or make build-container
```

### **Run Tests in a Container**
```bash
just test-container  # or make test-container
```

### **Enter a Development Shell**
```bash
just shell-container  # or make shell-container
```

### **Container Files**
| File               | Purpose                          |
|--------------------|----------------------------------|
| `Containerfile`    | Defines the container image.     |
| `docker-compose.yml` | For multi-container setups.     |

---
## **Example: Containerfile**
```dockerfile
FROM alpine:latest

# Install dependencies
RUN apk add --no-cache \
    openvpn \
    wireguard-tools \
    bash \
    dialog \
    bats \
    shellcheck \
    git \
    make \
    just

# Copy project files
WORKDIR /vpnctl
COPY . .

# Set up entrypoint
ENTRYPOINT ["just"]
```
