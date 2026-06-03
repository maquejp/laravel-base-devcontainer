#!/bin/bash
set -e

if [ -f app/artisan ]; then
    exit 0
fi

composer create-project --remove-vcs --no-interaction laravel/laravel app
cd app
npm install
npm install -D husky lint-staged prettier
npm pkg set lint-staged='{"*.php": ["pint"], "*.{js,jsx,ts,tsx,vue,css,scss,md}": ["prettier --write"]}'
php artisan key:generate

echo 'SESSION_DRIVER=file' >> .env

echo ""
echo "Laravel scaffolded. Next steps:"
echo "  1. git init"
echo "  2. cd app && npx husky init && echo \"npx lint-staged\" > .husky/pre-commit"
echo "  3. git add -A && git commit -m \"chore: initial scaffold\""
