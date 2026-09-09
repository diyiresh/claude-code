#!/usr/bin/env bash
# Idempotent Cloud Agent bootstrap for the claude-code (Bun) CLI.
# Installs the Bun runtime if missing, then installs project dependencies.
set -euo pipefail

export BUN_INSTALL="${BUN_INSTALL:-$HOME/.bun}"
export PATH="$BUN_INSTALL/bin:$PATH"

if ! command -v bun >/dev/null 2>&1; then
  echo "[install] Bun not found — installing…"
  curl -fsSL https://bun.sh/install | bash
fi

# Persist Bun on PATH for future non-login shells (terminals, start, etc.).
if ! grep -q 'BUN_INSTALL' "$HOME/.bashrc" 2>/dev/null; then
  {
    echo 'export BUN_INSTALL="$HOME/.bun"'
    echo 'export PATH="$BUN_INSTALL/bin:$PATH"'
  } >> "$HOME/.bashrc"
fi

echo "[install] Using $(bun --version) via $(command -v bun)"

# Install workspace dependencies against the committed lockfile.
# postinstall downloads the vendored ripgrep binary (non-fatal on failure).
bun install --frozen-lockfile

echo "[install] Dependencies installed."
