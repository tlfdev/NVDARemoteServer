#!/bin/sh
set -eu
umask 077
if ! test -e /data/NVDARemoteServer.conf
then
cp /etc/NVDARemoteServer.conf /data
printf '\ncertfile=/data/server.pem\n' >> /data/NVDARemoteServer.conf
fi
# Generate a unique private key and certificate for this server instead of shipping a shared one
if ! test -e /data/server.pem
then
echo "Generating a new private key and certificate in /data/server.pem"
openssl req -x509 -newkey ec -pkeyopt ec_paramgen_curve:secp384r1 -nodes -sha384 -days 3650 -subj "/CN=nvda-remote-server" -keyout /data/server.pem -out /data/server.crt
cat /data/server.crt >> /data/server.pem
rm -f /data/server.crt
fi
exec "$@"
