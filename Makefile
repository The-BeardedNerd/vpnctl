.SHELL := /bin/bash

# Directories
BIN_DIR ?= $(DESTDIR)/usr/local/bin
USER_BIN_DIR ?= $(HOME)/.local/bin
CONFIG_DIR ?= $(DESTDIR)/etc/vpnctl
USER_CONFIG_DIR ?= $(HOME)/.config/vpnctl

# Default target
all: help

# Install user-level
install-user:
	mkdir -p $(USER_BIN_DIR) $(USER_CONFIG_DIR)/profiles
	ln -sf $$(pwd)/bin/vpnctl $(USER_BIN_DIR)/vpnctl
	chmod +x $(USER_BIN_DIR)/vpnctl

# Install system-wide
install-system:
	sudo mkdir -p $(BIN_DIR) $(CONFIG_DIR)/profiles
	sudo ln -sf $$(pwd)/bin/vpnctl $(BIN_DIR)/vpnctl
	sudo chmod +x $(BIN_DIR)/vpnctl

# Build the primary container image (Arch)
build-container:
	podman build -t vpnctl:arch -f Containerfile .

# Build all container variants
build-containers:
	podman build -t vpnctl:arch -f Containerfile .
	podman build -t vpnctl:ubuntu -f Containerfile.ubuntu .
	podman build -t vpnctl:fedora -f Containerfile.fedora .

# Run tests in primary container (Arch)
test-container:
	podman run --rm -v $$(pwd):/vpnctl -w /vpnctl vpnctl:arch test

# Run tests across all distributions
test-containers:
	podman run --rm -v $$(pwd):/vpnctl -w /vpnctl vpnctl:arch test
	podman run --rm -v $$(pwd):/vpnctl -w /vpnctl vpnctl:ubuntu test
	podman run --rm -v $$(pwd):/vpnctl -w /vpnctl vpnctl:fedora test

# Enter a development shell (Arch)
shell-container:
	podman run --rm -it -v $$(pwd):/vpnctl -w /vpnctl vpnctl:arch sh

# Lint shell scripts
lint:
	shellcheck bin/vpnctl
	shfmt -w bin/vpnctl

# Run tests (BATS)
test:
	bats tests/

# Create a release tarball
release:
	git archive --format=tar.gz --prefix=vpnctl-$(VERSION)/ -o vpnctl-$(VERSION).tar.gz HEAD

# Clean
clean:
	rm -f *.tar.gz

help:
	@echo "Available targets:"
	@echo "  install-user     Install for current user"
	@echo "  install-system   Install system-wide"
	@echo "  build-container  Build primary container (Arch)"
	@echo "  build-containers Build all container variants (Arch, Ubuntu, Fedora)"
	@echo "  test-container   Run tests in primary container"
	@echo "  test-containers  Run tests across all distributions"
	@echo "  shell-container  Enter development shell"
	@echo "  lint             Lint shell scripts"
	@echo "  test             Run tests"
	@echo "  release          Create a release tarball"
	@echo "  clean            Clean up"
