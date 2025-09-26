# VPNCTL: Development Plan

## **Phase 1: Core CLI**
- [ ] Define project scope (user/system-level VPN management).
- [ ] Finalize command name (`vpnctl`).
- [ ] Design XDG-compliant directory structure.
- [ ] Draft installation/uninstall scripts.
- [ ] Implement `vpnctl connect` with:
  - Profile selection.
  - Auto-switching logic.
  - Privilege escalation for system tasks.
- [ ] Implement `vpnctl fix-dns`:
  - Context-aware DNS reset (VPN vs. system default).
- [ ] Implement `vpnctl status`:
  - Show connection, IP, DNS, uptime.
- [ ] Add logging to `$XDG_STATE_HOME/vpnctl/logs/`.

## **Phase 2: TUI & User Experience**
- [ ] Background monitor (systemd/user service).
- [ ] Multi-VPN support (ProtonVPN, OpenVPN, WireGuard).
- [ ] Firewall integration (auto-block if VPN drops).

## **Phase 3: Advanced Features**
- [ ] Build TUI wrapper (`vpnctl-tui`) using `dialog`:
  - Interactive profile selection.
  - Real-time status/logs.
- [ ] Add error handling and user prompts (e.g., retry on failure).

---

## **Phase 4: Testing & Release**
- [ ] Write BATS tests for CLI.
- [ ] Write BATS test for TUI (if needed, otherwise specify 'Not Needed' and why).
- [ ] Test on Arch/Ubuntu/Fedora.
- [ ] Package for AUR/DEB/RPM.
- [ ] Adopt **Semantic Versioning** (`MAJOR.MINOR.PATCH`):
  - `MAJOR`: Breaking changes.
  - `MINOR`: New features (backward-compatible).
  - `PATCH`: Bug fixes.
  - Use `git tag -a v1.0.0 -m "Release v1.0.0"` for releases.
- [ ] Document `git` workflow and `gpg` usage.

---

## **Development Process**
- **Version Control**: `git` with feature branches and PRs.
  - `master` branch for stable releases.
  - `develop` branch for integration.
  - Feature branches prefixed with `feature/`, `fix/`, `docs/`, etc.
  - Pull Requests (PR) required for merging into `develop`/`main`.
- **Commit Messages**: Follow [Conventional Commits](https://www.conventionalcommits.org)
  ```
  <type>[optional scope]: <descrition>
  [optional body]
  [optional footer(s)]
  ```
  - *Types*: `fix:`, `feat:`, `build:`, `chore:`, `ci:`, `docs:`, `style:`, `refactor:`, `perf:`, `test:` and others.
  - **`fix`**: a commit of the *type* `fix` patches a bug in the codebase (this correlates with `PATCH` in Semantic Versioning)
  - `feat`: a commit of the type `feat` introduces a new feature to the codebase (this correlates with `MINOR` in Semantic Versioning)
  - `BREAKING CHANGE`: a commit that has a footer `BREAKING CHANGE:`, or appends a `!` after the type/scope, introduces a breaking API change (correlating with `MAJOR` in Semantic Versioning). A BREAKING CHANGE can be part of commits of any *type*
- **Tags**: Use annotated tags for releases (e.g., `v0.1.0`).
- **Security**: Use `gpg` to encrypt credentials.
- **Releases**: Tagged with semantic versioning.

## **Checklist for MVP**
| Task                          | Status  | Notes                               |
|-------------------------------|---------|-------------------------------------|
| Hybrid user/system install    | ⬜ Todo | `install.sh` handles both.            |
| XDG-compliant paths           | ⬜ Todo | Uses `$XDG_*` with fallbacks.         |
| `connect` command               | ⬜ Todo | Needs OpenVPN/WireGuard logic.      |
| `fix-dns` command               | ⬜ Todo | Use `resolvectl`/`systemd-resolve`.     |
| Privilege escalation          | ⬜ Todo | `sudo` only for system tasks.         |
| TUI prototype                 | ⬜ Todo | Use `dialog` for menus.               |
| Documentation                 | ⬜ Todo | Fill `README.md` and manpage.         |


---

## **Roadmap**
### **v0.1 (MVP)**
- CLI: `connect`, `disconnect`, `status`, `fix-dns`.
- User-level install only.
- Supports OpenVPN configs.

### **v0.2**
- System-wide install mode.
- TUI wrapper.
- WireGuard support.

### **v1.0**
- Background monitor.
- Firewall integration.
- Package repositories.

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
