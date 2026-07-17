#!/bin/sh
set -u

eval "$(/opt/homebrew/bin/brew shellenv)"

# Trust third-party taps before brew bundle loads their formulae when tap trust is required.
brew trust --tap microsoft/apm || echo "warn: could not trust microsoft/apm tap (continuing)"
brew trust --tap mobile-dev-inc/tap || echo "warn: could not trust mobile-dev-inc/tap tap (continuing)"
brew trust --tap sinelaw/fresh || echo "warn: could not trust sinelaw/fresh tap (continuing)"

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

# Markdown viewer used from herdr panes. frogmouth pins old deps that crash on
# Python 3.14+ (httpcore vs typing.Union), so pin the interpreter to 3.12.
# Idempotent: skip if already installed.
if command -v uv >/dev/null 2>&1 && ! NO_COLOR=1 uv tool list 2>/dev/null | grep -q '^frogmouth'; then
  uv tool install --python 3.12 frogmouth || echo "warn: frogmouth install failed (continuing)"
fi
