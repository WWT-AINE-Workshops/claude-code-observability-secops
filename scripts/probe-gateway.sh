#!/usr/bin/env bash
set -euo pipefail

# Send one tiny Messages API request to the local agentgateway and print the HTTP status.
#   ./scripts/probe-gateway.sh                     no key
#   ./scripts/probe-gateway.sh sk-agw-wrong        a wrong key
#   ./scripts/probe-gateway.sh sk-agw-bob-demo     Bob's key
# A request the gateway accepts is forwarded to Anthropic and uses a few tokens of your key.

GATEWAY="${GATEWAY:-http://localhost:4000}"
KEY="${1:-}"
BODY='{"model":"claude-haiku-5-5","max_tokens":8,"messages":[{"role":"user","content":"Reply with OK"}]}'

auth=()
[ -n "$KEY" ] && auth=(-H "Authorization: Bearer ${KEY}")

out="$(mktemp)"
trap 'rm -f "$out"' EXIT
status="$(curl -s -o "$out" -w '%{http_code}' -m 30 "${auth[@]+"${auth[@]}"}" \
  -H 'content-type: application/json' -H 'anthropic-version: 2023-06-01' \
  -d "$BODY" "${GATEWAY}/v1/messages" || true)"

case "$status" in
  000) echo "No answer from ${GATEWAY}. Is agentgateway running?"; exit 1 ;;
  401|403)
    # Anthropic's own errors are JSON with "type":"error". Anything else came from the gateway.
    if grep -q '"authentication_error"\|"permission_error"' "$out"; then
      echo "HTTP $status: rejected by Anthropic. The gateway forwarded it, so its backend key is wrong or empty."
    else
      echo "HTTP $status: rejected at the gateway."
    fi ;;
  200) echo "HTTP 200: accepted and forwarded to Anthropic." ;;
  400|404) echo "HTTP $status: the gateway forwarded it, but Anthropic did not accept the model name. Check that your key can use claude-haiku-5-5." ;;
  *) echo "HTTP $status" ;;
esac
