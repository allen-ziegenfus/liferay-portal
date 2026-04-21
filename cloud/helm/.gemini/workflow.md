---

alwaysApply: false
description: Commit, PR, and workflow conventions for Liferay cloud/helm
globs: *

---

# Workflow

## Commit Messages

Format: `TICKET-ID Summary of behavior change`

- Lead with the Jira ticket ID (e.g. `LCD-50935`)
- Sentence case, no trailing period
- Under 72 characters total
- Use `Wordsmith`, `Simplify`, or `Sort` for maintenance-only commits

Examples:
- `LCD-50935 Switch overlay sync from rclone to AWS CLI for marketplace compatibility`
- `LCD-50935 Simplify`
- `LCD-50935 Sort`

## Skills

The following `/skills` are available from brianchandotcom/liferay-portal:

- `/commit` — stages Claude-modified files, extracts ticket from branch, confirms before committing
- `/pr` — creates GitHub PR, transitions Jira ticket to In Review, sets Git Pull Request field
- `/jira-bug` — creates LPD bug via Jira REST API (requires `JIRA_API_USER` + `JIRA_API_TOKEN`)
- `/jira-task` — creates LPD task via Jira REST API
- `/markdown-format` — applies Liferay Markdown conventions to a file
- `/test-plan` — generates a focused pre-merge test script (≤20 min budget)