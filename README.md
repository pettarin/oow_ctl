# oow_ctl

A lightweight Bash wrapper for running [Ollama](https://ollama.com/) and [Open WebUI](https://openwebui.com/) with Docker Compose on a GPU-equipped Linux host.

## Overview

`oow_ctl` manages two Docker containers:

- **Ollama** — serves large language models locally, with full NVIDIA GPU passthrough.
- **Open WebUI** — provides a browser-based chat interface connected to Ollama.

Both services store persistent data on an external volume (`/mnt/usb/docker/`) via bind mounts.

## Prerequisites

- Docker Engine with the [Compose plugin](https://docs.docker.com/compose/install/)
- [NVIDIA Container Toolkit](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/install-guide.html) for GPU support
- A mounted volume at `/mnt/usb/docker/` (or adjust the paths in `oow_ctl.sh`)

## Quick start

```bash
chmod +x oow_ctl.sh
./oow_ctl.sh start
```

Open WebUI will be available at <http://localhost:8080>.

## Usage

```
./oow_ctl.sh {df|logs|restart|start|status|stop|top}
```

| Command   | Description                                                         |
|-----------|---------------------------------------------------------------------|
| `df`      | Show free disk space on `/` and the data volumes                    |
| `logs`    | Tail container logs (extra args forwarded to `docker compose logs`) |
| `restart` | Stop and then start both containers                                 |
| `start`   | Start Ollama and Open WebUI in detached mode                        |
| `status`  | Show running container status                                       |
| `stop`    | Stop and remove both containers                                     |
| `top`     | Show running processes inside containers                            |

## Configuration

All settings are defined as environment variables at the top of `oow_ctl.sh`:

| Variable               | Default                      | Description                   |
|------------------------|------------------------------|-------------------------------|
| `OLLAMA_IMAGE_NAME`    | `ollama/ollama`              | Ollama Docker image           |
| `OLLAMA_IMAGE_TAG`     | `0.20.0`                     | Ollama image tag              |
| `OLLAMA_PORT`          | `11434`                      | Host port for the Ollama API  |
| `OLLAMA_VOLUME`        | `/mnt/usb/docker/ollama`     | Host path for Ollama data     |
| `OPENWEBUI_IMAGE_NAME` | `openwebui/open-webui`       | Open WebUI Docker image       |
| `OPENWEBUI_IMAGE_TAG`  | `latest`                     | Open WebUI image tag          |
| `OPENWEBUI_PORT`       | `8080`                       | Host port for the web UI      |
| `OPENWEBUI_VOLUME`     | `/mnt/usb/docker/open-webui` | Host path for Open WebUI data |

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.
