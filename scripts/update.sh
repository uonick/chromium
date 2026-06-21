#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
TEMPLATE="$ROOT/index.template.html"
OUTPUT_DIR="$ROOT/site"
OUTPUT="$OUTPUT_DIR/index.html"
BASE="https://commondatastorage.googleapis.com/chromium-browser-snapshots"

fetch() {
  local platform="$1" file="$2"
  local revision
  revision=$(curl -fsSL "${BASE}/${platform}/LAST_CHANGE")
  echo "${revision}|${BASE}/${platform}/${revision}/${file}|${BASE}/index.html?prefix=${platform}/"
}

MAC_INTEL=$(fetch Mac chrome-mac.zip)
MAC_ARM=$(fetch Mac_Arm chrome-mac.zip)
WIN_X64=$(fetch Win_x64 chrome-win.zip)
UPDATED=$(date -u +"%Y-%m-%d %H:%M UTC")

IFS='|' read -r MAC_INTEL_REV MAC_INTEL_URL MAC_INTEL_SNAP <<< "$MAC_INTEL"
IFS='|' read -r MAC_ARM_REV MAC_ARM_URL MAC_ARM_SNAP <<< "$MAC_ARM"
IFS='|' read -r WIN_X64_REV WIN_X64_URL WIN_X64_SNAP <<< "$WIN_X64"

mkdir -p "$OUTPUT_DIR"
sed \
  -e "s|{{MAC_INTEL_REVISION}}|${MAC_INTEL_REV}|g" \
  -e "s|{{MAC_INTEL_URL}}|${MAC_INTEL_URL}|g" \
  -e "s|{{MAC_INTEL_SNAPSHOTS}}|${MAC_INTEL_SNAP}|g" \
  -e "s|{{MAC_ARM_REVISION}}|${MAC_ARM_REV}|g" \
  -e "s|{{MAC_ARM_URL}}|${MAC_ARM_URL}|g" \
  -e "s|{{MAC_ARM_SNAPSHOTS}}|${MAC_ARM_SNAP}|g" \
  -e "s|{{WIN_X64_REVISION}}|${WIN_X64_REV}|g" \
  -e "s|{{WIN_X64_URL}}|${WIN_X64_URL}|g" \
  -e "s|{{WIN_X64_SNAPSHOTS}}|${WIN_X64_SNAP}|g" \
  -e "s|{{UPDATED}}|${UPDATED}|g" \
  "$TEMPLATE" > "$OUTPUT"

echo "Updated site/index.html"
echo "  Mac Intel:  ${MAC_INTEL_REV}"
echo "  Mac Silicon: ${MAC_ARM_REV}"
echo "  Windows x64: ${WIN_X64_REV}"
