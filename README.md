# Infrastructure for patater.com

## Why?

I like flat, vanilla stacks. I don't like learning a DSL for scripts when
scripts will do. I minimize layers of complexity. I build my own containers to
minimize baggage and to understand what I'm running. I depend only on solid,
well-maintained, proven tech that is going to be around for a while. The
fanciest stuff here is Docker and Let's Encrypt: no elastic chef kubernetes
beanstalk puppets, minimal container state, minimal cloud service dependencies.

The main reason for this project is to code the infrastructure hosted by the
patater.com server. Previously, the root of my server was a git repository. I'd
manually configure the server and check in configuration files. I didn't track
what software was installed in git. This set up was nice for tracking my
changes and understanding what I had done (if I remembered to add and commit my
changes), but didn't help much if I wanted to move my server to a new VPS
provider.

## What is it?

The patater.com infrastructure is a collection of Docker containers, roughly
one per subdomain of my server. There are Docker containers for many functions.

| Subdomain | Purpose |
| --------- | ------- |
| www       | web hosting |
| irc       | znc |
| sftp      | sftp servin' |
| ssh       | ssh and tmux console |

There are also a number of named volumes shared among the containers.

| Name | Purpose | Mounted-by |
| ---- | ------- | ---------- |
| www-data | Files for serving web pages. htpasswd. | www (ro) |
| ssl-keys | Keys for subdomains. Written to by www via Let's Encrypt. | www (rw), irc (ro) |
| irc-data | Logs from znc. | irc |
| sftp-data | Data for SFTP. | sftp |
| sftp-keys | Authorized keys for SFTP. | sftp |
| ssh-keys | Authorized keys for SSH. | ssh |

Let's Encrypt is used to automatically obtain and renew certificates for each
subdomain container. This functionality is implemented in a layer shared by
many containers.

A Makefile is provided to build each container locally, or export the to an
archive for use with `docker import` or deployment.

## Requirements

To generate the web site, one requires 'bundler'
 - Make sure using ruby 2.x.x or higher
 - gem install bundler

## Ideas

The www subdomain container could be comprised of multiple images: one running
nginx as reverse proxy over a container-to-container-only network to multiple
other docker containers, one per web site (or vhost). This would provide some
isolation between vhosts better than what we have now. Only the reverse proxy
nginx container would expose ports on the host (80 and 443). This may
complicate proving subdomain ownership for Let's Encrypt.

If we could redirect a subset (or all) traffic incoming on the host to a
container based on the subdomain, that would prove useful. For instance, we
could easily use standalone verification with Let's Encrypt. We could also
trivially host different web sites (without vhosts); this makes containers more
portable. We could host multiple XMPP servers on the default ports, picking the
server based on the subdomain. Implementing this sort of capability smells like
a host firewall configuration. This probably requires multiple IP addresses on
the host, though (one per subdomain).

While we'd like separate certificates for each subdomain, keeping subdomain
keys private in subdomain containers (without sharing volumes), for now, we'll
have the www container obtain keys for all subdomains into a named volume. We
do this because Let's Encrypt verification requires publicly available port 80
or 443 on the requesting computer. We can't have each container request its own
certificate because each container can't expose 80 on the host: 80 on the host
can only go to one container (for now).

## Testing Locally

To test the web server, which only serves up vhosts, edit your /etc/hosts file
to point patater.com to 127.0.0.1. https won't work, unless you have a valid
cert for patater.com stored in www-data.
