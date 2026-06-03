#!/bin/bash
set -e

ARTISAN="/workspace/app/artisan"

if [ ! -f "$ARTISAN" ]; then
    exit 0
fi

cd /workspace/app

if pgrep -f "artisan serve" > /dev/null 2>&1; then
    exit 0
fi

nohup php artisan serve --host=0.0.0.0 --port=8000 > /tmp/laravel-server.log 2>&1 &

sleep 2
