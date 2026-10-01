# syntax=docker/dockerfile:1
#base image
FROM debian:trixie-slim
#image metadata
LABEL version="2.5" description="This image allows you to run NVDA Remote Server inside a docker container" org.opencontainers.image.authors="Jose Manuel Delicado"
#prepare image
RUN <<EOT bash
set -euxo pipefail
groupadd -g 991 nvdaremoteserver
useradd -l -u 991 -g 991 -M -d /nonexistent -s /usr/sbin/nologin nvdaremoteserver
apt-get update
apt-get -y full-upgrade
apt-get -y install --no-install-recommends openssl python3
rm -rf /var/lib/apt/lists/*
install -d -m 755 /usr/share/NVDARemoteServer
install -d -o 991 -g 991 -m 700 /data
EOT
#program files are owned by root and read only for the server user. The private key is generated in /data on first start
COPY --chmod=755 docker/docker-entrypoint.sh /usr/bin/
COPY --chmod=644 daemon.py options.py server.py /usr/share/NVDARemoteServer/
COPY --chmod=644 NVDARemoteServer.conf /etc/
VOLUME /data
#expose the following ports to the host
EXPOSE 6837
USER 991:991
WORKDIR /usr/share/NVDARemoteServer
#this program is executed when a container is started
CMD ["python3", "-B", "/usr/share/NVDARemoteServer/server.py", "debug", "--configfile=/data/NVDARemoteServer.conf"]
ENTRYPOINT ["docker-entrypoint.sh"]
