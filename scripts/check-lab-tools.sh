#!/usr/bin/env bash
set -uo pipefail
# Check the tools the labs need: Docker with the LGTM image, Python 3, agentgateway, and the lab ports.
# Run it after ./scripts/check-setup.sh. It only reads and reports, and changes nothing.
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$HERE/lib/common.sh"
set +e
OS="$(uname -s)"
hint() { if [ "$OS" = "Darwin" ]; then echo "$1"; else echo "$2"; fi; }

echo "Checking the lab tools for ${WORKSHOP_NAME}…"
echo

LGTM_IMAGE="grafana/otel-lgtm:0.37.0"
AGW_VERSION="1.6.0"

if command -v docker >/dev/null 2>&1; then
  if docker info >/dev/null 2>&1; then
    ok "Docker is running"
    if docker image inspect "$LGTM_IMAGE" >/dev/null 2>&1; then
      ok "LGTM image $LGTM_IMAGE"
    else
      fail_check "LGTM image $LGTM_IMAGE not pulled yet" "run: docker pull $LGTM_IMAGE (a large download: do it before the session)"
    fi
  else
    fail_check "Docker is installed but not running" "$(hint 'start Docker Desktop, then run this again' 'start Docker (Docker Desktop, or: sudo service docker start), then run this again')"
  fi
else
  fail_check "Docker not found" "$(hint 'install Docker Desktop: https://docs.docker.com/desktop/setup/install/mac-install/' 'install Docker Engine (https://docs.docker.com/engine/install/) or Docker Desktop with WSL integration')"
fi

if command -v python3 >/dev/null 2>&1; then
  PY_V="$(python3 -c 'import sys; print("%d.%d.%d" % sys.version_info[:3])' 2>/dev/null)"
  if version_ge "${PY_V:-0}" "3.8.0"; then ok "Python $PY_V"; else fail_check "Python ${PY_V:-(unknown)} is too old (need 3.8+)" "$(hint 'brew install python' 'sudo apt-get install -y python3')"; fi
else
  fail_check "Python 3 not found" "$(hint 'brew install python' 'sudo apt-get install -y python3')"
fi

if command -v agentgateway >/dev/null 2>&1; then
  AGW_OUT="$(agentgateway --version 2>&1 | head -n 1)"
  if printf '%s' "$AGW_OUT" | grep -q "$AGW_VERSION"; then ok "agentgateway $AGW_VERSION"
  else warn "agentgateway found, but not version $AGW_VERSION (it said: ${AGW_OUT:-nothing})" "the labs are tested with $AGW_VERSION; see the pre-work, step 5"; fi
else
  fail_check "agentgateway not found" "install version $AGW_VERSION: see the pre-work, step 5"
fi

if [ -n "${ANTHROPIC_API_KEY:-}" ]; then
  warn "ANTHROPIC_API_KEY is already set in this terminal" "if your shell profile sets it, remove it there: the key belongs in your password manager, and Lab 1 starts without it"
else
  ok "ANTHROPIC_API_KEY is not set in your shell (you type it in the labs)"
fi

LGTM_UP=0
[ "$(docker inspect -f '{{.State.Status}}' workshop-lgtm 2>/dev/null)" = "running" ] && LGTM_UP=1
for port in 3000 4317 4318 4000 15000; do
  if (exec 3<>"/dev/tcp/127.0.0.1/${port}") 2>/dev/null; then
    case "$LGTM_UP:$port" in
      1:3000|1:4317|1:4318) ok "Port $port is used by the workshop-lgtm container" ;;
      *) warn "Port $port is in use" "the labs need it; stop whatever is using it (lsof -nP -iTCP:${port} -sTCP:LISTEN shows what)" ;;
    esac
  fi
done

echo
if [ "$FAILED" = 0 ]; then echo "Lab tools ready."; exit 0; fi
echo "Fix the ❌ items above, then run this again."
exit 1
