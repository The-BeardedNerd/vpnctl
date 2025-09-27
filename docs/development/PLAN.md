# VPNCTL: Development Plan

**Updated**: 2025-09-26T12:00:00Z  
**Status**: Infrastructure Complete - VPN Implementation Phase

## **✅ Phase 1: Infrastructure (COMPLETED)**
- [x] **Define project scope**: User/system-level VPN management with XDG compliance
- [x] **Finalize command name**: `vpnctl` with comprehensive CLI interface
- [x] **XDG-compliant directory structure**: Full implementation with fallbacks
- [x] **Installation/uninstall scripts**: Automatic user/system detection and setup
- [x] **Professional CI/CD pipeline**: GitHub Actions with multi-distribution testing
- [x] **Comprehensive testing framework**: 15 BATS tests across 3 distributions  
- [x] **Container development environment**: Arch, Ubuntu, Fedora support
- [x] **Branch protection and quality gates**: Automated enforcement
- [x] **Documentation framework**: Complete architectural and user guides
- [x] **CLI framework foundation**: Command structure and error handling
- [x] **XDG-compliant logging**: Full implementation to `$XDG_STATE_HOME/vpnctl/logs/`

## **🚧 Phase 2: Core VPN Functionality (IN PROGRESS)**
- [ ] **Implement `vpnctl connect`** with:
  - OpenVPN profile parsing and validation
  - Process lifecycle management
  - Auto-switching logic
  - Privilege escalation for system tasks
- [ ] **Implement `vpnctl disconnect`**:
  - Graceful connection termination
  - Process cleanup and resource management
- [ ] **Implement `vpnctl fix-dns`**:
  - Context-aware DNS reset (VPN vs. system default)
  - systemd-resolved integration
- [ ] **Implement `vpnctl status`**:
  - Connection status monitoring
  - IP address detection
  - DNS configuration display
  - Connection uptime tracking
- [ ] **Enhanced profile management**:
  - `vpnctl add` - Profile import and validation
  - `vpnctl remove` - Safe profile deletion

## **📋 Phase 3: Advanced Features (PLANNED)**
- [ ] **WireGuard support**:
  - WireGuard configuration parsing
  - wg-quick integration
  - Multi-protocol profile management
- [ ] **TUI wrapper (`vpnctl-tui`)**:
  - Interactive profile selection using `dialog`
  - Real-time status monitoring
  - Live log display
  - Connection management interface
- [ ] **Background monitoring service**:
  - Connection health monitoring
  - Auto-reconnect functionality
  - systemd/user service integration
- [ ] **Firewall integration**:
  - Kill switch implementation
  - Auto-block traffic if VPN drops
  - iptables/nftables integration
- [ ] **Advanced error handling**:
  - Retry logic with exponential backoff
  - User prompts for connection failures
  - Intelligent error recovery

---

## **🚀 Phase 4: Distribution & Release (FUTURE)**
- [x] **BATS test suite**: 15 comprehensive tests implemented
- [x] **Multi-distribution testing**: Automated testing on Arch/Ubuntu/Fedora
- [x] **CI/CD pipeline**: Complete GitHub Actions automation
- [x] **Semantic versioning adoption**: Implemented with conventional commits
- [x] **Git workflow documentation**: Professional branching and PR process
- [ ] **TUI testing**: BATS tests for TUI components (when implemented)
- [ ] **Package distribution**:
  - AUR (Arch User Repository)
  - DEB packages (Ubuntu/Debian)
  - RPM packages (Fedora/RHEL)
- [ ] **Release automation**:
  - Automated changelog generation
  - Binary distribution
  - GitHub releases integration

---

## **✅ Development Process (IMPLEMENTED)**
- **✅ Version Control**: Professional Git workflow implemented
  - `master` branch for stable releases with branch protection
  - `develop` branch for integration and active development
  - Feature branches with conventional naming
  - GitHub Actions CI/CD enforcing quality gates
- **✅ Commit Messages**: [Conventional Commits](https://www.conventionalcommits.org) enforced
  ```
  <type>[optional scope]: <description>
  [optional body]
  [optional footer(s)]
  ```
  - **Implemented types**: `feat:`, `fix:`, `docs:`, `test:`, `chore:`, `ci:`
  - **Automatic versioning**: Based on conventional commit types
  - **Breaking changes**: `!` and `BREAKING CHANGE:` footer support
- **✅ Quality Assurance**: Automated enforcement via CI/CD
  - ShellCheck linting for all shell scripts
  - Multi-distribution testing (Arch, Ubuntu, Fedora)
  - Security scanning and secret detection
  - Branch protection preventing direct pushes to master
- **✅ Container Development**: Isolated, reproducible environments
- **🚧 Security**: GPG credential encryption (planned for VPN profiles)
- **✅ Documentation**: Comprehensive architectural and user documentation

## **✅ Infrastructure Checklist (COMPLETED)**
| Task                          | Status  | Implementation                      |
|-------------------------------|---------|-------------------------------------|
| Hybrid user/system install    | ✅ Done | `scripts/install.sh` auto-detects mode |
| XDG-compliant paths           | ✅ Done | Full XDG implementation with fallbacks |
| Professional CI/CD            | ✅ Done | GitHub Actions multi-distribution   |
| Comprehensive testing         | ✅ Done | 15 BATS tests across 3 distributions|
| Container development         | ✅ Done | Arch, Ubuntu, Fedora environments  |
| Branch protection             | ✅ Done | Quality gates and automated checks  |
| CLI framework                 | ✅ Done | Command structure and error handling |
| Documentation                 | ✅ Done | Complete architectural guides       |

## **🚧 VPN Core Checklist (IN PROGRESS)**
| Task                          | Status   | Notes                               |
|-------------------------------|----------|-------------------------------------|
| `connect` command             | 🚧 Todo  | OpenVPN process management needed   |
| `disconnect` command          | 🚧 Todo  | Graceful connection termination     |
| `status` command              | 🚧 Todo  | Connection monitoring implementation |
| `fix-dns` command             | 🚧 Todo  | systemd-resolved integration        |
| Profile management            | 🚧 Todo  | Add/remove VPN configurations       |
| Privilege escalation          | ✅ Done | Smart `sudo` usage implemented      |

## **📋 Future Checklist (PLANNED)**
| Task                          | Status   | Notes                               |
|-------------------------------|----------|-------------------------------------|
| WireGuard support             | 📋 Future| After OpenVPN implementation        |
| TUI prototype                 | 📋 Future| `dialog`-based interactive interface |
| Background service            | 📋 Future| systemd service integration         |
| Package distribution          | 📋 Future| AUR, DEB, RPM packages             |


---

## **📋 Updated Roadmap**

### **✅ v0.1 (Infrastructure) - COMPLETED**
- Professional development infrastructure
- Multi-distribution CI/CD pipeline
- Comprehensive testing framework (15 BATS tests)
- User and system installation modes
- XDG-compliant architecture
- Container-based development
- Branch protection and quality gates

### **🚧 v0.2 (VPN Core) - IN PROGRESS**
- CLI: `connect`, `disconnect`, `status`, `fix-dns`
- OpenVPN profile management
- Connection lifecycle management
- DNS configuration handling
- Enhanced error handling and validation

### **📋 v0.3 (Enhanced Features) - PLANNED**
- WireGuard support
- TUI wrapper with `dialog`
- Advanced profile management
- Connection monitoring and health checks

### **📋 v1.0 (Production Ready) - FUTURE**
- Background monitoring service
- Kill switch and firewall integration
- Package distribution (AUR, DEB, RPM)
- GPG credential encryption
- Systemd service integration

---

## Development Process
- **Version Control**: Use `git` with feature branches and Pull Requests.
- **Automation**: Use a `Makefile` or `justfile` (recommended) to automate:
  - Installation (`make install-user`, `just install-user`).
  - Testing (`make test`, `just test`).
  - Linting (`make lint`, `just lint`).
  - Releases (`make release`, `just release 1.0.0`)
- **Containerization**:
  - Use `podman` (recommended) or `docker` for isolated development/testing environments
  - Provide a `Containerfile` or `Dockerfile` to build a container with all dependencies
  - Include a `just`/`make` target to run tests in a container (e.g., `just test-container`).
  - For 
- **Security**: Use `gpg` to encrypt credentials.
- **Releases**: Tagged with semantic versioning.
