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

User rules for Cursor. Copy-paste the contents into **Cursor UI → Customize → Rules**. Do not install these with the Justfile.
