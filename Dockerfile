FROM --platform=$BUILDPLATFORM ghcr.io/actions/actions-runner:2.338.2@sha256:759a1d94a15b05941aba5196974ff43fe15b4cbba29b694b35cbc32a1166b232
USER root

RUN apt update -y && \
  apt-get upgrade -y && \
  apt install -y \
    git-core \
    rsync \
    curl \
    zip \
    libatomic1 \
    build-essential && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/*

# renovate: datasource=github-releases depName=cli/cli
ENV GH_VERSION=2.103.3

ARG TARGETARCH
RUN case "${TARGETARCH}" in \
    'amd64') \
      curl -sSLo /tmp/gh.deb https://github.com/cli/cli/releases/download/v${GH_VERSION}/gh_${GH_VERSION}_linux_amd64.deb; \
      dpkg -i /tmp/gh.deb; \
      rm -f /tmp/gh.deb; \
      ;; \
    'arm64') \
      curl -sSLo /tmp/gh.deb https://github.com/cli/cli/releases/download/v${GH_VERSION}/gh_${GH_VERSION}_linux_arm64.deb; \
      dpkg -i /tmp/gh.deb; \
      rm -f /tmp/gh.deb; \
      ;; \
    *) echo >&2 "error: unsupported architecture '${TARGETARCH}'"; exit 1 ;; \
  esac

USER runner
