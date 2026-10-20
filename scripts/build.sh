#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
BUILD_DIR="${NIVORA_BUILD_DIR:-$ROOT_DIR/.build/live}"
DIST_DIR="$ROOT_DIR/dist"
PROFILE_DIR="$ROOT_DIR/live-build"
VERSION="$(tr -d '[:space:]' < "$ROOT_DIR/VERSION")"

if [[ "${EUID}" -ne 0 ]]; then
  echo "Nivora ISO builds require root. Run: sudo ./scripts/build.sh" >&2
  exit 1
fi

for command in lb xorriso; do
  if ! command -v "$command" >/dev/null 2>&1; then
    echo "Missing required command: $command" >&2
    exit 1
  fi
done

rm -rf "$BUILD_DIR"
mkdir -p "$BUILD_DIR" "$DIST_DIR"
cp -a "$PROFILE_DIR/." "$BUILD_DIR/"

cd "$BUILD_DIR"

lb config \
  --mode debian \
  --distribution trixie \
  --architectures amd64 \
  --binary-images iso-hybrid \
  --archive-areas "main contrib non-free-firmware" \
  --debian-installer none \
  --apt-recommends true \
  --bootappend-live "boot=live components quiet splash username=nivora hostname=nivora" \
  --iso-application "Nivora OS" \
  --iso-publisher "Nivora OS Project" \
  --iso-volume "NIVORA_01"

lb build

ISO_PATH="$(find "$BUILD_DIR" -maxdepth 1 -type f \( -name '*.hybrid.iso' -o -name '*.iso' \) | head -n 1)"
if [[ -z "$ISO_PATH" ]]; then
  echo "Build completed but no ISO was found." >&2
  exit 1
fi

OUTPUT="$DIST_DIR/nivora-os-$VERSION-amd64.iso"
cp "$ISO_PATH" "$OUTPUT"
sha256sum "$OUTPUT" > "$OUTPUT.sha256"

echo
echo "Nivora ISO ready:"
echo "  $OUTPUT"
echo "  $OUTPUT.sha256"
