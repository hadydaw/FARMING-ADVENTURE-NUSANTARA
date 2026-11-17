#!/usr/bin/env bash
# Memasang Godot (headless editor) dan, opsional, export template Android.
# Pemakaian: tools/ci/install_godot.sh [--with-templates]
set -euo pipefail

VERSION="${GODOT_VERSION:-4.7.2}"
CHANNEL="${GODOT_CHANNEL:-stable}"
TAG="${VERSION}-${CHANNEL}"
BASE="https://github.com/godotengine/godot/releases/download/${TAG}"
WORK="${RUNNER_TEMP:-/tmp}/godot-install"
BIN_NAME="Godot_v${TAG}_linux.x86_64"
TPZ_NAME="Godot_v${TAG}_export_templates.tpz"

mkdir -p "$WORK" && cd "$WORK"
curl -fsSL --retry 3 -O "${BASE}/SHA512-SUMS.txt"

fetch_verified() {
  local file="$1"
  curl -fsSL --retry 3 -O "${BASE}/${file}"
  grep " ${file}\$" SHA512-SUMS.txt | sha512sum -c -
}

fetch_verified "${BIN_NAME}.zip"
unzip -oq "${BIN_NAME}.zip"
sudo install -m 0755 "${BIN_NAME}" /usr/local/bin/godot
godot --version

if [[ "${1:-}" == "--with-templates" ]]; then
  fetch_verified "${TPZ_NAME}"
  dest="${HOME}/.local/share/godot/export_templates/${VERSION}.${CHANNEL}"
  mkdir -p "$dest"
  # Ambil hanya template Android + version.txt (tpz berisi semua platform, sangat besar).
  unzip -oj "${TPZ_NAME}" "templates/android_*" "templates/version.txt" -d "$dest"
  ls -la "$dest"
fi
