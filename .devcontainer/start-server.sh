#!/bin/bash
set -e

ARTISAN="/workspace/app/artisan"
LOG_FILE="/tmp/laravel-server.log"

if [ ! -f "$ARTISAN" ]; then
    echo "[$(date -Iseconds)] Skipping Laravel server start: /workspace/app/artisan not found." >> "$LOG_FILE"
    exit 0
fi

cd /workspace/app

if pgrep -f "php artisan serve --host=0.0.0.0 --port=8000" > /dev/null 2>&1; then
    exit 0
fi

setsid php artisan serve --host=0.0.0.0 --port=8000 >> "$LOG_FILE" 2>&1 &
