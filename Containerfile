# Build stage — always run on the runner's native arch
FROM --platform=$BUILDPLATFORM quay.io/hummingbird/go:1.26-builder AS builder
ARG TARGETARCH

WORKDIR /build
COPY systemd_exporter/ .

RUN CGO_ENABLED=0 GOARCH=$TARGETARCH go build \
    -ldflags "-s -w \
        -X github.com/prometheus/common/version.Version=$(cat VERSION) \
        -X github.com/prometheus/common/version.Revision=unknown \
        -X github.com/prometheus/common/version.Branch=unknown \
        -X github.com/prometheus/common/version.BuildUser=container@build \
        -X github.com/prometheus/common/version.BuildDate=$(date -u +%Y%m%d-%H:%M:%S)" \
    -o /systemd_exporter .

# Runtime stage
FROM quay.io/hummingbird/curl:8

COPY --from=builder /systemd_exporter /usr/bin/systemd_exporter

EXPOSE 9558/tcp
USER 65532

ENTRYPOINT ["/usr/bin/systemd_exporter"]
