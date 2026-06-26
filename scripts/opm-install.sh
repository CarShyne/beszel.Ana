#!/usr/bin/env bash
# Run ON opm (SSH) when Portainer cannot build (Web editor / missing internal/).
# Clones full repo, builds images locally, starts stack.
set -euo pipefail

INSTALL_DIR="${INSTALL_DIR:-$HOME/anarchy-pulse-src}"
REPO="${REPO:-https://github.com/CarShyne/beszel.Ana.git}"
BRANCH="${BRANCH:-main}"

echo "=== Anarchy Pulse — build on host ==="
echo "Install dir: $INSTALL_DIR"
echo ""

if ! docker info >/dev/null 2>&1; then
  echo "Docker is not running or you need sudo."
  exit 1
fi

if [ ! -d "$INSTALL_DIR/.git" ]; then
  git clone --depth 1 --branch "$BRANCH" "$REPO" "$INSTALL_DIR"
else
  git -C "$INSTALL_DIR" fetch origin "$BRANCH"
  git -C "$INSTALL_DIR" checkout "$BRANCH"
  git -C "$INSTALL_DIR" pull --ff-only origin "$BRANCH" || true
fi

cd "$INSTALL_DIR"
echo "Building (this can take 15–30 min on a Pi)..."
docker compose -f docker-compose.build.yml up -d --build

echo ""
echo "Done. Hub UI: http://$(hostname -I 2>/dev/null | awk '{print $1}'):8090"
echo "Or: http://localhost:8090"
echo ""
echo "Portainer: you can keep managing containers here, or point a pull-only"
echo "stack at docker-compose.portainer.yml after publishing to Docker Hub."
