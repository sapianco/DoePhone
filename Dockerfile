FROM php:7.4-fpm-alpine

RUN docker-php-ext-install opcache

RUN apk --no-cache add nginx supervisor curl bash

RUN apk add --no-cache py3-pip \
    && apk add --no-cache --virtual .build-deps python3-dev \
    && pip install --upgrade pip \
    && pip install j2cli \
    && apk del .build-deps

COPY config/nginx.conf /etc/nginx/nginx.conf
COPY config/nginx/ /etc/nginx/conf.d/
COPY config/fpm-pool.conf /etc/php7/php-fpm.d/www.conf
COPY config/php-fpm/ /usr/local/etc/php-fpm.d/
COPY config/php.ini /etc/php7/conf.d/custom.ini
COPY config/php/*.ini /etc/php7/conf.d/
COPY config/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Setup document root
RUN mkdir -p /var/www/html

# Make sure files/folders needed by the processes are accessable when they run under the nobody user
RUN chown -R nobody.nobody /var/www/html && \
  chown -R nobody.nobody /run && \
  chown -R nobody.nobody /var/lib/nginx && \
  chown -R nobody.nobody /var/log/nginx

#Ser Production PHP
RUN cp /etc/php7/conf.d/*.ini "$PHP_INI_DIR/conf.d/"
#RUN cp "/etc/php7/php-fpm.d/*.conf" "$PHP_INI_DIR/conf.d/"

# Switch to use a non-root user from here on
USER nobody

# Add application
WORKDIR /var/www/html
COPY --chown=nobody DoePhone/ /var/www/html/DoePhone/
COPY --chown=nobody DoePhone/favicon.ico /var/www/html/favicon.ico
COPY --chown=nobody extras_sapian/ /var/www/html/extras_sapian/
COPY --chown=nobody entrypoint.sh /entrypoint.sh

# Expose the port nginx is reachable on
EXPOSE 8080

# Let supervisord start nginx & php-fpm
ENTRYPOINT ["/entrypoint.sh"]
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
#CMD bash
# Configure a healthcheck to validate that everything is up&running
HEALTHCHECK --timeout=10s CMD curl --silent --fail http://127.0.0.1:8080/fpm-ping

ARG BUILD_DATE
ARG VCS_REF
ARG VERSION

LABEL org.label-schema.build-date=$BUILD_DATE \
      org.label-schema.name="DoePhone" \
      org.label-schema.description="Softphone WebRTC de DialBox Online Edition" \
      org.label-schema.url="https://www.sapian.cloud/doe-webrtc" \
      org.label-schema.vcs-url="https://git.sapian.com.co/Sapian/DoePhone" \
      org.label-schema.maintainer="sebastian.rojo@sapian.com.co" \
      org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.vendor2="Sapian" \
      org.label-schema.version=$VERSION
