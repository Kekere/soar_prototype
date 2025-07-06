FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# Install Apache, PHP, and dependencies
RUN apt-get update && apt-get install -y \
    apache2 \
    php \
    php-cli \
    php-mysql \
    php-intl \
    php-mbstring \
    php-xml \
    php-curl \
    php-zip \
    php-gd \
    php-imagick \
    php-bz2 \
    php-common \
    php-json \
    php-ldap \
    php-pgsql \
    php-soap \
    mariadb-client \
    wget \
    unzip \
    curl \
    nano \
    && apt-get clean

# Download Roundcube 1.6.0
RUN wget -q https://github.com/roundcube/roundcubemail/releases/download/1.6.0/roundcubemail-1.6.0-complete.tar.gz \
    && tar -xzf roundcubemail-1.6.0-complete.tar.gz -C /var/www/html/ \
    && mv /var/www/html/roundcubemail-1.6.0 /var/www/html/roundcube \
    && rm roundcubemail-1.6.0-complete.tar.gz

# Set permissions
RUN chown -R www-data:www-data /var/www/html/roundcube \
    && chmod -R 755 /var/www/html/roundcube

# Enable Apache rewrite module
RUN a2enmod rewrite

# Add custom Apache VirtualHost configuration
COPY apache.conf /etc/apache2/sites-available/000-default.conf

# Automatically create config.inc.php with Docker-compatible settings
RUN cp /var/www/html/roundcube/config/config.inc.php.sample /var/www/html/roundcube/config/config.inc.php \
    && sed -i "s/'mysql:\/\/roundcube:pass@localhost\/roundcubemail'/'mysql:\/\/roundcube:roundcube_pw@db\/roundcube'/" /var/www/html/roundcube/config/config.inc.php \
     && echo "\$config['imap_host'] = 'dovecot:143';" >> /var/www/html/roundcube/config/config.inc.php \
    && echo "\$config['des_key'] = 'r0undcubeSECRETencryptKEY!!';" >> /var/www/html/roundcube/config/config.inc.php \
    && echo "\$config['default_host'] = 'dovecot';" >> /var/www/html/roundcube/config/config.inc.php \
    && echo "\$config['smtp_server'] = 'mail';" >> /var/www/html/roundcube/config/config.inc.php \
    && echo "\$config['enable_installer'] = true;" >> /var/www/html/roundcube/config/config.inc.php \
    && echo "\$config['imap_debug'] = true;" >> /var/www/html/roundcube/config/config.inc.php \
    && echo "\$config['log_driver'] = 'file';" >> /var/www/html/roundcube/config/config.inc.php \
    && echo "\$config['debug_level'] = 1;" >> /var/www/html/roundcube/config/config.inc.php

# Schema initialization script
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 80
ENTRYPOINT ["/entrypoint.sh"]