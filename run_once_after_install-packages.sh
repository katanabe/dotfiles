#!/bin/sh
set -u

eval "$(/opt/homebrew/bin/brew shellenv)"

brew bundle --file="$HOME/.config/Brewfile" || echo "warn: brew bundle had errors (continuing)"
sheldon lock
