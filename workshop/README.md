# Workshop materials

Welcome to _Observability Foundations for Claude Code: SecOps Edition_, a 150-minute workshop from World Wide Technology. You will work through three short labs. Everything in this folder is course material.

## Agenda

| Time | Segment                                      | Minutes |
| ---- | -------------------------------------------- | ------- |
| 0:00 | AI-Native Engineering at WWT                 | 6       |
| 0:06 | Why visibility and control matter for agents | 9       |
| 0:15 | Lab 1: Who is the agent acting as?           | 40      |
| 0:55 | Lab 2: From event to detection               | 40      |
| 1:35 | Break                                        | 5       |
| 1:40 | Lab 3: agentgateway as the control point     | 40      |
| 2:20 | Wrap-up, questions and close                 | 10      |

## Your materials

- [Pre-work](pre-work.md) ([Word version](pre-work.docx)): set up your computer before the session.
- [Foundations](foundations.md): the ideas behind the labs. Read it before or after the session.
- [Lab 1: Who is the agent acting as?](labs/01-lab-1.md) (40 minutes)
- [Lab 2: From event to detection](labs/02-lab-2.md) (40 minutes)
- [Lab 3: agentgateway as the control point](labs/03-lab-3.md) (40 minutes)
- [Best practices](best-practices.md): a take-home reference for working with Claude Code.
- [Workbook](workbook.md) ([Word version](workbook.docx)): notes and exercises to fill in as you go.
- [Slides](slides.pptx): the deck from the session.

## Scripts

| Script                       | What it does                                                                                                |
| ---------------------------- | ----------------------------------------------------------------------------------------------------------- |
| `scripts/setup-workshop.sh`  | Sets up your copy after the clone, one step at a time, asking before each step (`--yes` answers yes to all) |
| `scripts/check-setup.sh`     | Checks your computer has everything the workshop needs and tells you how to fix anything missing            |
| `scripts/check-lab-tools.sh` | Checks the lab tools: Docker with the LGTM image, Python 3, agentgateway and the lab ports                  |
| `scripts/run-lgtm.sh`        | Starts the LGTM container the labs send telemetry to                                                        |
| `scripts/stop-lgtm.sh`       | Stops and removes the LGTM container and the events in it                                                   |
| `scripts/probe-gateway.sh`   | Sends one tiny request to the local gateway and prints the HTTP status                                      |

## Next steps

Anthropic Academy has follow-on courses at https://anthropic.skilljar.com:

- Claude Code 101
- Claude Code in Action
- Introduction to agent skills
- Introduction to subagents
