#!/usr/bin/env bash
# Turn on Claude Code telemetry and send it to the local LGTM container.
# Source it in the terminal where you start claude:  source lgtm/claude-otel.env.sh
# It only sets variables in the current terminal. Open a new terminal to start clean.

# Telemetry on, events (logs) and metrics over OTLP.
export CLAUDE_CODE_ENABLE_TELEMETRY=1
export OTEL_LOGS_EXPORTER=otlp
export OTEL_METRICS_EXPORTER=otlp

# Traces are beta: both variables are needed.
export CLAUDE_CODE_ENHANCED_TELEMETRY_BETA=1
export OTEL_TRACES_EXPORTER=otlp

# One endpoint for every signal: http/protobuf on port 4318. The SDK adds /v1/logs and the rest.
export OTEL_EXPORTER_OTLP_PROTOCOL=http/protobuf
export OTEL_EXPORTER_OTLP_ENDPOINT=http://localhost:4318

# Claude Code sends delta metrics by default. Prometheus only stores cumulative ones.
export OTEL_EXPORTER_OTLP_METRICS_TEMPORALITY_PREFERENCE=cumulative

# Bash commands, file paths and MCP names on the events. Security auditing needs this.
export OTEL_LOG_TOOL_DETAILS=1

# Export quickly, so events show in Grafana within seconds (the defaults are 5 s and 60 s).
export OTEL_LOGS_EXPORT_INTERVAL=2000
export OTEL_METRIC_EXPORT_INTERVAL=10000

echo "Claude Code telemetry is on for this terminal, sending to http://localhost:4318."
