#!/usr/bin/env bash
set -euo pipefail

if [[ $# -ne 2 ]]; then
  echo "Usage: $0 STOCK_LGCameraSolution.apk OUTPUT_UNSIGNED.apk" >&2
  exit 2
fi

stock_apk=$(realpath "$1")
output_apk=$(realpath -m "$2")
script_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
kit_dir=$(cd -- "$script_dir/.." && pwd)
expected=6635d309aa5a3ef158b35aa7bfdcb6f61be1a65bb23f2f0691c350d926c98c89
actual=$(sha256sum "$stock_apk" | awk '{print $1}')

if [[ "$actual" != "$expected" ]]; then
  echo "Unsupported LGCameraSolution input: $actual" >&2
  echo "Expected V40G: $expected" >&2
  exit 1
fi

if [[ -n "${APKTOOL_JAR:-}" ]]; then
  java_bin=${JAVA_BIN:-java}
  command -v "$java_bin" >/dev/null || {
    echo "Java not found; set JAVA_BIN to the AOSP JDK java binary" >&2
    exit 1
  }
  apktool=("$java_bin" -jar "$APKTOOL_JAR")
else
  apktool=(apktool)
fi

work_dir=$(mktemp -d)
trap 'rm -rf "$work_dir"' EXIT

"${apktool[@]}" d -f -r -o "$work_dir/decoded" "$stock_apk"
git -C "$work_dir/decoded" apply -p3 \
  "$kit_dir/apk-patches/0003-lgcamerasolution-android16.patch"
"${apktool[@]}" b "$work_dir/decoded" -o "$output_apk"
zip -qd "$output_apk" 'META-INF/*' 2>/dev/null || true

echo "Created unsigned CameraSolution APK: $output_apk"
sha256sum "$output_apk"
