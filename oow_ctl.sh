#!/usr/bin/env bash
set -euo pipefail

# ---------------------------------------------------------------------------
# Configuration — edit these variables to customise images, ports, and paths
# ---------------------------------------------------------------------------
export DOCKER_COMPOSE_MANIFEST_FILE_NAME="docker-compose.yml"
export OLLAMA_CONTAINER_NAME="ollama"
export OLLAMA_IMAGE="ollama/ollama"
export OLLAMA_IMAGE_TAG="0.20.0"
export OLLAMA_PORT="11434"
export OLLAMA_VOLUME="/mnt/usb/docker/ollama"
export OPENWEBUI_CONTAINER_NAME="open-webui"
export OPENWEBUI_IMAGE="openwebui/open-webui"
export OPENWEBUI_IMAGE_TAG="latest"
export OPENWEBUI_PORT="8080"
export OPENWEBUI_VOLUME="/mnt/usb/docker/open-webui"

# ---------------------------------------------------------------------------
# Resolve docker-compose.yml relative to this script's location
# ---------------------------------------------------------------------------
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
COMPOSE_FILE="${SCRIPT_DIR}/${DOCKER_COMPOSE_MANIFEST_FILE_NAME}"

usage() {
    echo "Usage: $0 {df|logs|start|status|stop|top}"
    exit 1
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
        docker compose -f "$COMPOSE_FILE" logs "$@"
        ;;
    start)
        echo "[INFO] Starting ollama and open-webui ..."
        docker compose -f "$COMPOSE_FILE" up -d
        echo "[INFO] Starting ollama and open-webui ... done"
        ;;
    status)
        docker compose -f "$COMPOSE_FILE" ps
        ;;
    stop)
        echo "[INFO] Stopping ollama and open-webui ..."
        docker compose -f "$COMPOSE_FILE" down
        echo "[INFO] Stopping ollama and open-webui ... done"
        ;;
    top)
        shift
        docker compose -f "$COMPOSE_FILE" top "$@"
        ;;
    *)
        usage
        ;;
esac
