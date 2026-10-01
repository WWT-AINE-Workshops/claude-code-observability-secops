#!/usr/bin/env bash
# Point Claude Code at the local agentgateway as Alice, with telemetry on.
# Source it from the root of your workshop folder, in a new terminal, not the one running agentgateway:
#   source agentgateway/claude-agentgateway.env.sh
# It only sets variables in the current terminal. It works in bash and zsh.

if [ ! -f lgtm/claude-otel.env.sh ]; then
  echo "Run this from the root of your workshop folder: cd there, then source agentgateway/claude-agentgateway.env.sh again."
  return 1
fi
source lgtm/claude-otel.env.sh

# The real key belongs to the gateway only. Claude Code must not see it here.
unset ANTHROPIC_API_KEY

# All model traffic goes through the gateway, with Alice's gateway key.
# agentgateway reads the key from the Authorization: Bearer header, which ANTHROPIC_AUTH_TOKEN sets.
export ANTHROPIC_BASE_URL=http://localhost:4000
export ANTHROPIC_AUTH_TOKEN=sk-agw-alice-demo

# The same user on Claude Code's own events, so the two streams join on user.
export OTEL_RESOURCE_ATTRIBUTES="enduser.id=alice@example.com,team.id=platform"

# If Claude Code reports "Extra inputs are not permitted", remove the # from the next line and source this file again.
# export CLAUDE_CODE_DISABLE_EXPERIMENTAL_BETAS=1

echo "Claude Code will use agentgateway at http://localhost:4000 as alice@example.com."
