#!/bin/sh

mkdir -p /usr/local/bastille
chmod 0750 /usr/local/bastille
zfs create zroot/bastille

# Use bastille to set up jails
bastille bootstrap 12.2-RELEASE
bastille create www 12.2-RELEASE 10.0.0.3
bastille create sftp 12.2-RELEASE 10.0.0.4
bastille create irc 12.2-RELEASE 10.0.0.5

bastille template www patater/www
bastille template sftp patater/sftp
bastille template irc patater/irc
