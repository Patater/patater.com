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

# XXX TODO
# Unable to locate pem file
# /usr/local/etc/letsencrypt/live/patater.net/fullchain.pem
# Had to make letsencrypt/archive world executable
# Had to make letsencrypt/archive/privkey1.pem be world readable
# not sure how to make this change persist across certbot renewals.
# may want to consider researching certbot file creation permission
# configurability
# may want to set up a group that is ok to read from these files, on both host,
# www, and irc jails
# in addition to permission problem, symlinks seem not to be able to be
# followed. I had to use "archive" instead of "live". is this a nullfs
# limitation?
# jexec -U znc irc znc -D --foreground -d /usr/local/etc/znc
# probably best we can do is file permissions on the keys and irc subdomain
# keys are the only keys mounted within irc jail

# TODO certauth plugin
# TODO push plugin not showing up? should be in /usr/local/share/znc/modules?
# seems to be /usr/local/lib/znc
# password as: user/network:pass
# /server <znc_server_ip> +45678 admin:<pass>
# to manage settings, point browser to https://<znc_server_ip>:45678/

# TODO automatic IP address for jails with interface|ip notation

# TODO
# Open up 443 in firewall on tcp to send push notifications to pushover (maybe
# limit to certain IPs)
# Open up IRC ports so znc can connect to IRC servers
