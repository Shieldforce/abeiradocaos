#!/bin/bash

# Atualizando pacotes php
composer update --no-scripts

# Gerando secret para JWT
#php artisan jwt:secret

# Dando permissão para pasta public
chmod -R 775 /var/www/html/public

# Dando permissão para pasta bootstrap
chmod -R 777 /var/www/html/bootstrap

# Dando permissão para pasta .docker
chmod -R 777 .docker

# Then exec the container's main process (what's set as CMD in the Dockerfile).
exec "$@"
