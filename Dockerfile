FROM debian:10
ARG S6_OVERLAY_VERSION="2.2.0.3"

ENV DEBIAN_FRONTEND=noninteractive

RUN set -eux; \
    apt-get clean && \
    apt-get update && \
    apt-get -y upgrade && \
    apt-get install ca-certificates curl psmisc procps libterm-readkey-perl -yq; \
    dpkgArch="$(dpkg --print-architecture | awk -F- '{ print $NF }')"; \
    overlayArch="amd64"; \
    if [ "$dpkgArch" = "amd64" ]; then \
        overlayArch="amd64"; \
    elif [ "$dpkgArch" = "arm64" ]; then \
        overlayArch="aarch64"; \
    elif [ "$dpkgArch" = "armhf" ]; then \
        overlayArch="armhf"; \
        c_rehash /etc/ssl/certs; \
    elif [ "$dpkgArch" = "i386" ]; then \
        overlayArch="x86"; \
    elif [ "$dpkgArch" = "ppc64le" ]; then \
        overlayArch="ppc64le"; \
    fi; \
    curl -fsSL https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-${overlayArch}.tar.gz | tar -xvz -C /;