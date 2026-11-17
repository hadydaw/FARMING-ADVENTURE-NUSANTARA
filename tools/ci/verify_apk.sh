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

# Rilis TIDAK boleh bertanda tangan kunci dev publik.
if [[ "${IS_RELEASE:-false}" == "true" ]]; then
  dev_sha="$(keytool -list -keystore tools/keystore/dev.keystore -storepass android -alias fan-dev \
    | grep -i 'fingerprint' | sed 's/.*: //' | tr -d ':' | tr 'A-F' 'a-f' | head -1)"
  apk_sha="$("$BT/apksigner" verify --print-certs "$APK" | grep 'SHA-256 digest' | head -1 | sed 's/.*: //' | tr -d ':' | tr 'A-F' 'a-f')"
  [[ -n "$dev_sha" && -n "$apk_sha" ]] || { echo "::error::Tidak bisa membaca sidik jari tanda tangan"; exit 1; }
  if [[ "$dev_sha" == "$apk_sha" ]]; then
    echo "::error::APK rilis bertanda tangan kunci DEV. Dibatalkan."; exit 1
  fi
  echo "Tanda tangan rilis berbeda dari kunci dev: OK"
fi
