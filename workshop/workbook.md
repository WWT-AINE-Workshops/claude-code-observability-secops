# Workbook

Use this workbook to take notes as you go. Fill in a section at the end of each lab, so you have something to take back to your own team.

## Lab 1: Who is the agent acting as?

**My `enduser_id` value from step 6.**

**How do the people on my team sign in to Claude Code today: Claude account, API key or cloud provider?**

**What surprised me.**

**What I will try in my own work.**

---

## Lab 2: From event to detection

**The number of events my `prompt_id` query returned.**

**Which of D1 to D7 my SIEM could run today, and which need tool details first.**

**What surprised me.**

**What I will try in my own work.**

---

## Lab 3: agentgateway as the control point

**How long it took from deleting Bob's key to Bob's first 401.**

**Where model traffic leaves our network today, and whether one gateway could see all of it.**

**What surprised me.**

**What I will try in my own work.**

---

## Detection readiness checklist

Mark each line: done, in progress, or not started. Circle the one your team is furthest from.

| Before you scale past a pilot                                                            | Owner                         | Status |
| ---------------------------------------------------------------------------------------- | ----------------------------- | ------ |
| Security events flow to the SIEM, locked in managed settings                             | Detection engineering         |        |
| Tool details on, with Collector redaction in place                                       | SecOps and privacy            |        |
| Identity on every event, including API key and cloud provider users                      | IAM                           |        |
| Starter detections tuned and alerting, plus a coverage alert for endpoints that go quiet | Detection engineering and SOC |        |
| Gateway enforced at the network layer, and key revocation tested                         | Security engineering          |        |
| Agent incidents added to the IR runbooks                                                 | Incident response             |        |

**My takeaway.** Write one thing you will do differently on Monday.

---

## Glossary

- **OpenTelemetry (OTel):** an open standard for producing, collecting and sending telemetry. It stores nothing.
- **OTLP:** OTel's wire protocol. gRPC on port 4317, HTTP on port 4318.
- **Collector:** the OTel component that receives, processes and routes telemetry. A security control point.
- **Event:** a timestamped structured log record, such as `tool_result`. The audit trail.
- **Trace and span:** a trace is one prompt as a tree; each span is one action in it.
- **`prompt.id`:** the ID shared by every event one prompt caused.
- **`enduser.id`:** an attribute you set to put a person on every event when the sign-in doesn't.
- **LGTM:** Loki, Grafana, Tempo and Mimir or Prometheus: Grafana's open source observability stack. The lab image uses Prometheus for metrics.
- **LogQL:** Loki's query language.
- **Managed settings:** settings an organization deploys that users and repositories can't override.
- **Virtual key:** a key the gateway issues and checks, standing in for the real provider key.
- **Strict mode:** agentgateway's setting that rejects any request without a valid key.
