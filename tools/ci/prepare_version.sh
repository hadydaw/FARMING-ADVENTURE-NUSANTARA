#!/usr/bin/env bash
# Menentukan versi/paket APK dan menuliskannya ke export_presets.cfg.
# Pemakaian: prepare_version.sh <ref_name> <run_number> <is_release:true|false>
set -euo pipefail

REF_NAME="$1"; RUN_NUMBER="$2"; IS_RELEASE="$3"
PRESETS="export_presets.cfg"
BASE_PACKAGE="com.hadydaw.farmingadventurenusantara"
PROJECT_VERSION="$(sed -n 's/^config\/version="\(.*\)"/\1/p' project.godot)"
[[ -n "$PROJECT_VERSION" ]] || { echo "::error::config/version tidak ditemukan di project.godot"; exit 1; }

if [[ "$IS_RELEASE" == "true" ]]; then
  TAG_VERSION="${REF_NAME#v}"
  if [[ ! "$TAG_VERSION" =~ ^([0-9]+)\.([0-9]+)\.([0-9]+)$ ]]; then
    echo "::error::Tag '$REF_NAME' harus berformat vMAJOR.MINOR.PATCH"; exit 1
  fi
  if [[ "$TAG_VERSION" != "$PROJECT_VERSION" ]]; then
    echo "::error::Tag $REF_NAME tidak sama dengan config/version project.godot ($PROJECT_VERSION)"; exit 1
  fi
  VERSION_NAME="$TAG_VERSION"
  VERSION_CODE=$(( BASH_REMATCH[1] * 1000000 + BASH_REMATCH[2] * 1000 + BASH_REMATCH[3] ))
  PACKAGE="$BASE_PACKAGE"
  APP_NAME="Farming Adventure Nusantara"
  APK_NAME="FarmingAdventureNusantara-v${VERSION_NAME}.apk"
else
  VERSION_NAME="${PROJECT_VERSION}-dev.${RUN_NUMBER}"
  VERSION_CODE="$RUN_NUMBER"
  PACKAGE="${BASE_PACKAGE}.dev"   # paket terpisah supaya tidak bentrok dengan rilis
  APP_NAME="FAN Dev"
  APK_NAME="FarmingAdventureNusantara-dev-${RUN_NUMBER}.apk"
fi

sed -i \
  -e "s|^version/code=.*|version/code=${VERSION_CODE}|" \
  -e "s|^version/name=.*|version/name=\"${VERSION_NAME}\"|" \
  -e "s|^package/unique_name=.*|package/unique_name=\"${PACKAGE}\"|" \
  -e "s|^package/name=.*|package/name=\"${APP_NAME}\"|" \
  "$PRESETS"

echo "Versi: ${VERSION_NAME} (code ${VERSION_CODE}), paket ${PACKAGE}, berkas ${APK_NAME}"
if [[ -n "${GITHUB_OUTPUT:-}" ]]; then
  {
    echo "version_name=${VERSION_NAME}"
    echo "version_code=${VERSION_CODE}"
    echo "package_name=${PACKAGE}"
    echo "apk_name=${APK_NAME}"
  } >> "$GITHUB_OUTPUT"
fi
