#!/usr/bin/env bash
set -euo pipefail

# ---------------------------------------------------------------------------
# Configuration — edit these variables to customise images, ports, and paths
# ---------------------------------------------------------------------------
export DOCKER_COMPOSE_MANIFEST_FILE_NAME="${DOCKER_COMPOSE_MANIFEST_FILE_NAME:-docker-compose.yml}"
export OLLAMA_CONTAINER_NAME="${OLLAMA_CONTAINER_NAME:-ollama}"
export OLLAMA_IMAGE="${OLLAMA_IMAGE:-ollama/ollama}"
export OLLAMA_IMAGE_TAG="${OLLAMA_IMAGE_TAG:-0.20.0}"
export OLLAMA_PORT="${OLLAMA_PORT:-11434}"
export OLLAMA_VOLUME="${OLLAMA_VOLUME:-/mnt/usb/docker/ollama}"
export OPENWEBUI_CONTAINER_NAME="${OPENWEBUI_CONTAINER_NAME:-open-webui}"
export OPENWEBUI_IMAGE="${OPENWEBUI_IMAGE:-openwebui/open-webui}"
export OPENWEBUI_IMAGE_TAG="${OPENWEBUI_IMAGE_TAG:-latest}"
export OPENWEBUI_PORT="${OPENWEBUI_PORT:-8080}"
export OPENWEBUI_USER_AGENT="${OPENWEBUI_USER_AGENT:-Mozilla/5.0 (X11; Linux x86_64; rv:149.0) Gecko/20100101 Firefox/149.0}"
export OPENWEBUI_VOLUME="${OPENWEBUI_VOLUME:-/mnt/usb/docker/open-webui}"

# ---------------------------------------------------------------------------
# Resolve docker-compose.yml relative to this script's location
# ---------------------------------------------------------------------------
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOCKER_COMPOSE_MANIFEST_PATH="${SCRIPT_DIR}/${DOCKER_COMPOSE_MANIFEST_FILE_NAME}"

usage() {
    echo "Usage: $0 {df|logs|restart|start|status|stop|top}"
    exit 1
}

do_start() {
    echo "[INFO] Starting ollama and open-webui ..."
    docker compose -f "$DOCKER_COMPOSE_MANIFEST_PATH" up -d
    echo "[INFO] Starting ollama and open-webui ... done"
}

do_stop() {
    echo "[INFO] Stopping ollama and open-webui ..."
    docker compose -f "$DOCKER_COMPOSE_MANIFEST_PATH" down
    echo "[INFO] Stopping ollama and open-webui ... done"
}

case "${1:-}" in
    df)
        for path in / "$OLLAMA_VOLUME" "$OPENWEBUI_VOLUME"; do
            if [ -d "$path" ]; then
                echo "[INFO] Free space on $path"
                df -h "$path"
                echo ""
            else
                echo "[WARN] Path $path does not exist"
                echo ""
            fi
        done
        ;;
    logs)
        shift
        docker compose -f "$DOCKER_COMPOSE_MANIFEST_PATH" logs "$@"
        ;;
    restart)
        do_stop
        do_start
        ;;
    start)
        do_start
        ;;
    status)
        docker compose -f "$DOCKER_COMPOSE_MANIFEST_PATH" ps
        ;;
    stop)
        do_stop
        ;;
    top)
        shift
        docker compose -f "$DOCKER_COMPOSE_MANIFEST_PATH" top "$@"
        ;;
    *)
        usage
        ;;
esac
