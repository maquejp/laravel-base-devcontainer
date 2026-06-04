#!/bin/bash
set -e

if [ ! -f composer.json ]; then
    echo "==> Scaffolding Laravel project..."
    composer create-project laravel/laravel /tmp/laravel --no-interaction --remove-vcs
    cp -a /tmp/laravel/. .
    rm -rf /tmp/laravel
fi

if [ ! -f vendor/autoload.php ]; then
    echo "==> Running composer install..."
    composer install --no-interaction --optimize-autoloader
fi

if [ ! -f .env ]; then
    cp .env.example .env
fi

echo "==> Configuring database .env settings..."
sed -i "s/^DB_CONNECTION=.*/DB_CONNECTION=pgsql/" .env
sed -i "s/^# DB_HOST=.*/DB_HOST=laravel-app-db/" .env
sed -i "s/^# DB_PORT=.*/DB_PORT=5432/" .env
sed -i "s/^# DB_DATABASE=.*/DB_DATABASE=laravel/" .env
sed -i "s/^# DB_USERNAME=.*/DB_USERNAME=laravel/" .env
sed -i "s/^# DB_PASSWORD=.*/DB_PASSWORD=laravel/" .env

if ! grep -q "^APP_KEY=" .env || [ "$(grep "^APP_KEY=" .env | cut -d= -f2)" = "" ]; then
    echo "==> Generating APP_KEY..."
    php artisan key:generate --force
fi

echo "==> Running migrations..."
php artisan migrate --force

exec php artisan serve --host=0.0.0.0 --port=8000
