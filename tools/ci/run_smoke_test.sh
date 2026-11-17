#!/usr/bin/env bash
# Menjalankan smoke test + memuat scene utama beberapa frame. Gagal bila ada error skrip.
set -uo pipefail

fail=0
run() {
  local label="$1"; shift
  echo "=== ${label}"
  local out; out="$(mktemp)"
  timeout 180 "$@" 2>&1 | tee "$out"
  local code="${PIPESTATUS[0]}"
  if (( code != 0 )) || grep -Eq "SCRIPT ERROR|Parse Error|Failed to load|Failed to instantiate" "$out"; then
    echo "::error::${label} gagal (exit ${code})"
    fail=1
  fi
}

run "Smoke test"        godot --headless --path . --script res://tools/ci/smoke_test.gd
run "Scene utama 90 frame" godot --headless --path . --quit-after 90
exit $fail
