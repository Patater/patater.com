#!/bin/sh

set -eu

# You probably already did this
#    pkg install git-lite
# To setup the host machine, run this on the host and reboot.

sysrc blacklistd_enable=yes
sysrc pf_enable=yes
sysrc gateway_enable=yes

sysrc cloned_interfaces="lo1"
sysrc ifconfig_lo1_aliases="192.168.1.1-9/32"
sysrc ifconfig_vtnet0_ipv6="inet6 2a03:b0c0:1:e0::4e5:f001-f/64"

sysrc jail_enable=yes
sysrc jail_reverse_stop=yes

# TODO syslogd tunneled over ssh to log host? Use home PC for log host? use stunnel
# TODO configure newsyslog for all jails to make logs with 600 permissions, and
# use append only security flags on host and jails
