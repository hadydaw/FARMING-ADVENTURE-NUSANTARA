#!/usr/bin/env bash
# Menulis editor settings Godot agar tahu lokasi Android SDK dan JDK.
set -euo pipefail

: "${ANDROID_HOME:?ANDROID_HOME belum diatur (pasang Android SDK dulu)}"
JAVA_PATH="${JAVA_HOME:-$(dirname "$(dirname "$(readlink -f "$(command -v javac)")")")}"
MINOR="$(godot --version | cut -d. -f1,2)"   # contoh: 4.7
dir="${XDG_CONFIG_HOME:-$HOME/.config}/godot"
mkdir -p "$dir"

cat > "$dir/editor_settings-${MINOR}.tres" <<SETTINGS
[gd_resource type="EditorSettings" format=3]

[resource]
export/android/android_sdk_path = "${ANDROID_HOME}"
export/android/java_sdk_path = "${JAVA_PATH}"
export/android/shutdown_adb_on_exit = true
SETTINGS
echo "Editor settings ditulis: $dir/editor_settings-${MINOR}.tres"
