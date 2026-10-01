#!/usr/bin/env bash
set -euo pipefail

# Stop and remove the workshop-lgtm container. Its data goes with it. Nothing else is touched.

NAME="workshop-lgtm"
if ! command -v docker >/dev/null 2>&1 || ! docker info >/dev/null 2>&1; then
  echo "Docker is not running, so there is nothing to stop."
  exit 0
fi
if docker inspect "$NAME" >/dev/null 2>&1; then
  docker rm -f "$NAME" >/dev/null
  echo "Stopped and removed $NAME."
else
  echo "$NAME is not running."
fi
