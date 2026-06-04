#!/bin/bash
set -e

ARTISAN="/workspace/app/artisan"
LOG_FILE="/tmp/laravel-server.log"
SETUP_MARKER="/workspace/.devcontainer/.laravel-setup-complete"
ENV_FILE="/workspace/app/.env"
AUTOLOAD_FILE="/workspace/app/vendor/autoload.php"
PORT="8000"
MAX_WAIT_SECONDS="120"

log() {
    echo "[$(date -Iseconds)] $1" >> "$LOG_FILE"
}

is_ready() {
    [ -f "$ARTISAN" ] && [ -f "$ENV_FILE" ] && [ -f "$AUTOLOAD_FILE" ]
}

mkdir -p /workspace/.devcontainer

if [ ! -f "$SETUP_MARKER" ]; then
    log "Setup marker not found, waiting for first-time bootstrap to finish."
fi

elapsed=0
until is_ready; do
    if [ "$elapsed" -ge "$MAX_WAIT_SECONDS" ]; then
        log "Skipping Laravel server start after ${MAX_WAIT_SECONDS}s: app is not ready yet."
        exit 0
    fi

    sleep 1
    elapsed=$((elapsed + 1))

    if [ "$elapsed" -eq 1 ] || [ $((elapsed % 10)) -eq 0 ]; then
        log "Waiting for app readiness (${elapsed}s elapsed)."
    fi
done

cd /workspace/app

if pgrep -f -x "php artisan serve --host=0.0.0.0 --port=8000" > /dev/null 2>&1; then
    log "Laravel server is already running on port ${PORT}."
    exit 0
fi

log "Starting Laravel server on port ${PORT}."
setsid php artisan serve --host=0.0.0.0 --port="$PORT" >> "$LOG_FILE" 2>&1 &

check=0
while [ "$check" -lt 30 ]; do
    if timeout 1 bash -lc "cat < /dev/null > /dev/tcp/127.0.0.1/${PORT}" 2>/dev/null; then
        log "Laravel server is ready on port ${PORT}."
        exit 0
    fi

    sleep 1
    check=$((check + 1))
done

log "Laravel server did not become ready on port ${PORT} within 30s."
