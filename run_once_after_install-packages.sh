#!/bin/sh
set -u

eval "$(/opt/homebrew/bin/brew shellenv)"

brew bundle --file="$HOME/.config/Brewfile" || echo "warn: brew bundle had errors (continuing)"
sheldon lock

# Daily `brew update` only (no auto-upgrade — we run `brew upgrade` manually).
brew autoupdate status 2>/dev/null | grep -q "running" || brew autoupdate start 86400
