FROM fedora:latest as build-env

RUN dnf -y install https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

RUN mkdir /output
RUN dnf -y --installroot /output --releasever $(rpm -E %fedora) --setopt=install_weak_deps=false --nodocs install glibc-minimal-langpack coreutils-single crontabs findutils unrar
RUN dnf -y --installroot /output clean all

FROM scratch
MAINTAINER Bengt <bengt@fredhs.net>
COPY --from=build-env /output /

COPY ./crontab /etc/cron.d/unrar
RUN chmod 0644 /etc/cron.d/unrar

COPY ./unrar.sh /usr/bin/unrar_torrent.sh
RUN chmod +x /usr/bin/unrar_torrent.sh

RUN sed -i '/pam_loginuid.so/d' /etc/pam.d/crond

VOLUME /data

#CMD ["crond", "-n"]
CMD crond && tail -f /var/log/cron.log
