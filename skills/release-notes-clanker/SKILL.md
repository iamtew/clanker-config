---
name: release-notes-clanker
description: >-
  Prints GitHub Release markdown: a 1–3 sentence blurb from commit subjects
  and bodies, then a bullet list of short hash plus commit title. Default
  range is between the two latest git tags. Optional from/to tags or versions
  select that period instead. Use only when explicitly invoked as
  release-notes-clanker or /release-notes-clanker. Extra words after the name
  are the prompt.
disable-model-invocation: true
argument-hint: "[from] [to]"
---

# release-notes-clanker

Slash-only. `/release-notes-clanker` attaches this skill to that message. Extra words are ordinary prompt text, not `$ARGUMENTS`.

- `/release-notes-clanker` — notes between the two latest tags
- `/release-notes-clanker 1.2.3` — that version vs the previous tag
- `/release-notes-clanker 1.2.0 1.3.0` — that period (`from..to`)

Do not write a CHANGELOG file. Do not create a GitHub release unless Meat Bag asked.

## Range

Tags: `git tag --sort=-version:refname`. Resolve an optional leading `v` against existing tags (`1.2.3` vs `v1.2.3`).

- No versions in the prompt: newer = first tag, older = second tag.
- One version: newer = that tag, older = the next tag after it in that sorted list (previous release).
- Two versions: older = the earlier of the two, newer = the later. Order in the prompt does not matter.

Range is `OLDER..NEWER` (exclusive of the older tag commit).

Stop and ask if: not a git repo; no tags and none given; a named tag/version is missing; only one tag exists and Meat Bag asked for default or a single-version period with no previous tag.

## Git

Messages only. Newest first. Skip merges. `--no-patch` so an alias `-p` cannot leak diffs.

```bash
git log --no-merges --no-patch --format='%h%n%s%n%n%b' OLDER..NEWER
```

Hash, subject, blank line, body per commit. Use subjects **and** bodies for the blurb. Published bullets are hash + subject only.

Normal tag-to-tag ranges: read the whole log. Huge log (hundreds of commits or novel-length bodies): still emit every hash+title bullet; write the blurb from all subjects plus only the first ~20 bodies.

Windows and Linux. No extra deps. Do not update git config.

## Output

The reply **is** one copy-paste block: a closed `markdown` code fence. Open fence, GitHub Release body, close fence. Do not print the notes as rendered markdown. Do not print a second copy outside the fence. Meat Bag copies the fence **contents** into the GitHub Release form.

Inside the fence, top line is the title: `##` plus the **newer** tag (the version these notes are for). Use the tag as it exists (`1.2.3` or `v1.2.3`). Then a blank line, then the blurb, then the list.

No backticks around hashes, no compare URLs (GitHub autolinks the hash).

Blurb: high-level, **at most 3 sentences**, from subjects and bodies. No feature tour. No invented work.

Then the bullet list, newest first: bare `%h`, space, subject.

Chat reply shape (the fence is required):

````
```markdown
## 1.2.4

Fixes the login timeout and adds a quieter retry. Config now lives in one file.

- a1b2c3d add the thing
- e4f5g6h fix the bug
```
````
