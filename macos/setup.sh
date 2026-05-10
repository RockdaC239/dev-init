#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CONFIG="$ROOT/config/tools.json"

step() {
  printf "\n==> %s\n" "$1"
}

require_json_value() {
  local query="$1"
  ruby -rjson -e "data = JSON.parse(File.read('$CONFIG')); $query"
}

step "Checking Homebrew"
if ! command -v brew >/dev/null 2>&1; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

step "Installing Homebrew formulae"
require_json_value "puts data['brew']['formulae']" | while IFS= read -r package; do
  [ -z "$package" ] && continue
  brew list "$package" >/dev/null 2>&1 || brew install "$package"
done

step "Installing Homebrew casks"
require_json_value "puts data['brew']['casks']" | while IFS= read -r package; do
  [ -z "$package" ] && continue
  brew list --cask "$package" >/dev/null 2>&1 || brew install --cask "$package"
done

step "Installing global npm CLIs"
if command -v npm >/dev/null 2>&1; then
  require_json_value "puts data['npmGlobal'].join(' ')" | xargs npm install -g
else
  echo "npm is not available yet. Open a new terminal and run npm install -g for the packages in config/tools.json."
fi

step "Manual login commands"
require_json_value "puts data['postInstall']" | sed 's/^/  /'

printf "\nDone. Restart the terminal if newly installed commands are not found.\n"
