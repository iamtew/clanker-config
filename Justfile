# Skills only: copy each skills/<name>/ into ~/.cursor/skills/<name>/.
# Replaces those dirs only. Other dest skills (ponytail, etc.) stay.
# Rules/ is NOT installed. Copy-paste into Cursor UI → Customize → Rules.
#
# update is the same as install (replace the dest skill dir so leftovers do not linger).

set windows-shell := ["powershell.exe", "-NoProfile", "-Command"]

home := env_var_or_default("HOME", env_var_or_default("USERPROFILE", ""))
src := justfile_directory() / "skills"
dest := home / ".cursor" / "skills"

default:
    @just --list

alias update := install

[unix]
install:
    @mkdir -p "{{ dest }}"
    @for d in "{{ src }}"/*; do \
      [ -d "$d" ] || continue; \
      name="$(basename "$d")"; \
      rm -rf "{{ dest }}/$name"; \
      cp -R "$d" "{{ dest }}/$name"; \
    done

[windows]
install:
    @New-Item -ItemType Directory -Force -Path "{{ dest }}" | Out-Null; Get-ChildItem -Directory "{{ src }}" | ForEach-Object { $target = Join-Path "{{ dest }}" $_.Name; if (Test-Path $target) { Remove-Item -Recurse -Force $target }; Copy-Item -Recurse $_.FullName $target }

[unix]
uninstall:
    @for d in "{{ src }}"/*; do \
      [ -d "$d" ] || continue; \
      name="$(basename "$d")"; \
      rm -rf "{{ dest }}/$name"; \
    done

[windows]
uninstall:
    @Get-ChildItem -Directory "{{ src }}" | ForEach-Object { $target = Join-Path "{{ dest }}" $_.Name; if (Test-Path $target) { Remove-Item -Recurse -Force $target } }
