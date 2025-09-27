# VPNCTL: Architecture

**Updated**: 2025-09-26T11:40:00Z  
**Status**: Infrastructure Complete - VPN Implementation Phase

## **Design Goals (Achieved ✅)**
1. ✅ **XDG Compliance**: Full respect for `$XDG_*` directories with fallbacks
2. ✅ **Hybrid Access**: Dynamic user/system mode based on `$EUID`
3. ✅ **Minimal Dependencies**: Bash + standard VPN tools, no exotic dependencies
4. ✅ **Privilege Separation**: Smart `sudo` usage only when necessary
5. ✅ **Professional CI/CD**: Multi-distribution testing and validation
6. ✅ **Container-Native Development**: Isolated testing environments
7. ✅ **Comprehensive Testing**: 15 BATS tests with full automation

---

## **Components (Implemented Architecture)**

### **1. Core CLI (`bin/vpnctl`) ✅**
- **Language**: Pure Bash (portable, no Python dependency)
- **Features**: 
  - ✅ XDG-compliant directory management
  - ✅ Dynamic user/system mode detection
  - ✅ Comprehensive logging with levels
  - ✅ Smart dependency checking
  - ✅ Error handling and validation

- **Commands** (Implementation Status):
  | Command   | Status | Action                    | Privileges       |
  |-----------|--------|---------------------------|------------------|
  | `help`    | ✅     | Show usage information    | None             |
  | `version` | ✅     | Display version info      | None             |
  | `list`    | ✅     | List VPN profiles         | None             |
  | `logs`    | ✅     | Show application logs     | None             |
  | `connect` | 🚧     | Start VPN connection      | `sudo` (system)  |
  | `disconnect` | 🚧  | Stop VPN connection       | `sudo` (system)  |
  | `status`  | 🚧     | Show connection status    | None             |
  | `add`     | 🚧     | Add VPN profile           | None             |
  | `remove`  | 🚧     | Remove VPN profile        | None             |
  | `fix-dns` | 🚧     | Reset DNS configuration   | `sudo`           |

### **2. Installation System (`scripts/install.sh`) ✅**
- **Auto-Detection**: Automatically detects user vs system install mode
- **User Mode**: `~/.local/bin/vpnctl`, `~/.config/vpnctl/`, `~/.local/state/vpnctl/`
- **System Mode**: `/usr/local/bin/vpnctl`, `/etc/vpnctl/`, `/var/log/vpnctl/`
- **Dependency Checking**: Validates OpenVPN, WireGuard availability
- **XDG Fallbacks**: Handles missing XDG environment variables

### **3. Testing Framework (`tests/`) ✅**
- **BATS Framework**: 15 comprehensive shell script tests
- **Test Isolation**: Each test runs in isolated temporary environment
- **Multi-Context**: Tests both user and root execution contexts
- **Mock Dependencies**: Isolated testing without system VPN tools
- **Coverage**: CLI commands, directory creation, error handling, installation

### **4. CI/CD Pipeline (`.github/workflows/ci.yml`) ✅**
- **Multi-Distribution**: Arch Linux, Ubuntu 22.04, Fedora
- **Container-Based**: Isolated Podman containers for each distribution
- **Comprehensive Checks**: Linting, security, testing, installation
- **Branch Protection**: Enforced quality gates before merge
- **Automated**: Full automation with GitHub Actions

---

## **Data Flow**
1. **User runs `vpnctl connect profile`**:
   - Script checks `$XDG_CONFIG_HOME/vpnctl/profiles/` or `/etc/vpnctl/profiles/`.
   - Calls `openvpn`/`wg-quick` with `sudo` if needed.
   - Logs to `$XDG_STATE_HOME/vpnctl/logs/`.

2. **TUI Workflow**:
   - Lists profiles from config dir.
   - Calls CLI commands (e.g., `vpnctl connect`).

---

## **Container Architecture ✅**

### **Multi-Distribution Support**
The project supports development and testing across three Linux distributions:

**Container Images:**
- **`Containerfile`** - Arch Linux (primary development)
- **`Containerfile.ubuntu`** - Ubuntu 22.04 LTS (broad compatibility) 
- **`Containerfile.fedora`** - Fedora (RHEL ecosystem)

### **Container Features**
- ✅ **Isolated Environments**: Each distribution in separate containers
- ✅ **Development Tools**: Pre-installed BATS, ShellCheck, just/make
- ✅ **VPN Dependencies**: OpenVPN, WireGuard tools in each image
- ✅ **Consistent Testing**: Same test suite across all distributions

### **Container Usage**
```bash
# Build all containers
podman build -t vpnctl:arch -f Containerfile .
podman build -t vpnctl:ubuntu -f Containerfile.ubuntu .
podman build -t vpnctl:fedora -f Containerfile.fedora .

# Run tests in specific distribution
podman run --rm -v $(pwd):/vpnctl:Z -w /vpnctl vpnctl:arch test

# Development shell
podman run --rm -it -v $(pwd):/vpnctl:Z -w /vpnctl vpnctl:ubuntu bash
```

---

## **Quality Assurance System ✅**

### **Automated Testing Pipeline**
1. **🔍 Lint & Validate**:
   - ShellCheck static analysis
   - Project structure validation
   - File permission checks

2. **🔒 Security & Quality**:
   - Secret detection scanning
   - File permission validation
   - Container security checks

3. **🧪 Multi-Distribution Testing**:
   - 15 BATS tests per distribution
   - Installation script validation
   - User vs root context testing

### **Test Coverage (15 Tests)**
1. Help and version display
2. Profile listing functionality
3. Command argument validation
4. Error handling robustness
5. XDG directory creation
6. Logging functionality
7. Installation verification
8. Root vs user privilege detection
9. Configuration file handling
10. Mock dependency integration
11. Debug mode operation
12. Command-line parsing
13. Graceful error recovery
14. Environment isolation
15. Cross-distribution compatibility

### **Branch Protection**
- ✅ All CI checks must pass
- ✅ No force pushes allowed
- ✅ No branch deletion
- ✅ Automatic status check enforcement

---

## **Current Dependencies**
| Tool          | Status | Purpose                          | Required For          |
|---------------|--------|----------------------------------|-----------------------|
| **bash**      | ✅     | Core scripting language         | All functionality     |
| **bats**      | ✅     | Testing framework                | Development/CI        |
| **shellcheck**| ✅     | Shell script linting             | Development/CI        |
| **podman**    | ✅     | Container runtime                | Development/CI        |
| **just**      | ✅     | Task automation (primary)        | Development           |
| **make**      | ✅     | Task automation (fallback)       | Development           |
| **OpenVPN**   | 🚧     | VPN connections (CLI)            | Runtime (planned)     |
| **WireGuard** | 🚧     | Alternative VPN backend          | Runtime (planned)     |
| **dialog**    | 📋     | TUI menus                        | TUI (planned)         |
| **resolvectl**| 🚧     | DNS management                   | DNS features (planned)|
| **systemd**   | 📋     | Background monitor               | Service (planned)     |

---

## **Error Handling**
- **CLI**: Exit codes + stderr messages.
- **TUI**: User prompts (e.g., "Retry connection?").
- **Logs**: All actions written to `$XDG_STATE_HOME/vpnctl/logs/`.

---

## **Implementation Status Summary**

### **✅ Phase 1: Infrastructure (COMPLETED)**
- **Project Structure**: Professional directory layout with proper organization
- **CI/CD Pipeline**: GitHub Actions with multi-distribution testing
- **Testing Framework**: 15 BATS tests covering all current functionality
- **Container Support**: Three distribution containers (Arch, Ubuntu, Fedora)
- **Installation System**: Automatic user/system detection and setup
- **Documentation**: Comprehensive guides and architectural documentation
- **Quality Assurance**: Linting, security scanning, branch protection
- **XDG Compliance**: Full compliance with Linux desktop standards
- **Privilege Management**: Smart root/user detection and separation

### **🚧 Phase 2: VPN Core (IN PROGRESS)**
- **CLI Framework**: Basic command structure implemented
- **Configuration**: Profile management foundation ready
- **Logging**: Comprehensive logging system operational
- **Error Handling**: Robust error management framework

**Next Implementation Steps:**
1. `vpnctl connect` - OpenVPN connection management
2. `vpnctl disconnect` - Connection termination
3. `vpnctl status` - Connection status monitoring
4. `vpnctl add/remove` - Profile management
5. `vpnctl fix-dns` - DNS configuration reset

### **📋 Phase 3: Advanced Features (PLANNED)**
- **WireGuard Support**: Modern VPN protocol integration
- **TUI Interface**: Interactive terminal interface
- **Background Service**: Connection monitoring and auto-reconnect
- **GPG Encryption**: Secure credential storage
- **Systemd Integration**: Service management

---

## **Security Model ✅**
- **✅ Privilege Separation**: Implemented - minimal root access
- **✅ Environment Isolation**: Container-based testing prevents system contamination
- **✅ Secret Scanning**: Automated detection of sensitive data in CI/CD
- **✅ Branch Protection**: Enforced code quality gates
- **🚧 GPG Encryption**: Planned for sensitive VPN credentials
- **🚧 Input Validation**: Enhanced validation for VPN configurations

## **Task Automation ✅**
Implemented with both `justfile` (primary) and `Makefile` (fallback):

**Available Commands:**
```bash
# Primary (just)
just install-user        # User installation
just install-system      # System installation
just test               # Run BATS tests
just lint               # ShellCheck validation
just clean              # Clean artifacts

# Fallback (make)
make install-user       # User installation
make install-system     # System installation
make test              # Run BATS tests
make lint              # ShellCheck validation
make clean             # Clean artifacts
```

---

## **Next Architecture Phases**

### **Immediate (VPN Core Implementation)**
1. **Connection Management**: OpenVPN process lifecycle
2. **Profile System**: VPN configuration parsing and validation
3. **Network Integration**: Interface and routing management
4. **DNS Management**: Automatic DNS configuration
5. **Status Monitoring**: Real-time connection health

### **Future Enhancements**
1. **WireGuard Integration**: Modern VPN protocol support
2. **Service Architecture**: Background monitoring daemon
3. **TUI Development**: Interactive user interface
4. **Package Distribution**: AUR, DEB, RPM packages
5. **Advanced Security**: GPG credential encryption
