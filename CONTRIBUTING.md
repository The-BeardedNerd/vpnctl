# Contributing to VPNCTL

Thank you for considering contributing to VPNCTL! This document provides guidelines and information for contributors.

## 🎯 Quick Start

1. **Fork** the repository
2. **Clone** your fork: `git clone https://github.com/YOUR_USERNAME/vpnctl.git`
3. **Set up** development environment (see [Development Setup](#-development-setup))
4. **Create** a feature branch: `git checkout -b feature/amazing-feature`
5. **Make** your changes following our guidelines
6. **Test** your changes: `just test` or `make test`
7. **Commit** using conventional commits
8. **Push** and create a Pull Request

## 🛠️ Development Setup

### Prerequisites
- **Linux** (Arch, Ubuntu, Fedora supported)
- **Bash** 5.0+
- **just** (recommended) or **make**
- **Podman** or Docker
- **bats** (for testing)
- **shellcheck** (for linting)

### Quick Setup
```bash
# Install dependencies (Arch Linux)
sudo pacman -S openvpn wireguard-tools dialog bats shellcheck just podman

# Clone and setup
git clone https://github.com/The-BeardedNerd/vpnctl.git
cd vpnctl

# Run tests to verify setup
just test  # or: make test
```

### Container Development
For consistent development across distributions:

```bash
# Build all container environments
just build-containers

# Test across all distributions  
just test-containers

# Development shell in specific environment
just shell-container-arch    # Arch Linux
just shell-container-ubuntu  # Ubuntu
just shell-container-fedora  # Fedora
```

## 📏 Code Guidelines

### Shell Scripting Standards
- **Follow** [ShellCheck](https://shellcheck.net/) recommendations
- **Use** `set -euo pipefail` in all scripts
- **Quote** all variable expansions: `"$variable"`
- **Use** `readonly` for constants
- **Prefer** `[[ ]]` over `[ ]` for conditionals
- **Use** meaningful function names with snake_case

### Code Style
- **Indentation**: 4 spaces (no tabs)
- **Line length**: Max 100 characters
- **Functions**: Document with comments for complex logic
- **Error handling**: Always handle errors gracefully
- **Logging**: Use the project's logging functions

### Testing Requirements
- **All new features** must include tests
- **Bug fixes** should include regression tests  
- **Tests** must pass on all supported distributions
- **Use** BATS framework for shell script testing

## 📝 Commit Guidelines

We use [Conventional Commits](https://www.conventionalcommits.org/) for clear and automated versioning.

### Commit Format
```
<type>[optional scope]: <description>

[optional body]

[optional footer(s)]
```

### Types
- `feat:` - New feature (MINOR version bump)
- `fix:` - Bug fix (PATCH version bump)
- `docs:` - Documentation changes
- `test:` - Test additions or modifications
- `refactor:` - Code refactoring without feature changes
- `perf:` - Performance improvements
- `chore:` - Maintenance tasks
- `ci:` - CI/CD pipeline changes
- `BREAKING CHANGE:` - Breaking changes (MAJOR version bump)

### Examples
```bash
git commit -m "feat: add WireGuard profile support"
git commit -m "fix(dns): resolve DNS reset issue on Ubuntu"
git commit -m "docs: update installation instructions"
git commit -m "test: add DNS management test coverage"
```

### Scope Examples
- `cli` - CLI interface changes
- `tui` - TUI interface changes  
- `dns` - DNS management
- `config` - Configuration system
- `install` - Installation scripts
- `container` - Container/Docker changes

## 🔄 Pull Request Process

### Before Submitting
- [ ] **Fork** the repository and create a feature branch
- [ ] **Test** your changes: `just test` or `make test`
- [ ] **Lint** your code: `just lint` or `make lint`
- [ ] **Update** documentation if needed
- [ ] **Add** tests for new functionality
- [ ] **Follow** conventional commit guidelines

### PR Requirements
- **Clear title** describing the change
- **Detailed description** of what and why
- **Link** to related issues
- **Test results** from multiple distributions (if possible)
- **Screenshots/demos** for UI changes

### PR Template
```markdown
## Description
Brief description of changes

## Type of Change
- [ ] Bug fix
- [ ] New feature
- [ ] Breaking change
- [ ] Documentation update

## Testing
- [ ] Tests pass locally
- [ ] Tested on multiple distributions
- [ ] Added new tests for features

## Checklist
- [ ] Code follows project guidelines
- [ ] Self-review completed
- [ ] Documentation updated
- [ ] No breaking changes (or properly documented)
```

## 🧪 Testing

### Running Tests
```bash
# Run all tests
just test

# Run tests in containers (multi-distribution)
just test-containers

# Run specific test file
bats tests/cli_test.bats

# Debug mode
VPNCTL_DEBUG=1 bats tests/
```

### Writing Tests
- **Location**: `tests/` directory
- **Framework**: BATS (Bash Automated Testing System)
- **Naming**: `*_test.bats` files
- **Structure**: Use setup() and teardown() functions
- **Isolation**: Tests should not depend on each other

### Test Categories
- **Unit tests**: Individual function testing
- **Integration tests**: Component interaction testing
- **End-to-end tests**: Full workflow testing
- **Container tests**: Cross-distribution compatibility

## 🏗️ Project Structure

```
vpnctl/
├── .github/           # GitHub templates and workflows
├── bin/              # Executable scripts
├── config/           # Default configuration files
├── docs/             # Documentation
├── lib/              # Shared libraries (future)
├── scripts/          # Utility scripts
├── src/              # Source code (future modules)
├── tests/            # Test suites
│   ├── mocks/        # Mock dependencies for testing
│   └── *.bats        # BATS test files
├── Containerfile*    # Container definitions
├── justfile          # Task automation (recommended)
├── Makefile          # Task automation (fallback)
└── README.md         # Project documentation
```

## 🎨 Documentation

### Requirements
- **User documentation**: Update README.md for user-facing changes
- **Developer documentation**: Update relevant docs/ files
- **Code comments**: Document complex logic and algorithms
- **Changelog**: Follow conventional commits for automatic generation

### Documentation Types
- **README.md**: User installation and usage
- **docs/development/**: Technical architecture and planning
- **Code comments**: Inline documentation
- **Issue templates**: User support and feedback

## 🐛 Bug Reports

When reporting bugs:
1. **Search** existing issues first
2. **Use** the bug report template
3. **Include** system information
4. **Provide** reproduction steps
5. **Remove** sensitive information from logs

## ✨ Feature Requests

When requesting features:
1. **Check** existing roadmap
2. **Use** the feature request template
3. **Explain** the problem and use case
4. **Describe** the desired solution
5. **Consider** alternatives

## 🔒 Security

### Reporting Security Issues
- **Do NOT** create public issues for security vulnerabilities
- **Email** security concerns privately (contact info in README)
- **Include** detailed reproduction steps
- **Allow** reasonable time for response

### Security Guidelines
- **Never** commit secrets or credentials
- **Use** proper input validation
- **Follow** principle of least privilege
- **Test** for injection vulnerabilities

## 📋 Code Review Process

### For Contributors
- **Be responsive** to feedback
- **Ask questions** if unclear
- **Make requested changes** promptly
- **Test** changes thoroughly

### For Reviewers
- **Be constructive** and helpful
- **Focus** on code quality and correctness
- **Suggest** improvements, don't just criticize
- **Approve** when satisfied with changes

## 🏷️ Release Process

1. **Development** happens on feature branches
2. **Integration** via pull requests to `develop`
3. **Testing** and stabilization on `develop`
4. **Release** branch created from `develop`
5. **Merge** to `main` with version tag
6. **Automated** release creation via GitHub Actions

### Versioning
We use [Semantic Versioning](https://semver.org/):
- **MAJOR**: Breaking changes
- **MINOR**: New features (backward compatible)
- **PATCH**: Bug fixes

## 🤝 Community Guidelines

### Be Respectful
- **Welcome** newcomers and different perspectives
- **Use** inclusive language
- **Be patient** with questions and learning
- **Focus** on constructive feedback

### Communication Channels
- **Issues**: Bug reports and feature requests
- **Discussions**: General questions and ideas
- **Pull Requests**: Code contributions
- **Email**: Security concerns and private matters

## 📚 Resources

- [Conventional Commits](https://www.conventionalcommits.org/)
- [ShellCheck](https://shellcheck.net/)
- [BATS Testing](https://bats-core.readthedocs.io/)
- [XDG Base Directory Specification](https://specifications.freedesktop.org/basedir-spec/latest/)
- [Semantic Versioning](https://semver.org/)

## 🙋 Getting Help

- **Read** the documentation first
- **Search** existing issues and discussions
- **Ask** questions using the question template
- **Join** discussions for general topics
- **Be patient** - maintainers are volunteers

---

Thank you for contributing to VPNCTL! Every contribution helps make VPN management easier for everyone. 🎉