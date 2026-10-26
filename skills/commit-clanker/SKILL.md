---
name: commit-clanker
description: >-
  Commits the current git repo using Clanker commit message style and git
  safety rules. Use only when explicitly invoked as commit-clanker or
  /commit-clanker. Extra words after the name are the prompt. If the prompt
  mentions chunks, hunks, or patch, split into logical commits without
  interactive git add -p.
disable-model-invocation: true
argument-hint: "[chunks|hunks]"
---

# commit-clanker

Slash-only. `/commit-clanker` attaches this skill to that message. Extra words are ordinary prompt text, not `$ARGUMENTS`.

- `/commit-clanker` — one commit of the current work
- `/commit-clanker hunks` / `chunks` / `patch` — split into logical commits

## Message (Clanker wins)

- Subject: present tense, imperative, first letter not capitalized, no trailing `.`, max 50 characters
- Body: bullet points, same style as the subject
- Recent `git log` subjects: match them only if they already follow these rules; otherwise use Clanker style

## Git safety (always)

1. Run `git status`, `git diff`, and `git log` first.
2. Stage relevant files. Never secrets (`.env`, credentials, keys).
3. Never `git config`. Never `--no-verify` or skip hooks. Never `-i` or interactive `git add -p`.
4. Never force-push. Never amend unless Meat Bag asked and HEAD is yours and unpushed.
5. Commit only. Push only if they said push or ship it.
6. Empty diff → no commit.
7. Commit message:
   - bash: `git commit -m "$(cat <<'EOF' ... EOF)"`
   - PowerShell: `git commit -m @" ... "@`
8. `git status` after.

## Default

No `chunks` / `hunks` / `patch` in the message: one commit of all intended changes.

## Chunks / hunks / patch

Inspect the full diff. Group by logical change, not one file per commit by default.

For each group, in order:

1. Stage only that group (`git add -- path…` when files map 1:1).
2. If one file mixes concerns, split with a patch file and `git apply --cached` (non-interactive). Never `git add -p` / `-i`.
3. Commit that group with Clanker style. Leave the rest unstaged.
4. Repeat until nothing relevant remains.
5. Report each hash and subject.

Windows and Linux. No extra deps. Do not update git config.
