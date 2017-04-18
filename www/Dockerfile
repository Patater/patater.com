FROM ubuntu:16.04

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
 && apt-get install --no-install-recommends --no-install-suggests -y software-properties-common ca-certificates nginx \
 && add-apt-repository ppa:certbot/certbot && apt-get update \
 && apt-get install --no-install-recommends --no-install-suggests -y certbot \
 && apt-get clean

# Generate unique DH group
RUN openssl dhparam -out /etc/ssl/private/dhparams.pem 2048 \
 && chmod 600 /etc/ssl/private/dhparams.pem

RUN rm /etc/nginx/sites-enabled/default
COPY patater.conf /etc/nginx/sites-enabled/
COPY patater-redirects.conf /tmp/
RUN sed '/# Patater Redirects/r /tmp/patater-redirects.conf' /tmp/patater.conf > /etc/nginx/sites-enabled/patater.conf

RUN cat /etc/nginx/sites-enabled/patater.conf
# XXX See if we can insert patater-redirect.conf into the patater.conf here
#COPY elselab.conf /etc/nginx/sites-enabled/
COPY patater.github.io/_site /var/www/patater.com/htdocs

# Public and private files (www-data)
VOLUME ["/www-data"]

# Keys and certificates for ssl (ssl-keys)
VOLUME ["/etc/letsencrypt"]

# XXX Check to see if certificate exists first. This will avoid rate limiting,
# perhaps. There is a renewal exception, but I'm not sure if we qualify. We
# can't see if the cert exists already at this point, because the named volume
# hasn't been mounted. The cert will never be here.
##DARRAYS=(${DOMAINS})
##cert_file="/etc/letsencrypt/live/$DARRAYS/fullchain.pem"
##if [ -f $cert_file ]; then
# We could make our renewal systemd job maybe check if the cert exists or
# not... Then we wouldn't need any custom startup script
#RUN certbot certonly --webroot -w /var/www/patater.com/ -d www.patater.com -d patater.com
# Renew twice a day
# certbot renew --dry-run --agree-tos --email certbot@patater.com
# certbot renew (twice a day from systemd)
# Maybe want to have a /ssl mounted in a shared volume
# Maybe want different cert for each service from let's encrypt

# XXX If cert gets renewed into shared named volume, will other containers see
# the changes? Are shared named volumes mounted as ro in other containers able
# to see changes from containers that update the volume (having it mounted rw)?

# Forward request and error logs to docker log collector
RUN ln -sf /dev/stdout /var/log/nginx/access.log \
 && ln -sf /dev/stderr /var/log/nginx/error.log

EXPOSE 80 443

CMD ["nginx", "-g", "daemon off;"]
