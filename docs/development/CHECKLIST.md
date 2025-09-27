# VPNCTL Development Checklist

Quick reference checklist for vpnctl development workflow compliance.

## 🚀 Pre-Development Setup

### Branch Validation
- [ ] On `develop` branch: `git branch --show-current`
- [ ] Branch is up to date: `git pull origin develop`
- [ ] Clean working directory: `git status --porcelain` (should be empty)

## ✏️ During Development

### Code Quality Standards
- [ ] Follow conventional commit format: `type: description`
- [ ] ShellCheck compliance: `make lint` (zero warnings)
- [ ] Test coverage for new features
- [ ] Use existing mocks: `tests/mocks/` directory
- [ ] Proper error handling with `error_exit` function
- [ ] Structured logging with `log` function levels

### Testing Requirements  
- [ ] Run local tests: `make test`
- [ ] All BATS tests pass: 26+ tests, 100% pass rate
- [ ] Test individual files: `bats tests/cli_test.bats`
- [ ] Debug mode testing: `VPNCTL_DEBUG=1 make test`
- [ ] Multi-distribution testing: `just test-containers` (optional)

## 📝 Pre-Commit Checklist

### Mandatory Checks
- [ ] **Lint validation**: `make lint` ✅ ZERO warnings
- [ ] **Test suite**: `make test` ✅ ALL tests pass
- [ ] **Commit format**: Conventional commits (feat:, fix:, docs:, test:)
- [ ] **Documentation**: Updated README/wiki if needed
- [ ] **No secrets**: No hardcoded credentials or sensitive data

### Commit Message Format
```
type[scope]: description

[optional body]

[optional footer - BREAKING CHANGE: details]
```

**Examples:**
- `feat: implement status command with real-time monitoring`
- `fix: resolve connection timeout in OpenVPN integration`  
- `docs: update README with status command examples`
- `test: add comprehensive tests for status command`

## 🚢 Pre-Push Checklist  

### Local Validation
- [ ] All changes committed: `git status` (clean)
- [ ] Proper commit messages: `git log --oneline -5`
- [ ] Local tests passing: Recent `make test` success
- [ ] Branch ready: `develop` branch with all changes

### Push and Validate
- [ ] Push to origin: `git push origin develop`
- [ ] Wait for CI/CD: 30-60 seconds for pipeline start
- [ ] Check CI status: `gh run list --branch develop --limit 1`
- [ ] All checks passing: ✅ 5/5 required status checks

## 📋 Pre-PR Checklist

### PR Prerequisites  
- [ ] All CI/CD checks passing on develop
- [ ] Documentation updated:
  - [ ] README.md (if user-facing changes)
  - [ ] Changelog.md (feature additions)  
  - [ ] Wiki pages (if needed)
- [ ] Breaking changes documented
- [ ] Test coverage complete

### PR Creation
- [ ] Comprehensive title: `feat: implement {feature description}`
- [ ] Detailed description:
  - [ ] Feature overview
  - [ ] Implementation details
  - [ ] Breaking changes (if any)
  - [ ] Testing results
  - [ ] Documentation updates
- [ ] Proper base/head: `--base master --head develop`

### PR Command
```bash
gh pr create \
  --title "feat: implement {feature description}" \
  --body "{comprehensive description}" \
  --base master \
  --head develop
```

## ✅ Pre-Merge Validation

### PR Status Checks
- [ ] All required CI/CD checks passing (13/13):
  - [ ] 🔍 Lint & Validate
  - [ ] 🔒 Security & Quality  
  - [ ] 🧪 Test on arch
  - [ ] 🧪 Test on ubuntu
  - [ ] 🧪 Test on fedora
- [ ] PR status: "All checks were successful"
- [ ] No merge conflicts
- [ ] Branch protection rules satisfied

### Merge Process
- [ ] Use squash merge: `gh pr merge {PR} --squash --admin`
- [ ] Verify merge success: PR shows "Merged"
- [ ] Update local master: 
  ```bash
  git checkout master
  git pull origin master
  ```
- [ ] Switch back to develop: `git checkout develop`

## 🔄 Post-Merge Tasks

### Documentation Updates
- [ ] Update wiki changelog: `vpnctl.wiki/Changelog.md`  
- [ ] Commit wiki changes: Conventional commits
- [ ] Push wiki updates: `git push origin master`

### Next Development Cycle
- [ ] Clean up feature branches (if any)
- [ ] Update develop branch: `git pull origin develop` (may need merge)
- [ ] Ready for next feature development

## 🚨 Emergency Procedures

### CI/CD Failures
1. **ShellCheck failures**: Fix all warnings in affected files
2. **Test failures**: Debug with `VPNCTL_DEBUG=1 make test`  
3. **Container failures**: Test locally with `just shell-container-{distro}`
4. **Security failures**: Remove any flagged security issues

### Merge Conflicts
1. **On develop**: `git pull origin develop` and resolve
2. **On PR**: Update develop first, then rebase/merge
3. **Force resolution**: Communicate with team before force-push

### Rollback Procedures
1. **Bad commit**: `git revert {commit-hash}`
2. **Bad merge**: Create hotfix branch from last good master
3. **Emergency**: Contact repository maintainer

## 📊 Quality Metrics

### Success Criteria
- ✅ **CI/CD**: 13/13 status checks passing
- ✅ **Tests**: 26+ BATS tests, 100% pass rate  
- ✅ **Code Quality**: Zero ShellCheck warnings
- ✅ **Documentation**: All relevant docs updated
- ✅ **Security**: No secrets or security issues
- ✅ **Process**: Proper branch protection compliance

### Performance Standards
- **Test Runtime**: < 5 minutes for full test suite
- **CI/CD Runtime**: < 10 minutes for complete pipeline
- **Code Review**: PR description comprehensive enough for self-review
- **Documentation**: Changes are self-explanatory with proper docs

## 🔧 Quick Commands

### Development Commands
```bash
# Setup
git checkout develop && git pull origin develop

# Development  
make lint          # Lint check
make test          # Test suite
just test          # Alternative test runner

# Advanced testing
just build-containers       # Multi-distro testing
bats tests/cli_test.bats    # Specific test file
VPNCTL_DEBUG=1 make test    # Debug mode

# Validation
git status --porcelain      # Check clean state
gh run list --limit 1       # Check CI status

# PR workflow
gh pr create --base master --head develop
gh pr checks {PR_NUMBER}    # Check PR status  
gh pr merge {PR_NUMBER} --squash --admin
```

### Project Commands  
```bash
# Installation
./scripts/install.sh       # User install
sudo ./scripts/install.sh  # System install

# Usage testing
vpnctl help                # Basic functionality
vpnctl list                # Profile listing
vpnctl logs                # Log checking
```

---

**✅ Remember: ALL items must be checked before proceeding to next phase**

**🚫 NO exceptions to quality gates - maintain professional standards**

**🔄 This checklist ensures reliable, production-ready code delivery**