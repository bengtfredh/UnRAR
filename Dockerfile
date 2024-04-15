FROM ghcr.io/linuxserver/unrar:amd64-latest

MAINTAINER Bengt <bengt@fredhs.net>

COPY crontab /var/spool/cron/crontabs/abc

COPY ./unrar.sh /bin/unrar_torrent.sh
RUN chmod +x /bin/unrar_torrent.sh

VOLUME /data

CMD ["crond", "-l", "2", "-f"]
