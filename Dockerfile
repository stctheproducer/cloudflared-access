FROM alpine:latest

ARG TARGETPLATFORM
ARG BUILDPLATFORM

# Create non-root user
RUN addgroup -S cloudflared && adduser -S cloudflared -G cloudflared

RUN apk add --no-cache curl

RUN case "${TARGETPLATFORM}" in \
    "linux/amd64") ARCH="amd64" ;; \
    "linux/arm64") ARCH="arm64" ;; \
    *) echo "Unsupported platform: ${TARGETPLATFORM}" && exit 1 ;; \
    esac && \
    curl -L "https://github.com/cloudflare/cloudflared/releases/download/2020.8.2/cloudflared-linux-${ARCH}" -o /usr/local/bin/cloudflared && \
    chmod +x /usr/local/bin/cloudflared && \
    # Set ownership of the binary to the non-root user
    chown cloudflared:cloudflared /usr/local/bin/cloudflared

# Switch to non-root user
USER cloudflared

ENTRYPOINT ["cloudflared"]
