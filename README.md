# systemd-exporter-homelab

Minimal systemd_exporter container image built from source for homelab use.

## Usage

Pull the image:

```bash
podman pull ghcr.io/abyrne55/systemd-exporter-homelab:main
```

Run with D-Bus and systemd access:

```bash
podman run -d \
  -p 9558:9558 \
  -v /run/dbus/system_bus_socket:/run/dbus/system_bus_socket:ro \
  -v /run/systemd:/run/systemd:ro \
  ghcr.io/abyrne55/systemd-exporter-homelab:main
```

## Base Images

Built using [project-hummingbird](https://quay.io/organization/hummingbird) distroless base images:

- **Builder**: `quay.io/hummingbird/go:1.26-builder` — Go build environment for compiling the static binary
- **Runtime**: `quay.io/hummingbird/curl:8` — minimal distroless runtime with curl for healthchecks

Container runs as non-root user (UID 65532).

## Building Locally

```bash
# Clone with submodules
git clone --recursive https://github.com/abyrne55/systemd-exporter-homelab.git

# Or if already cloned, initialize submodules
git submodule update --init --recursive

# Build
podman build -t systemd-exporter-homelab:latest -f Containerfile .
```

## CI/CD

On push to `main`, GitHub Actions builds multi-arch (amd64 + arm64) images and pushes to GHCR, signed with Cosign.
