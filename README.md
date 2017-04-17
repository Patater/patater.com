# Infrastructure for patater.com

The patater.com infrastructure is a collection of Docker containers, roughly
one per subdomain of my site. There are Docker containers for many functions.

| Subdomain | Purpose |
| --------- | ------- |
| www       | web hosting |
| irc       | znc |
| sftp      | sftp servin' |
| ssh       | ssh and tmux console |

There are also a number of named volumes shared among the containers.

| Name | Purpose | Mounted-by |
| ---- | ------- | ---------- |
| www-data | Files for serving web pages. | www (read-only) |
| irc-data | Logs from znc. | irc |
| sftp-data | Data for SFTP. | sftp |
| sftp-keys | Authorized keys for SFTP. | sftp |
| ssh-keys | Authorized keys for SSH. | ssh |

Let's Encrypt is used to automatically obtain and renew certificates for each
subdomain container. This functionality is implemented in a layer shared by
many containers.

A Makefile is provided to build each container locally, or export the to an
archive for use with `docker import` or deployment.

To generate the web site, one requires 'bundler'
 - Make sure using ruby 2.x.x or higher
 - gem install bundler
