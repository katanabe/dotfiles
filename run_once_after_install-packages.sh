#!/bin/sh
set -u

eval "$(/opt/homebrew/bin/brew shellenv)"

brew bundle --file="$HOME/.config/Brewfile" || echo "warn: brew bundle had errors (continuing)"
sheldon lock

# Daily `brew update` only (no auto-upgrade — we run `brew upgrade` manually).
brew autoupdate status 2>/dev/null | grep -q "running" || brew autoupdate start 86400

# Deploy APM skills from chezmoi-managed apm.yml/apm.lock.yaml.
# --frozen-lockfile fails if manifest and lockfile disagree, guaranteeing reproducibility.
[ -f "$HOME/.apm/apm.yml" ] && apm install -g --frozen-lockfile

# Register prek pre-commit hooks in the chezmoi source repo.
if command -v prek >/dev/null 2>&1; then
  (cd "$HOME/.local/share/chezmoi" && prek install)
fi
