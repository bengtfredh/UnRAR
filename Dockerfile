FROM docker.io/library/alpine:latest
# Maintainer: Bengt <bengt@fredhs.net>

RUN apk add --no-cache bash curl jq && \
    curl -LsSf https://api.github.com/repos/EDM115/unrar-alpine/releases/latest \
    | jq -r '.assets[] | select(.name == "unrar") | .id' \
    | xargs -I {} curl -LsSf https://api.github.com/repos/EDM115/unrar-alpine/releases/assets/{} \
    | jq -r '.browser_download_url' \
    | xargs -I {} curl -Lsf {} -o /tmp/unrar && \
    install -v -m755 /tmp/unrar /usr/local/bin && \
    rm /tmp/unrar && \
    apk del curl jq

RUN apk add --no-cache libstdc++ libgcc

RUN  addgroup -S abc && adduser -S abc -G abc

COPY crontab /var/spool/cron/crontabs/abc

COPY ./unrar.sh /bin/unrar_torrent.sh
RUN chmod +x /bin/unrar_torrent.sh && \
    rm -rf /usr/include /tmp/* /var/cache/apk/*

VOLUME /data

CMD ["crond", "-l", "2", "-f"]
