FROM ubuntu:16.04

RUN apt-get update && apt-get install -y letsencrypt
#letsencrypt certonly --webroot -w /var/www/example -d example.com -d www.example.com -w /var/www/thing -d thing.is -d m.thing.is
#letsencrypt renew --dry-run --agree-tos
# letsencrypt renew (twice a day from systemd)
# Maybe want to have a /ssl mounted in a shared volume
# Maybe want different cert for each service from let's encrypt

# Generate unique DH group
RUN openssl dhparam -out /etc/ssl/private/dhparams.pem 2048
RUN chmod 600 /etc/ssl/private/dhparams.pem

COPY patater.conf /etc/nginx/sites-enabled/
#COPY elselab.conf /etc/nginx/sites-enabled/
COPY patater.github.io/_site /var/www/patater.com/htdocs
