# Use Arch Linux base to match host environment
FROM archlinux:latest

# Update package database
RUN pacman -Sy

# Install runtime dependencies
RUN pacman -S --noconfirm \
  openvpn \
  wireguard-tools \
  iproute2 \
  bash \
  dialog \
  sudo

# Install build/test dependencies
RUN pacman -S --noconfirm \
  bats \
  shellcheck \
  git \
  make \
  just \
  && mkdir -p /vpnctl

# Copy project files
WORKDIR /vpnctl
COPY . .

# Set up entrypoint
ENTRYPOINT ["just"]
CMD ["--list"]
