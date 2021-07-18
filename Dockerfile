FROM docker.io/library/alpine:latest
MAINTAINER Bengt <bengt@fredhs.net>

RUN apk add --no-cache bash unrar

RUN  addgroup -S abc && adduser -S abc -G abc

COPY crontab /var/spool/cron/crontabs/abc

COPY ./unrar.sh /bin/unrar_torrent.sh
RUN chmod +x /bin/unrar_torrent.sh

VOLUME /data

CMD ["crond", "-l", "2", "-f"]