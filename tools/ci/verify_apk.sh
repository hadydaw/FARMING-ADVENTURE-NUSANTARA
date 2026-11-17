#!/usr/bin/env bash
# Memeriksa APK hasil build: nama paket, arsitektur, dan tanda tangan.
# Pemakaian: verify_apk.sh <apk> <paket_yang_diharapkan>
set -euo pipefail

APK="$1"; EXPECTED_PACKAGE="$2"
BT="${ANDROID_HOME:?}/build-tools/${ANDROID_BUILD_TOOLS:-35.0.1}"

badging="$("$BT/aapt2" dump badging "$APK")"
echo "$badging" | grep -E "^(package|sdkVersion|targetSdkVersion|native-code|launchable-activity)" || true

echo "$badging" | grep -q "package: name='${EXPECTED_PACKAGE}'" \
  || { echo "::error::Nama paket APK tidak sesuai (harap: ${EXPECTED_PACKAGE})"; exit 1; }
echo "$badging" | grep -q "native-code: 'arm64-v8a'" \
  || { echo "::error::APK tidak memuat arm64-v8a"; exit 1; }

"$BT/apksigner" verify --verbose --print-certs "$APK" | head -8
ls -lh "$APK"
