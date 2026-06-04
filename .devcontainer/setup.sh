#!/bin/bash
set -e

SETUP_MARKER="/workspace/.devcontainer/.laravel-setup-complete"

if [ -f app/artisan ]; then
    mkdir -p /workspace/.devcontainer
    touch "$SETUP_MARKER"
    exit 0
fi

composer create-project --remove-vcs --no-interaction laravel/laravel app
cd app
npm install
npm install -D husky lint-staged prettier
npm pkg set lint-staged='{"*.php": ["pint"], "*.{js,jsx,ts,tsx,vue,css,scss,md}": ["prettier --write"]}'
php artisan key:generate

echo 'SESSION_DRIVER=file' >> .env

mkdir -p /workspace/.devcontainer
touch "$SETUP_MARKER"

echo ""
echo "Laravel scaffolded. Next steps:"
echo "  1. git init"
echo "  2. cd app && npx husky init && echo \"npx lint-staged\" > .husky/pre-commit"
echo "  3. git add -A && git commit -m \"chore: initial scaffold\""
