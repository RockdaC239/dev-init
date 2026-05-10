#!/usr/bin/env bash
set -euo pipefail

REPO="${REPO:-https://github.com/RockdaC239/dev-init.git}"
TARGET="${TARGET:-$HOME/dev-init}"

if ! command -v git >/dev/null 2>&1; then
  if ! command -v brew >/dev/null 2>&1; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi
  brew install git
fi

if [ ! -d "$TARGET" ]; then
  git clone "$REPO" "$TARGET"
else
  git -C "$TARGET" pull --ff-only
fi

bash "$TARGET/setup.sh"
