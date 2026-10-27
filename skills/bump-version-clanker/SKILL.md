---
name: bump-version-clanker
description: >-
  Bumps the project version by one, commits only version files, creates an
  annotated git tag, optionally pushes the branch and tags, then prints
  markdown release notes. Use only when explicitly invoked as
  bump-version-clanker or /bump-version-clanker. Extra words after the name
  are the prompt. Default patch bump. major/breaking, minor/feature, or
  patch select the semver component. push means git push then git push --tags.
disable-model-invocation: true
argument-hint: "[push|major|minor|patch]"
---

# bump-version-clanker

Slash-only. `/bump-version-clanker` attaches this skill to that message. Extra words are ordinary prompt text, not `$ARGUMENTS`.

- `/bump-version-clanker` — patch bump, commit version files, tag, no push
- `/bump-version-clanker minor` / `feature` — Y+1, Z=0
- `/bump-version-clanker major` / `breaking` — X+1, Y=0, Z=0
- `/bump-version-clanker patch` — Z+1 (same as default)
- add `push` — after tag: `git push` then `git push --tags`

## Bump

Default: **patch** (`1.2.3` → `1.2.4`).

Parse `X.Y.Z` (ignore a leading `v` in the file). Drop any prerelease suffix, then bump the numeric triple as requested.

Find the **project’s** version, not dependency versions. Keep every file that is clearly this project’s version in sync:

- `package.json` `version` (and root `package-lock.json` `version` if it mirrors the package)
- `Cargo.toml` `[package] version`
- `pyproject.toml` / `setup.cfg` / `setup.py`
- `*.csproj` `Version` / `PackageVersion`
- `build.gradle` / `Chart.yaml` / `VERSION` / `version.txt`
- Go: `VERSION` file or an obvious `version =` in the main module — not `go.mod`

Do not bump lockfile package entries. Do not invent a version scheme. No version, or several unrelated apps: stop and ask.

Do not write a CHANGELOG file unless that file is itself a version source already being edited.

## Git safety (always)

1. Run `git status` and `git diff` first. No `git log` for style.
2. **Stage and commit only the version files.** Other local changes stay unstaged. Never secrets.
3. Never `git config`. Never `--no-verify` or skip hooks. Never `-i` or interactive `git add -p`.
4. Never force-push. Never `tag -f`. Never amend unless Meat Bag asked and HEAD is yours and unpushed. If amending, `git log -1` only for authorship/unpushed — not style.
5. Empty version diff → no commit, no tag.
6. Clanker message:

   - subject: present tense, imperative, first letter not capitalized, no trailing `.`, max 50 characters — e.g. `bump version to 1.2.4`
   - body: bullet points, same style
   - bash: `git commit -m "$(cat <<'EOF' ... EOF)"`
   - PowerShell: `git commit -m @" ... "@`
7. `git status` after the commit.

## Tag

After the version commit, create an **annotated** tag (`git tag -a`). Message = the version string (no extra prose).

Name: match existing tags (`v1.2.3` vs `1.2.3`). If the repo has **no tags**, use **no `v`** (`1.2.4`).

If that tag already exists: stop. Never retag.

## Push

Only if the prompt contains `push`:

1. `git push` the current branch (not force). If there is no remote/upstream, report it and stop; do not invent one.
2. `git push --tags` (not force). Required so remotes that trigger on tags see the tag.

No `push` in the prompt → no push.

## Release notes

After tag (and push if asked), print **one** markdown copy-paste fence for Meat Bag:

- Title = new version
- Bullets = `git log` **subjects**, newest first, from the previous tag (or first commit if none) through the new tag, including the bump commit
- One line per subject

```markdown
## 1.2.4

- bump version to 1.2.4
- add the thing
```

Windows and Linux. No extra deps. Do not update git config.
