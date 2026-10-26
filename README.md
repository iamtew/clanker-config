# Clanker Config

tew's files to configure his AI agents, tracked here for his convenience.

Needs `just` on PATH (Windows and Linux).

## `skills/`

Each folder here is a Cursor skill. Install copies it to `~/.cursor/skills/<name>/` (`HOME`, or `USERPROFILE` on Windows). Slash-invoked skills (`/commit-clanker`, `/bump-version-clanker`): extra words after the name are the prompt.

```
just install
just update
just uninstall
```

`update` is the same as `install`. Both replace only this repo's skill folders at the dest. Other skills already there (ponytail, etc.) are left alone.

## `Rules/`

Not installed by the Justfile.

- **Project:** copy `Rules/clanker.mdc` to `<repo>/.cursor/rules/clanker.mdc` (Always Apply).
- **Global:** **Cursor UI → Customize → Rules**. User Rules are free-form — paste the markdown **body** (below the frontmatter). Frontmatter is for `.mdc` / project rules.
