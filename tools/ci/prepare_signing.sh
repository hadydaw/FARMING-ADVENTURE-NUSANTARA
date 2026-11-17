#!/usr/bin/env bash
# Menyiapkan kunci penandatanganan APK dan mengekspor variabel lingkungan Godot.
# Pemakaian: prepare_signing.sh <is_release:true|false>
#  - dev    : memakai tools/keystore/dev.keystore (kunci PUBLIK, hanya untuk build dev).
#  - rilis  : wajib memakai keystore rilis dari GitHub Secrets; gagal bila tidak ada.
# Catatan Godot: password keystore dan password key harus sama.
set -euo pipefail

IS_RELEASE="$1"
: "${GITHUB_ENV:?hanya untuk dijalankan di GitHub Actions}"

if [[ "$IS_RELEASE" == "true" ]]; then
  missing=()
  [[ -n "${RELEASE_KEYSTORE_B64:-}" ]] || missing+=("ANDROID_KEYSTORE_BASE64")
  [[ -n "${RELEASE_KEY_ALIAS:-}" ]]    || missing+=("ANDROID_KEY_ALIAS")
  [[ -n "${RELEASE_KEY_PASSWORD:-}" ]] || missing+=("ANDROID_KEY_PASSWORD")
  if (( ${#missing[@]} > 0 )); then
    echo "::error::Build rilis dibatalkan: GitHub Secrets belum diisi: ${missing[*]}. Lihat docs/technical/BUILD_AND_RELEASE.md bagian 'Kunci rilis'."
    exit 1
  fi
  KEYSTORE="${RUNNER_TEMP}/release.keystore"
  echo "$RELEASE_KEYSTORE_B64" | base64 -d > "$KEYSTORE"
  echo "::add-mask::${RELEASE_KEY_PASSWORD}"
  keytool -list -keystore "$KEYSTORE" -storepass "$RELEASE_KEY_PASSWORD" -alias "$RELEASE_KEY_ALIAS" > /dev/null \
    || { echo "::error::Keystore/alias/password rilis tidak cocok"; rm -f "$KEYSTORE"; exit 1; }
  ALIAS="$RELEASE_KEY_ALIAS"; PASSWORD="$RELEASE_KEY_PASSWORD"
else
  KEYSTORE="$PWD/tools/keystore/dev.keystore"
  ALIAS="fan-dev"; PASSWORD="android"
fi

{
  echo "GODOT_ANDROID_KEYSTORE_RELEASE_PATH=${KEYSTORE}"
  echo "GODOT_ANDROID_KEYSTORE_RELEASE_USER=${ALIAS}"
  echo "GODOT_ANDROID_KEYSTORE_RELEASE_PASSWORD=${PASSWORD}"
  # Godot menanyakan kunci debug juga saat memvalidasi preset; arahkan ke kunci yang sama.
  echo "GODOT_ANDROID_KEYSTORE_DEBUG_PATH=${KEYSTORE}"
  echo "GODOT_ANDROID_KEYSTORE_DEBUG_USER=${ALIAS}"
  echo "GODOT_ANDROID_KEYSTORE_DEBUG_PASSWORD=${PASSWORD}"
} >> "$GITHUB_ENV"
echo "Kunci penandatanganan siap (rilis=${IS_RELEASE})."
