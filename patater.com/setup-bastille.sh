#!/bin/sh

# Use bastille to set up jails
bastille bootstrap 12.2-RELEASE
bastille create www 12.2-RELEASE 10.0.0.2

bastille template sftp patater/sftp
bastille template www patater/www
bastille template irc patater/irc
