#!/usr/bin/env bash
# Build Anarchy Pulse for arm64 only (Raspberry Pi / opm).
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
HUB_IMAGE="jt7777/anarchy-pulse"
AGENT_IMAGE="jt7777/anarchy-pulse-agent"
BUILD_ID="$(date +%Y%m%d-%H%M%S)"
RELEASE_TAG="release-${BUILD_ID}-arm64"

echo ""
echo "=== Publish Anarchy Pulse (arm64) → Docker Hub ==="
echo ""

if ! docker info >/dev/null 2>&1; then
  echo "Docker is not running. Open Docker Desktop first."
  exit 1
fi

cd "$ROOT"

echo "Building web UI..."
if command -v bun >/dev/null 2>&1; then
  bun install --cwd ./internal/site
  bun run --cwd ./internal/site build
else
  npm ci --prefix ./internal/site
  npm run --prefix ./internal/site build
fi

docker buildx inspect anarchy-pulse-builder >/dev/null 2>&1 || \
  docker buildx create --name anarchy-pulse-builder --use
docker buildx use anarchy-pulse-builder

docker buildx build --platform linux/arm64 \
  -f internal/dockerfile_hub \
  -t "${HUB_IMAGE}:latest" \
  -t "${HUB_IMAGE}:${RELEASE_TAG}" \
  --push \
  .

docker buildx build --platform linux/arm64 \
  -f internal/dockerfile_agent_alpine \
  -t "${AGENT_IMAGE}:latest" \
  -t "${AGENT_IMAGE}:${RELEASE_TAG}" \
  --push \
  .

echo "Done. Redeploy Portainer stack, then open http://opm:8090"
