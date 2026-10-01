# Detection starter pack

Seven LogQL queries for Claude Code security events in Loki. Paste each one into Grafana: **Explore**, data source **Loki**, switch the query editor to **Code**, then press **Run query**. Set the time range to **Last 1 hour**.

How the queries read:

- `{service_name="claude-code"}` picks Claude Code's events. Every query starts with it.
- `| event_name="tool_result"` keeps one kind of event. Loki turns the dots in attribute names into underscores, so `event.name` becomes `event_name` and `user.email` becomes `user_email`.
- `=~` matches a regular expression, and `!~` excludes one. A regular expression in backticks must match the whole value, so the patterns start and end with `.*`.
- `tool_parameters`, `tool_input` and `server_name` only exist when `OTEL_LOG_TOOL_DETAILS=1` is set. Without it, D2, D3 and D7 find nothing, and D4 matches every MCP connection.

These are starting points. Run them in hunt mode first and tune them on your own data before they page anyone.

## D1: Escalation to bypass mode

Someone switched Claude Code to `bypassPermissions`, which turns off its permission prompts.

```logql
{service_name="claude-code"} | event_name="permission_mode_changed" | to_mode="bypassPermissions"
```

Tune: expect it in sandboxes and CI containers. Alert on it from developer laptops.

## D2: Exfiltration-shaped command

A Bash command that sends data out: `curl` or `wget` with an upload flag, or `nc`. It checks both `tool_decision` (attempted, even if blocked) and `tool_result` (it ran).

```logql
{service_name="claude-code"} | event_name=~"tool_result|tool_decision" | tool_name="Bash" | tool_parameters=~`.*\b(curl|wget)\b.*(\s-d|--data|\s-T|--upload-file|\s-F).*|.*\bnc\s.*`
```

Tune: developers post to internal APIs all day. Exclude your own API hosts once you know them.

## D3: Secret file access

Claude Code read a file that usually holds credentials.

```logql
{service_name="claude-code"} | event_name="tool_result" | tool_input=~`.*"file_path": ?"[^"]*(\.env|id_rsa|id_ed25519|\.aws/|\.pem|\.p12)[^"]*".*` | tool_input!~`.*\.env\.example.*`
```

Tune: `.env.example` is excluded already. Add your own safe templates the same way.

## D4: Unapproved MCP server

An MCP server connected that is not on your allowlist. Replace `github|atlassian` with the servers you approve.

```logql
{service_name="claude-code"} | event_name="mcp_server_connection" | status="connected" | server_name!~`github|atlassian`
```

Tune: `server_name` is only present with `OTEL_LOG_TOOL_DETAILS=1`. Without it, every connection matches.

## D5: Unofficial plugin

A plugin was installed from a marketplace that is not an official Anthropic one.

```logql
{service_name="claude-code"} | event_name="plugin_installed" | marketplace_is_official="false"
```

Tune: your own internal marketplace shows up here too. Exclude it by `marketplace_name`.

## D6: Guardrail spike

A policy hook blocked something. One block is the control working. Many blocks for one person is a pattern.

```logql
{service_name="claude-code"} | event_name="hook_execution_complete" | num_blocking > 0
```

Tune: count per user and compare with their normal week, using the metric form below.

## D7: Blocked, then rerouted

The high-signal one. A tool call was rejected, and the agent reached the same destination another way. It is a two-step hunt.

Step 1: find the rejected calls.

```logql
{service_name="claude-code"} | event_name="tool_decision" | decision="reject"
```

Step 2: take the destination from the rejected call's `tool_parameters`, and look for any other tool that reached it. For the seeded story the destination is `paste.example.net`:

```logql
{service_name="claude-code"} | event_name=~"tool_decision|tool_result" | tool_parameters=~`.*paste\.example\.net.*`
```

Read the results in `event_sequence` order. A reject followed by an accepted `WebFetch` to the same host is an agent working around a control, whether or not a person meant it to.

## The investigation pivot

Every event that one prompt caused carries the same `prompt_id`. Paste the `prompt_id` from any hit in place of `PASTE-PROMPT-ID-HERE`:

```logql
{service_name="claude-code"} | prompt_id="PASTE-PROMPT-ID-HERE"
```

Sort the results oldest first with the sort-order setting above the log lines. Each line's `event_sequence` field gives the exact order.

## From a query to an alert

An alert rule needs a number, not log lines. Wrap a detection in `count_over_time` and sum it per user. This is D1 as a metric:

```logql
sum by (user_email) (count_over_time({service_name="claude-code"} | event_name="permission_mode_changed" | to_mode="bypassPermissions" [5m]))
```

In Grafana: **Alerting**, **Alert rules**, **New alert rule**, data source **Loki**, paste the query, and set the condition to **Is above 0**.
