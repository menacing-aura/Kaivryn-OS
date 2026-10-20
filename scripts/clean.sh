#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

if [[ "${EUID}" -ne 0 ]]; then
  echo "Run with sudo: sudo ./scripts/clean.sh" >&2
  exit 1
fi

rm -rf "$ROOT_DIR/.build" "$ROOT_DIR/dist"
echo "Nivora build artifacts removed."
