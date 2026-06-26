#!/usr/bin/env bash
# Build Anarchy Pulse hub + agent on Mac (Docker Desktop), push to Docker Hub.
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
HUB_IMAGE="jt7777/anarchy-pulse"
AGENT_IMAGE="jt7777/anarchy-pulse-agent"
BUILD_ID="$(date +%Y%m%d-%H%M%S)"
RELEASE_TAG="release-${BUILD_ID}"

echo ""
echo "=== Publish Anarchy Pulse → Docker Hub ==="
echo "  ${HUB_IMAGE}:latest"
echo "  ${AGENT_IMAGE}:latest"
echo ""

if ! docker info >/dev/null 2>&1; then
  echo "Docker is not running. Open Docker Desktop first."
  exit 1
fi

echo "Ensure you are logged in: docker login"

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

echo "Building hub (linux/amd64 + linux/arm64)..."
docker buildx build --platform linux/amd64,linux/arm64 \
  -f internal/dockerfile_hub \
  -t "${HUB_IMAGE}:latest" \
  -t "${HUB_IMAGE}:${RELEASE_TAG}" \
  --push \
  .

echo "Building agent alpine (linux/amd64 + linux/arm64)..."
docker buildx build --platform linux/amd64,linux/arm64 \
  -f internal/dockerfile_agent_alpine \
  -t "${AGENT_IMAGE}:latest" \
  -t "${AGENT_IMAGE}:${RELEASE_TAG}" \
  -t "${AGENT_IMAGE}:alpine" \
  --push \
  .

echo ""
echo "============================================"
echo "DONE"
echo "  Hub:   ${HUB_IMAGE}:latest"
echo "  Agent: ${AGENT_IMAGE}:latest"
echo ""
echo "Portainer → Stacks → Pull and redeploy"
echo "Open: http://opm:8090"
echo "============================================"
echo ""
