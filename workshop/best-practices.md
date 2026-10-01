# Best practices

A take-home reference for running coding agents with visibility and control. Each practice says what to do, why it works, and where you practised it.

## Lock telemetry on in managed settings

Set the telemetry and exporter variables in managed settings, not in each developer's own settings. Managed settings win, and a repository can't turn telemetry on or redirect it. Pin the exporter selectors too: a repository can still set a signal to `none` otherwise. Practised in Lab 1, step 2 and the stretch goals.

## Turn on tool details, and redact centrally

Set `OTEL_LOG_TOOL_DETAILS=1`. Without it, commands, file paths and MCP server names are missing, and half the detections have nothing to match. Commands can contain secrets, so redact them in the Collector, where no client setting can bypass it. Practised in Lab 1, step 2 and the Lab 2 stretch goal.

## Put a person on every event

With an API key or a cloud provider, events carry only an install ID. Set `enduser.id` per user through managed settings or a launch wrapper, or put a gateway in front that adds the user from the key. Practised in Lab 1, steps 5 and 6.

## Detect on events, investigate on prompt.id

Claude Code sends the raw events; detection and correlation are your SIEM's job. Write detections on `event_name` and the fields that matter, start them in hunt mode, and tune before they page anyone. When one fires, pivot on its `prompt_id` to see everything that instruction caused, in order. Practised in Lab 2, steps 3 to 5.

## Build the reroute detection first

A rejected tool call followed by another tool reaching the same destination is the highest-signal pattern in the starter pack. It catches an agent working around a control, whether or not a person meant it to. Practised in Lab 2, step 5.

## Keep every security event

Sampling is for traces and dashboards. Keep every security event, retain it to your audit policy, and ship it off the laptop quickly. Control cost by filtering which events go to the SIEM, not by sampling. Practised in the Lab 2 stretch goal.

## Match the metric temporality to the backend

Claude Code sends delta metrics by default. Prometheus stores cumulative ones, so set `OTEL_EXPORTER_OTLP_METRICS_TEMPORALITY_PREFERENCE=cumulative` when Prometheus is the backend. Practised in Lab 2, step 6.

## Keep the real key in the gateway

Give every laptop a virtual key and keep the provider key in the gateway, in strict mode. You get a person on every request, a budget per key, and containment that is one change at one point. Practised in Lab 3, steps 1, 2 and 6.

## Join the two views

Client telemetry shows what the agent did; gateway telemetry shows every model request, whatever the laptop does. Gateway traffic with no client events is a coverage gap. Client events with no gateway traffic is a bypass. Alert on both. Practised in Lab 3, step 4 and the stretch goals.
