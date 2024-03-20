# syntax=docker/dockerfile:1
FROM alpine:3.19.1

# Labels defined by Open Container Initiative (OCI) specifications
# https://github.com/opencontainers/image-spec/blob/main/annotations.md#pre-defined-annotation-keys
LABEL org.opencontainers.image.authors="jake.smith" \
      org.opencontainers.image.description="Simple HTTP Headers Debug Container" \
      org.opencontainers.image.licenses="MIT" \
      org.opencontainers.image.source="https://github.com/jksmth/http-debug" \
      org.opencontainers.image.title="http-debug" \
      org.opencontainers.image.version="0.0.1"


ARG USER=nonroot
ARG UID=10001
ARG GID=${UID}
ARG HOMEDIR=/opt/nonroot

ENV PATH="$PATH:${HOMEDIR}/bin"

# Create non-root user
RUN <<EOT
    addgroup -S -g ${GID} ${USER}
    adduser -S -u ${UID} -G ${USER} -h ${HOMEDIR} ${USER}
EOT

# Install Dependencies
# hadolint ignore=DL3018
RUN <<EOT
    apk update
    apk add --no-cache tini ca-certificates python3
    update-ca-certificates
    rm -rf /tmp/* /var/cache/apk/* /var/tmp/*
EOT

# Switch to non-root user/group
USER ${UID}:${GID}

# Default workspace
WORKDIR /app

# Copy the server.py script
COPY server.py .

ENTRYPOINT ["/sbin/tini", "--", "python3", "/app/server.py"]
