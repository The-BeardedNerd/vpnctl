# Security Policy

## Supported Versions

VPNCTL follows semantic versioning. Security updates are provided for:

| Version | Supported          |
| ------- | ------------------ |
| 0.1.x   | :white_check_mark: |
| < 0.1   | :x:                |

## Reporting a Vulnerability

### 🔒 Private Disclosure Process

If you discover a security vulnerability, please follow responsible disclosure:

1. **DO NOT** create a public GitHub issue
2. **Email**: the-beardednerd@pm.me (or use GitHub's security advisory feature)
3. **Include**: 
   - Detailed description of the vulnerability
   - Steps to reproduce
   - Potential impact assessment
   - Suggested fix (if available)

### 📧 Contact Methods

- **GitHub Security Advisory**: [Create Advisory](https://github.com/The-BeardedNerd/vpnctl/security/advisories/new)
- **Email**: [Create a security contact if needed]
- **Expected Response**: Within 48 hours

### 🛡️ Security Scope

**In Scope:**
- VPN credential handling
- Configuration file security
- Privilege escalation vulnerabilities
- DNS manipulation attacks
- Shell injection in user inputs
- File system permission issues

**Out of Scope:**
- Social engineering
- Physical access attacks
- Third-party VPN provider vulnerabilities
- Dependencies (report to upstream)

## Security Features

### Current Protections
- ✅ **Input validation** for all user inputs
- ✅ **Privilege separation** - minimal sudo usage
- ✅ **XDG compliance** - secure file locations
- ✅ **Secret scanning** in CI/CD pipeline
- ✅ **Container isolation** for development

### Planned Security Enhancements
- 🔄 **GPG encryption** for VPN credentials
- 🔄 **Configuration validation** and sanitization
- 🔄 **Audit logging** for privileged operations
- 🔄 **Runtime security** monitoring

## Security Best Practices

### For Users
- Store VPN configurations in XDG-compliant directories
- Use strong authentication methods
- Regularly update vpnctl to latest version
- Review configuration files for sensitive data

### For Developers
- Follow secure coding practices
- Validate all inputs
- Use parameterized commands (no shell injection)
- Minimize privilege requirements
- Review dependencies for vulnerabilities

## Vulnerability Response

### Timeline
- **Initial Response**: 48 hours
- **Investigation**: 5-10 business days
- **Fix Development**: Depends on severity
- **Disclosure**: After fix is available

### Severity Classification
- **Critical**: Immediate remote code execution
- **High**: Local privilege escalation
- **Medium**: Information disclosure
- **Low**: Minor security issues

## Security Testing

VPNCTL uses:
- **Static Analysis**: ShellCheck for shell script security
- **Secret Scanning**: GitHub native secret detection
- **Dependency Scanning**: Automated vulnerability detection
- **Container Scanning**: Security analysis of development containers

## Acknowledgments

We appreciate responsible disclosure and will acknowledge security researchers who help improve VPNCTL's security posture.

---

**Last Updated**: 2025-09-26  
**Contact**: GitHub Security Advisory system