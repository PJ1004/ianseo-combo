### Base image from mariadb and based on Ubuntu before adding PHP
FROM docker.io/mariadb:12-noble

### add php and apache requirements
ENV DEBIAN_FRONTEND=noninteractive
RUN apt update && apt -y upgrade
RUN apt update && apt install -y \
        software-properties-common \
        lsb-release \
        apt-transport-https \
        ca-certificates \
        gnupg2 \
        curl \
        supervisor \
        wget \
        unzip
RUN apt install -y apache2
RUN add-apt-repository ppa:ondrej/php -y
RUN apt update && apt install -y php8.5 \
        php8.5-cli \
        php8.5-fpm \
        php8.5-gd \
        php8.5-intl \
        php8.5-imagick \
        php8.5-mysql \
        libapache2-mod-php8.5 \
        php8.5-mbstring \
        php8.5-xml \
        php8.5-curl \
        php8.5-zip \
        php8.5-dev \
        php-pear \
        pkg-config \
        libmagickwand-dev

# Install additional IANSEO php plugins
# Commenting out pecl install as ppa:ondrej now supports imagick on php8.5
# RUN printf "\n"|pecl install imagick

# Enable the PHP module and restart Apache
RUN a2enmod php8.5
RUN service apache2 restart

# Optional PHP INFO to be used for checking settings (Comment out COPY if not needed)
COPY --chown=www-data:www-data ./src/info.php /var/www/html/info.php
# Configure PHP settings
ENV PHP_CONF=/etc/php/8.5/apache2/php.ini
RUN cp /usr/lib/php/8.5/php.ini-production $PHP_CONF
RUN sed -i 's/upload_max_filesize = 2M/upload_max_filesize = 16M/g' $PHP_CONF
RUN sed -i 's/max_execution_time = 30/max_execution_time = 120/g' $PHP_CONF
RUN sed -i 's/post_max_size = 8M/post_max_size = 16M/g' $PHP_CONF
RUN sed -i 's/;extension=intl/extension=imagick\n;extension=intl/g' $PHP_CONF

# Config for default apache website
COPY ./src/apache_default /etc/apache2/sites-available/000-default.conf
RUN a2enmod rewrite

########################################################
# Setup IANSEO
RUN mkdir -p /opt/ianseo

## Comment out RUN lines if copying file locally
ENV IANSEO_RELEASE=Ianseo_20250210
RUN wget https://www.ianseo.net/Release/${IANSEO_RELEASE}.zip && unzip -o ${IANSEO_RELEASE}.zip -d /opt/ianseo
RUN rm ${IANSEO_RELEASE}.zip

# Uncomment out COPY & RUN (unzip) line if not pulling direct from IANSEO website
# COPY ./src/${IANSEO_RELEASE}.zip /tmp/${IANSEO_RELEASE}.zip
# RUN unzip -o /tmp/${IANSEO_RELEASE}.zip -d /opt/ianseo && rm /tmp/*.zip

RUN chown -R www-data:www-data /opt/ianseo
RUN ln -s /opt/ianseo /var/www/html/ianseo
RUN chown -R www-data:www-data /var/www/html

## Remove first-time config or copy your own
#RUN rm /opt/ianseo/Common/config.inc.php
#COPY ./src/config.inc.php /opt/ianseo/Common/config.inc.php

########################################################
##Cleanup
RUN apt-get -y autoremove && apt-get clean all

# Setup startup scripts and supervisor settings
COPY ./src/start-apache2.sh /opt/start-apache2.sh
COPY ./src/start-mariadb.sh /opt/start-mariadb.sh
COPY ./src/start.sh /opt/start.sh
RUN chmod 755 /opt/*.sh
COPY ./src/supervisord.conf /etc/supervisor/supervisord.conf
COPY ./src/supervisord-apache2.conf /etc/supervisor/conf.d/supervisord-apache2.conf
COPY ./src/supervisord-mariadb.conf /etc/supervisor/conf.d/supervisord-mariadb.conf


EXPOSE 80 3306

# Start services via supervisord
CMD ["/opt/start.sh"]
