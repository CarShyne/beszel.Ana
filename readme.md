# Anarchy Pulse

Anarchy Pulse is an AnarchyAI-themed server monitoring platform — a fork of [Beszel](https://github.com/henrygd/beszel) by [henrygd](https://github.com/henrygd). It includes Docker statistics, historical data, and alert functions.

It has a friendly web interface, simple configuration, and is ready to use out of the box. It supports automatic backup, multi-user, OAuth authentication, and API access.

[![agent Docker Image Size](https://img.shields.io/docker/image-size/jt7777/anarchy-pulse-agent/latest?logo=docker&label=agent%20image%20size)](https://hub.docker.com/r/jt7777/anarchy-pulse-agent)
[![hub Docker Image Size](https://img.shields.io/docker/image-size/jt7777/anarchy-pulse/latest?logo=docker&label=hub%20image%20size)](https://hub.docker.com/r/jt7777/anarchy-pulse)

![Screenshot of Anarchy Pulse dashboard and system page, side by side. The dashboard shows metrics from multiple connected systems, while the system page shows detailed metrics for a single system.](https://henrygd-assets.b-cdn.net/beszel/screenshot-new.png)

## Features

- **Lightweight**: Smaller and less resource-intensive than leading solutions.
- **Simple**: Easy setup with little manual configuration required.
- **Docker stats**: Tracks CPU, memory, and network usage history for each container.
- **Alerts**: Configurable alerts for CPU, memory, disk, bandwidth, temperature, load average, and status.
- **Multi-user**: Users manage their own systems. Admins can share systems across users.
- **OAuth / OIDC**: Supports many OAuth2 providers. Password auth can be disabled.
- **Automatic backups**: Save to and restore from disk or S3-compatible storage.

## Architecture

Anarchy Pulse consists of two main components: the **hub** and the **agent**.

- **Hub**: A web application built on [PocketBase](https://pocketbase.io/) that provides a dashboard for viewing and managing connected systems.
- **Agent**: Runs on each system you want to monitor and communicates system metrics to the hub.

## Getting started

### Portainer (Raspberry Pi / NAS) — recommended first deploy

The `jt7777/anarchy-pulse` image is **not on Docker Hub until you publish it**. Until then, build from the GitHub repo in Portainer:

1. **Stacks** → **Add stack** → **Repository**
2. Repository URL: `https://github.com/CarShyne/beszel.Ana`
3. Compose path: **`docker-compose.portainer.yml`**
4. Deploy (first build on Pi takes ~10–20 minutes)

Open hub UI: `http://opm:8090` (or your host IP).

### Publish images to Docker Hub (then pull works)

On your Mac with Docker Desktop:

```bash
docker login
cd ~/Projects/Anarchy-Pulse
./scripts/publish-anarchy-pulse-arm64.sh   # Pi / arm64
# or
./scripts/publish-anarchy-pulse.sh         # amd64 + arm64
```

Then Portainer → **Pull and redeploy** any stack using `jt7777/anarchy-pulse:latest`.

### Docker Desktop (local)

```bash
docker compose up -d --build
```

Hub UI: [http://localhost:8090](http://localhost:8090)

## Supported metrics

- **CPU usage** - Host system and Docker / Podman containers.
- **Memory usage** - Host system and containers. Includes swap and ZFS ARC.
- **Disk usage** - Host system. Supports multiple partitions and devices.
- **Disk I/O** - Host system. Supports multiple partitions and devices.
- **Network usage** - Host system and containers.
- **Load average** - Host system.
- **Temperature** - Host system sensors.
- **GPU usage / power draw** - Nvidia, AMD, and Intel.
- **Battery** - Host system battery charge.
- **Containers** - Status and metrics of all running Docker / Podman containers.
- **S.M.A.R.T.** - Host system disk health.

## Upstream

Based on [Beszel](https://github.com/henrygd/beszel) by henrygd — MIT licensed server monitoring.

## License

Anarchy Pulse is licensed under the MIT License. See the [LICENSE](LICENSE) file for more details.
