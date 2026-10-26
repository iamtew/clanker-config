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
    @echo "install: {{ src }} -> {{ dest }}"
    @mkdir -p "{{ dest }}"
    @for d in "{{ src }}"/*; do \
      [ -d "$d" ] || continue; \
      name="$(basename "$d")"; \
      echo "  $name"; \
      rm -rf "{{ dest }}/$name"; \
      cp -R "$d" "{{ dest }}/$name"; \
    done
    @echo "done"

[windows]
install:
    @Write-Host "install: {{ src }} -> {{ dest }}"; New-Item -ItemType Directory -Force -Path "{{ dest }}" | Out-Null; Get-ChildItem -Directory "{{ src }}" | ForEach-Object { Write-Host ("  " + $_.Name); $target = Join-Path "{{ dest }}" $_.Name; if (Test-Path $target) { Remove-Item -Recurse -Force $target }; Copy-Item -Recurse $_.FullName $target }; Write-Host "done"

[unix]
uninstall:
    @echo "uninstall from {{ dest }} (only this repo's skill names)"
    @for d in "{{ src }}"/*; do \
      [ -d "$d" ] || continue; \
      name="$(basename "$d")"; \
      if [ -e "{{ dest }}/$name" ]; then \
        echo "  remove $name"; \
        rm -rf "{{ dest }}/$name"; \
      else \
        echo "  skip $name (not installed)"; \
      fi; \
    done
    @echo "done"

[windows]
uninstall:
    @Write-Host "uninstall from {{ dest }} (only this repo's skill names)"; Get-ChildItem -Directory "{{ src }}" | ForEach-Object { $target = Join-Path "{{ dest }}" $_.Name; if (Test-Path $target) { Write-Host ("  remove " + $_.Name); Remove-Item -Recurse -Force $target } else { Write-Host ("  skip " + $_.Name + " (not installed)") } }; Write-Host "done"
