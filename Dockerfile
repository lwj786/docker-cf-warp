ARG DISTRIBUTION=bookworm

FROM debian:${DISTRIBUTION}-slim

ARG DISTRIBUTION
RUN set -x; \
    \
    apt-get update && apt-get install -y --no-install-recommends curl ca-certificates gnupg2 \
    && curl https://pkg.cloudflareclient.com/pubkey.gpg | gpg --yes --dearmor --output /usr/share/keyrings/cloudflare-warp-archive-keyring.gpg \
    && echo deb [arch=amd64 signed-by=/usr/share/keyrings/cloudflare-warp-archive-keyring.gpg] https://pkg.cloudflareclient.com/ ${DISTRIBUTION} main > /etc/apt/sources.list.d/cloudflare-client.list \
    && apt-get update && apt-get install -y --no-install-recommends cloudflare-warp \
    \
    && apt purge -y curl && apt autoremove -y \
    && rm -rf /var/lib/apt/lists/*

VOLUME /var/lib/cloudflare-warp
EXPOSE 40000

ENTRYPOINT [ "/bin/warp-svc" ]
