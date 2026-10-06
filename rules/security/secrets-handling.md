---
description: Secrets never appear in code, output, logs, tests, notes or commits; .env.example holds placeholders only; leaked secrets are reported for rotation
alwaysApply: true
---

# Secrets handling

**Applies to:** API keys, passwords, tokens, private keys, signing secrets, connection strings with credentials, session cookies, recovery phrases — anywhere an agent might read, write, print or store them.

**Out of scope:** documenting new env vars (`env-config-sync.md`); server-side token/password storage design (`web-security-baseline.md`); E2E key custody (`security-e2e-crypto.md`).

## Never write a secret into

- **Source code or config committed to git** — no hardcoded keys, even "temporary" or "dev only".
- **Tests and fixtures** — use obviously fake values (`test-secret-not-real-0000…`) or generate them at test time.
- **`.env.example` / sample configs / docs** — placeholders only (`JWT_SECRET=change-me-min-32-chars`).
- **Logs, error messages, analytics, crash reports** — redact (`api-error-envelope.md`).
- **URLs / query strings** — they end up in logs, history and referrers.
- **Agent notes, plans, handoff files, PR descriptions, commit messages, issue comments.**
- **Container images** — no `COPY .env`, no secrets in `ARG`/`ENV` layers; use runtime env or secret mounts.
- **Client bundles** — anything shipped to a browser or app is public. Only publishable keys belong there.

## Never print a secret

- Do not `cat`, `echo`, `type` or `Get-Content` a `.env`, credentials file, keychain export or private key into the conversation or terminal output.
- To check a secret is set, check **presence or length**, not the value: `test -n "$JWT_SECRET" && echo set`, or print a fingerprint (first 4 chars + length).
- Do not paste secrets the user shares into files unless they asked for exactly that file; prefer telling them where to put it.
- Do not run commands that echo env (`env`, `printenv`, `docker inspect`, `set -x` scripts, verbose curl with auth headers) where output is captured, unless filtered.

## Generating secrets

- Use a CSPRNG: `openssl rand -base64 48`, `python -c "import secrets;print(secrets.token_urlsafe(48))"`. Write the value straight into the git-ignored `.env`, not to the chat.
- Respect documented minimums (e.g. "≥ 32 chars").

## Files and git

- `.env`, `*.pem`, `*.key`, `*.p12`, credential JSON, `*.keystore` are in `.gitignore`. If one is not, add it (`CHORE:`) and tell the user.
- Before every commit, check the staged diff for secrets (`git diff --cached`); a secret scanner (gitleaks, trufflehog) in a pre-commit hook or CI is recommended.

## If a secret leaks

A secret is **leaked** once it has been committed (even if not pushed), pushed, printed in shared output, or sent to an external service.

1. **Stop** and tell the user immediately: which secret, where it appeared, since when.
2. Recommend **rotating/revoking** it — removing it from the latest commit does not un-leak it.
3. History rewriting to purge it is a destructive action: only with explicit permission (`data-safety.md`, `git-commits.md`).
4. Never try to "quietly fix" a leak without telling the user.
