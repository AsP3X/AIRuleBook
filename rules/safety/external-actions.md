---
description: Actions with effects outside the local repo and machine — deploys, production changes, messages, publishing, paid APIs, cloud resources — need explicit per-action approval
alwaysApply: true
---

# Production and external actions

**Applies to:** any action whose effect leaves the developer's machine or local repository, or touches a shared or production system.

**Out of scope:** local destructive actions (`data-safety.md`), `git push` / merge / force-push (`git-commits.md`), local Docker (`docker-compose-safety.md`).

**Origin:** new (2026-10-05); complements `data-safety.md` and pzserver's "never cut a Workshop release without asking".

**Customize:** list your project's environments and deploy commands in the table at the end.

## Requires explicit approval for that specific action

The user must ask for **this** action in the current conversation, or confirm it when you ask. Approval for one action does not carry over to the next one, or to a later session.

| Category | Examples |
|---|---|
| **Deploy / release** | Deploy scripts (`deploy.sh`, `deploy.ps1`), `kubectl apply`, `terraform apply`, `fly deploy`, `vercel --prod`, App Store / Play Store / TestFlight uploads, Steam Workshop publish, `npm publish`, `cargo publish`, Docker image push to a registry. |
| **Production / shared data** | Any write to a production or shared staging database, queue or bucket; running migrations against a non-local DB; admin API calls against live servers; RCON/console commands on a live server. |
| **Messages to people** | Sending email, SMS, push notifications, Slack/Discord/Teams messages, creating or commenting on issues/PRs, calendar invites. |
| **Infrastructure** | Creating, scaling or deleting cloud resources; DNS, TLS certificate, firewall or CDN changes; rotating or creating credentials. |
| **Money** | Calling paid APIs in loops or bulk jobs, buying or upgrading plans, anything that consumes credits at scale. |
| **Accounts & settings** | Changing repo settings, branch protection, webhooks, OAuth apps, team membership, or third-party integrations. |

## Allowed without asking

Read-only inspection of non-production systems the task needs (status, logs, `GET` requests, `terraform plan`, `kubectl get`), and local dry-runs. If a read-only command could leak secrets or personal data into output, treat it as sensitive (`secrets-handling.md`).

## Before asking

State clearly: **what** will happen, **where** (environment, host, account), **reversibility** (and the rollback command), and **cost or blast radius**. Prefer a dry-run / plan first and show its output.

## Always

- Default to the **least** powerful environment: local → dev → staging → production.
- Never use production credentials for testing; never point local tools at production by changing env "temporarily".
- Never schedule or automate an external action (cron, CI job, workflow) without approval.
- After an approved action, verify the outcome and report it (`definition-of-done.md`).

## Project environments

| Environment | How to reach it | Deploy command | Notes |
|---|---|---|---|
| {{ENV}} | {{HOST/URL}} | {{CMD}} | {{NOTES}} |
