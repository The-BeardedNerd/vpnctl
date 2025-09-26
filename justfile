# Default target: Show available recipes
default:
    just --list

# Install user-level
install-user:
    mkdir -p ~/.local/bin ~/.config/vpnctl/profiles
    ln -sf {{pwd}}/bin/vpnctl ~/.local/bin/vpnctl
    chmod +x ~/.local/bin/vpnctl

# Install system-wide
install-system:
    sudo mkdir -p /usr/local/bin /etc/vpnctl/profiles
    sudo ln -sf {{pwd}}/bin/vpnctl /usr/local/bin/vpnctl
    sudo chmod +x /usr/local/bin/vpnctl

# Lint shell scripts
lint:
    shellcheck bin/vpnctl
    shfmt -w bin/vpnctl

# Run tests (BATS)
test:
    bats tests/

# Create a release tarball
release version:
    git archive --format=tar.gz --prefix=vpnctl-{{version}}/ -o vpnctl-{{version}}.tar.gz HEAD

# Clean
clean:
    rm -f *.tar.gz

# Container builds for different distributions
build-container-arch:
    podman build -t vpnctl:arch -f Containerfile .

build-container-ubuntu:
    podman build -t vpnctl:ubuntu -f Containerfile.ubuntu .

build-container-fedora:
    podman build -t vpnctl:fedora -f Containerfile.fedora .

# Build all container variants
build-containers:
    just build-container-arch
    just build-container-ubuntu
    just build-container-fedora

# Test in specific distributions
test-container-arch:
    podman run --rm -v {{pwd}}:/vpnctl -w /vpnctl vpnctl:arch test

test-container-ubuntu:
    podman run --rm -v {{pwd}}:/vpnctl -w /vpnctl vpnctl:ubuntu test

test-container-fedora:
    podman run --rm -v {{pwd}}:/vpnctl -w /vpnctl vpnctl:fedora test

# Test across all distributions
test-containers:
    just test-container-arch
    just test-container-ubuntu
    just test-container-fedora

# Development shell for specific distribution
shell-container-arch:
    podman run --rm -it -v {{pwd}}:/vpnctl -w /vpnctl vpnctl:arch sh

shell-container-ubuntu:
    podman run --rm -it -v {{pwd}}:/vpnctl -w /vpnctl vpnctl:ubuntu bash

shell-container-fedora:
    podman run --rm -it -v {{pwd}}:/vpnctl -w /vpnctl vpnctl:fedora bash

# Fallback: Call Makefile targets if needed
make-install-user:
    make install-user

make-install-system:
    make install-system
