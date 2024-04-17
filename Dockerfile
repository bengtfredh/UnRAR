MAINTAINER Bengt <bengt@fredhs.net>

FROM fedora:latest as build-env

RUN dnf -y install https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

RUN mkdir /output
RUN dnf -y --installroot /output --releasever $(rpm -E %fedora) --setopt=install_weak_deps=false --nodocs install glibc-minimal-langpack coreutils-single crontabs unrar
RUN dnf -y --installroot /output clean all

FROM scratch
COPY --from=build-env /output /

COPY crontab /etc/cron.d/unrar

COPY ./unrar.sh /bin/unrar_torrent.sh
RUN chmod +x /bin/unrar_torrent.sh

VOLUME /data

CMD ["crond", "-l", "2", "-f"]
