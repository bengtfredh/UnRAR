FROM docker.io/library/alpine:latest
MAINTAINER onigoetz <onigoetz@onigoetz.ch>

RUN apk add --no-cache bash unrar

COPY crontab /var/spool/cron/crontabs/abc

COPY ./unrar.sh /bin/unrar_torrent.sh
RUN chmod +x /bin/unrar_torrent.sh

VOLUME /data

CMD ["crond", "-l", "2", "-f"]