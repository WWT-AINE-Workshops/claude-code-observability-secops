#!/usr/bin/env bash
set -euo pipefail

# Start the LGTM stack (OpenTelemetry Collector, Loki, Tempo, Prometheus, Grafana) in one
# container called workshop-lgtm. It only touches that container.
#
#   ./scripts/run-lgtm.sh                                            the image's own Collector config
#   ./scripts/run-lgtm.sh --collector secops/otel-collector-secops.yaml   your Collector config instead

IMAGE="grafana/otel-lgtm:0.37.0"
NAME="workshop-lgtm"
PORTS="3000 4317 4318"

COLLECTOR=""
if [ "${1:-}" = "--collector" ]; then
  [ -n "${2:-}" ] || { echo "Usage: ./scripts/run-lgtm.sh --collector <config file>"; exit 2; }
  [ -f "$2" ] || { echo "No such file: $2"; exit 2; }
  COLLECTOR="$(cd "$(dirname "$2")" && pwd)/$(basename "$2")"
elif [ -n "${1:-}" ]; then
  echo "Usage: ./scripts/run-lgtm.sh [--collector <config file>]"
  exit 2
fi

if ! command -v docker >/dev/null 2>&1; then
  echo "Docker is not installed. See the pre-work, step 5."
  exit 1
fi
if ! docker info >/dev/null 2>&1; then
  echo "Docker is installed but not running. Start Docker Desktop (or the Docker service), then run this again."
  exit 1
fi

state="$(docker inspect -f '{{.State.Status}}' "$NAME" 2>/dev/null || true)"
if [ "$state" = "running" ]; then
  if [ -n "$COLLECTOR" ]; then
    echo "$NAME is already running. Stop it first with ./scripts/stop-lgtm.sh, then run this again."
    exit 1
  fi
  echo "$NAME is already running. Grafana: http://localhost:3000"
  exit 0
fi
if [ -n "$state" ]; then
  docker rm "$NAME" >/dev/null
fi

for port in $PORTS; do
  if (exec 3<>"/dev/tcp/127.0.0.1/${port}") 2>/dev/null; then
    echo "Port $port is already in use. Stop whatever is using it, then run this again."
    echo "To see what it is: lsof -nP -iTCP:${port} -sTCP:LISTEN"
    exit 1
  fi
done

args=(run -d --name "$NAME" -p 3000:3000 -p 4317:4317 -p 4318:4318)
if [ -n "$COLLECTOR" ]; then
  # ENABLE_LOGS_OTELCOL shows the Collector's own output in docker logs: the stand-in SIEM.
  args+=(-v "${COLLECTOR}:/otel-lgtm/otelcol-config.yaml:ro" -e ENABLE_LOGS_OTELCOL=true)
fi
args+=("$IMAGE")

echo "Starting $NAME from $IMAGE..."
docker "${args[@]}" >/dev/null

for _ in $(seq 1 120); do
  if curl -sf -m 2 http://localhost:3000/api/health >/dev/null 2>&1 \
    && [ "$(curl -s -m 2 -o /dev/null -w '%{http_code}' -X POST -H 'Content-Type: application/json' -d '{}' http://localhost:4318/v1/logs 2>/dev/null)" = "200" ]; then
    echo "LGTM is ready. Grafana: http://localhost:3000"
    [ -n "$COLLECTOR" ] && echo "Collector config: $COLLECTOR"
    exit 0
  fi
  sleep 1
done

echo "LGTM did not become ready in 2 minutes. Its last log lines:"
docker logs --tail 20 "$NAME" 2>&1 || true
exit 1
