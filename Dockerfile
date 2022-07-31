FROM php:8.1.8-apache

# Install Libs
RUN apt-get update && apt-get install -y --no-install-recommends \
  autoconf \
  build-essential \
  apt-utils \
  zlib1g-dev \
  libzip-dev \
  unzip \
  zip \
  libmagick++-dev \
  libmagickwand-dev \
  libpq-dev \
  libfreetype6-dev \
  libjpeg62-turbo-dev \
  libpng-dev \
  unixodbc \
  unixodbc-dev \
  freetds-dev \
  freetds-bin \
  tdsodbc

# Install Pecl
RUN pecl install imagick

# Install extensions
RUN docker-php-ext-configure gd
RUN docker-php-ext-configure zip
RUN docker-php-ext-configure pdo_dblib
RUN docker-php-ext-configure soap --enable-soap 
RUN docker-php-ext-install gd intl  pdo_mysql pdo_pgsql mysqli zip pdo_dblib soap
RUN docker-php-ext-enable imagick pdo_dblib

# Install curl composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

#upload
RUN echo "file_uploads = On\n" \
         "memory_limit = 500M\n" \
         "upload_max_filesize = 500M\n" \
         "post_max_size = 500M\n" \
         "max_execution_time = 600\n" \
         "max_input_vars=5000\n" \
         > /usr/local/etc/php/conf.d/uploads.ini

# Clear package lists
RUN apt-get clean; rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/doc/*

# Permissions
RUN chown -R root:www-data /var/www/html
RUN chmod u+rwx,g+rx,o+rx /var/www/html
RUN find /var/www/html -type d -exec chmod u+rwx,g+rx,o+rx {} +
RUN find /var/www/html -type f -exec chmod u+rw,g+rw,o+r {} +

# Dir path
WORKDIR /var/www/html

# Enable mods
RUN a2enmod rewrite
RUN a2enmod ssl

# Execute entrypoints
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]

# Expondo a porta de acesso do container e porta de acesso do supervisor
EXPOSE 80 9001

# Rodando comandos no final da montagem do container (Roda depois do entrypoint)
CMD /usr/sbin/apache2ctl -D FOREGROUND
