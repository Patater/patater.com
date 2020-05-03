#!/bin/sh

set -eu

# To setup the www jail, run this on the host.
# Currently requires manually setting up:
#   /jail/www/usr/local/www/patater.com/htdocs

mkdir -p /jail/logs
mkdir /jail/www
if [ ! -f /jail/base.txz ]; then
    curl -L https://download.freebsd.org/ftp/releases/amd64/12.1-RELEASE/base.txz > /jail/base.txz
fi
tar -xpf /jail/base.txz -C /jail/www
cp /etc/resolv.conf /jail/www/etc/
tzsetup -sC /jail/www UTC
chroot /jail/www touch /etc/fstab
chroot /jail/www touch /etc/rc.conf
service jail start www
pkg -j www install nginx
pkg -j www install py37-certbot
sysrc -j www nginx_enable=yes
jexec -l www chown -R www:www /usr/local/www/patater.com
openssl dhparam -out /jail/www/usr/local/etc/nginx/dhparams.pem 2048
jexec -l www chmod 600 /usr/local/etc/nginx/dhparams.pem
echo 'weekly_certbot_enable="YES"' >> /jail/www/etc/periodic.conf
jexec -l www certbot certonly --webroot -w /usr/local/www/patater.com/htdocs -d patater.net -d www.patater.net -m certbot@patater.net --agree-tos
service jail restart www

# TODO nginx blacklistd
