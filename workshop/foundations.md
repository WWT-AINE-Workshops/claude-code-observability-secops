# Foundations

A coding agent doesn't only answer. It acts: it runs shell commands, edits files, fetches web pages and calls other systems, with the developer's own credentials. Security has to see every one of those actions and be able to stop any of them. This chapter explains the ideas the labs rest on. Read it before or after the session; it takes about ten minutes.

## Agents act, so security needs evidence and control

A chat assistant writes text, and a person decides what happens next. A coding agent chains many actions from one instruction, and it takes instructions from whatever it reads, including a README or a web page the developer never looked at. That is prompt injection.

In a developer's session, Claude Code doesn't act under a separate service account. Its actions are the developer's. Your endpoint tools see the processes and the network flows, but not the instruction that caused them. Agent telemetry fills that gap.

You need two things: **visibility**, to know what happened, and **control**, to decide what can happen. They form a loop: observe, detect, decide, enforce, then verify with the same telemetry that the control fired.

## What OpenTelemetry is, and isn't

OpenTelemetry (OTel) is an open, vendor-neutral standard for producing, collecting and sending telemetry. It is a specification, a set of language SDKs, a Collector and a wire protocol called OTLP. It is **not** a SIEM or a backend: it stores nothing and alerts on nothing. That is your platform's job. Claude Code speaks OTel natively, so its events reach the SIEM you already run.

## The signals, through a security lens

| Signal        | What it is                     | Security use                            | In Claude Code                                  |
| ------------- | ------------------------------ | --------------------------------------- | ----------------------------------------------- |
| Logs (events) | Timestamped structured records | The audit trail: detections and hunting | `tool_result`, `tool_decision`, `auth` and more |
| Traces        | One request as a tree of spans | Rebuild the chain of actions            | One trace per prompt (beta)                     |
| Metrics       | Numbers over time              | Baselines and volume anomalies          | Token usage and cost                            |

For security, logs come first. Claude Code's security events travel on the logs signal.

## Anatomy of a trace

A trace is one prompt, shown as a tree. The root span, `claude_code.interaction`, is the prompt. Under it sit spans for each model request (`claude_code.llm_request`) and each tool call (`claude_code.tool`). Every span has a start and an end time and attributes such as the tool and the path.

In an injection story, the trace shows that the README read came before the attempt to send data out. Events give you the same facts, joined by `prompt.id`; the trace gives you the order and the causality in one view.

## How the pieces fit

Claude Code sends its telemetry over OTLP: gRPC on port 4317, or HTTP on port 4318. The labs use HTTP (`http/protobuf`). Two details catch people out:

- A per-signal endpoint, such as the one for logs, must include the full path ending in `/v1/logs`. A generic endpoint gets the path added for you.
- The protocol and the port must match.

In the middle sits a **Collector**. For security it is a control point: it can redact credentials before anything stores them, send only security events to the SIEM to keep ingest costs down, and send one copy to each destination. Sampling is a trace idea; never sample the audit path.

In the labs, the backend is Grafana's LGTM image: one container with the Collector, Loki for logs, Tempo for traces, Prometheus for metrics and Grafana on top. It is built for development, demos and testing, not production.

## Identity: who did it

Signed in with a Claude account, every event carries `user.email`, the account and organization IDs, `user.id` and `session.id`.

With a direct API key, or on a cloud provider such as Amazon Bedrock, there is no Claude account, so only `user.id` and `session.id` are filled in. `user.id` is a random install ID, not a person. Close the gap by setting `enduser.id` through `OTEL_RESOURCE_ATTRIBUTES`, per user, in managed settings or a launch wrapper. A gateway can add identity from the network side too.

## The glue: correlation IDs

- `session.id` groups one session.
- `prompt.id` groups everything one prompt caused. It is your main pivot in an investigation.
- `event.sequence` orders events within one Claude Code process.
- `tool_use_id` matches what hooks receive, so policy hook records join the events.

## Content gates

Four settings, all off by default, decide how much content reaches your backend:

| Setting                   | What you get                                         | What you take on                       |
| ------------------------- | ---------------------------------------------------- | -------------------------------------- |
| `OTEL_LOG_TOOL_DETAILS`   | Bash commands, file paths, MCP server and tool names | Commands may contain secrets           |
| `OTEL_LOG_USER_PROMPTS`   | What the user asked                                  | Prompts may hold personal data or code |
| `OTEL_LOG_TOOL_CONTENT`   | What tools returned, on spans                        | Raw file contents in your backend      |
| `OTEL_LOG_RAW_API_BODIES` | The whole conversation                               | The highest sensitivity. Avoid it      |

Turn tool details on for security, and redact in the Collector.

## Don't sample your audit trail

- **Keep every event.** Agent actions are evidence.
- **Retain to your audit policy**, not your dashboard's.
- **Ship off the laptop fast**, to storage that can't be rewritten.
- **Lock telemetry on** in managed settings, and alert when a machine goes quiet.

## Five things to remember

1. Security events travel on the logs signal. Point it at your SIEM first.
2. A raw API key means no real identity on events. Set `enduser.id`, or use a gateway.
3. Redact in the Collector, centrally, before anything stores the data.
4. `prompt.id` tells the story of one instruction.
5. `http/protobuf` on 4318, with the full `/v1/logs` path on a per-signal endpoint, avoids the most common cause of nothing arriving.

## The labs in this workshop

- Lab 1: Who is the agent acting as? (40 minutes). Telemetry, identity and the API key gap.
- Lab 2: From event to detection (40 minutes). Starter detections and the `prompt.id` pivot.
- Lab 3: agentgateway as the control point (40 minutes). Strict keys, one user in two streams, and revocation.
