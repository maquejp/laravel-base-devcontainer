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

install_node_modules() {
    echo "==> Running npm install..."
    npm install --no-audit --no-fund --include=optional
}

rolldown_binding_present() {
    node -e "require.resolve('@rolldown/binding-linux-x64-gnu')" >/dev/null 2>&1
}

if [ ! -d node_modules ]; then
    install_node_modules
fi

if ! rolldown_binding_present; then
    echo "==> Missing rolldown native binding. Reinstalling node_modules..."
    rm -rf node_modules
    install_node_modules
fi

if ! rolldown_binding_present; then
    echo "==> Optional dependency still missing. Rebuilding lockfile and reinstalling..."
    rm -rf node_modules package-lock.json
    install_node_modules
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

echo "==> Seeding database..."
php artisan db:seed --force

echo "==> Starting Vite dev server..."
node ./node_modules/vite/bin/vite.js --host 0.0.0.0 --port 5173 &
VITE_PID=$!

echo "==> Starting Laravel development server..."
php artisan serve --host=0.0.0.0 --port=8000 &
LARAVEL_PID=$!

cleanup() {
    kill "$VITE_PID" "$LARAVEL_PID" 2>/dev/null || true
}

trap cleanup INT TERM

wait -n "$VITE_PID" "$LARAVEL_PID"
EXIT_CODE=$?
cleanup
wait "$VITE_PID" "$LARAVEL_PID" 2>/dev/null || true
exit "$EXIT_CODE"
