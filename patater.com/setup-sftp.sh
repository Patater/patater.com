#!/bin/sh

set -eu

# To setup the sftp jail, run this on the host.


if [ ! -f /jail/base.txz ]; then
    curl -L https://download.freebsd.org/ftp/releases/amd64/12.1-RELEASE/base.txz > /jail/base.txz
fi
mkdir -p /jail/sftp/data/upload
mkdir -p /jail/sftp/keys/sftp
tar -xpf /jail/base.txz -C /jail/sftp
cp /etc/resolv.conf /jail/sftp/etc/
tzsetup -sC /jail/sftp UTC
adduser -f sftp-users.conf
cp jail/sftp/etc/ssh/sshd_config /jail/sftp/etc/ssh/sshd_config
cp jail/sftp/etc/pf.conf /jail/sftp/etc/pf.conf
cp sftp-users.conf /jail/sftp/
chroot /jail/sftp adduser -f /sftp-users.conf
chroot /jail/sftp touch /etc/fstab
chroot /jail/sftp touch /etc/rc.conf
service jail start sftp
sysrc -j sftp blacklistd_enable=yes
sysrc -j sftp pf_enable=yes
sysrc -j sftp sshd_enable=yes
jexec -l sftp chown root:wheel /data
jexec -l sftp chown -R sftp:sftp /data/upload
service jail restart sftp

# TODO ssh dh params?
