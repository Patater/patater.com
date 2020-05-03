#!/bin/sh

set -eu

# To setup the irc jail, run this on the host.


if [ ! -f /jail/base.txz ]; then
    curl -L https://download.freebsd.org/ftp/releases/amd64/12.1-RELEASE/base.txz > /jail/base.txz
fi
mkdir -p /jail/irc/etc
mkdir -p /jail/irc/usr/local/etc/letsencrypt
tar -xpf /jail/base.txz -C /jail/irc
cp /etc/resolv.conf /jail/irc/etc/
tzsetup -sC /jail/irc UTC
adduser -f irc-users.conf
cp jail/irc/usr/local/etc/znc/* /jail/irc/usr/local/etc/znc/
# to make a new config
#chroot -u znc /jail/irc znc -d /usr/local/etc/znc --makeconf
jexec -l irc chmod 700 /usr/local/etc/znc/configs
jexec -l irc chmod 600 /usr/local/etc/znc/configs/znc.conf
jexec -l irc chown -R znc:znc /usr/local/etc/znc
openssl dhparam -out /jail/irc/usr/local/etc/ssl/dhparams.pem 2048
cp jail/irc/etc/pf.conf /jail/irc/etc/pf.conf
cp irc-users.conf /jail/irc/
chroot /jail/irc adduser -f /irc-users.conf
chroot /jail/irc touch /etc/fstab
chroot /jail/irc touch /etc/rc.conf
service jail start irc
pkg -j irc install znc
pkg -j irc install znc-push
sysrc -j irc pf_enable=yes
sysrc -j irc znc_enable=yes
service jail restart irc

# TODO ssh dh params?
