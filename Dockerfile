FROM --platform=$BUILDPLATFORM ghcr.io/actions/actions-runner:2.338.1@sha256:e275409999c37162649aa050ca573f03eab2eabcb3a1e7fcc47548de6b4f9690
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
