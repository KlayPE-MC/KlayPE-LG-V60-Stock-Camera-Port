#!/usr/bin/env bash
set -euo pipefail

if [[ $# -ne 2 ]]; then
  echo "Usage: $0 STOCK_LGCameraApp.apk OUTPUT_UNSIGNED.apk" >&2
  exit 2
fi

stock_apk=$(realpath "$1")
output_apk=$(realpath -m "$2")
script_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
kit_dir=$(cd -- "$script_dir/.." && pwd)
expected=6fe8ce16be7ca7de214e99e26ad67d7fe4a0309ae87659133f9a337360c95d95
actual=$(sha256sum "$stock_apk" | awk '{print $1}')

if [[ "$actual" != "$expected" ]]; then
  echo "Unsupported LGCameraApp input: $actual" >&2
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

for tool in git zip sha256sum; do
  command -v "$tool" >/dev/null || { echo "Missing tool: $tool" >&2; exit 1; }
done

work_dir=$(mktemp -d)
trap 'rm -rf "$work_dir"' EXIT

"${apktool[@]}" d -f -r -o "$work_dir/decoded" "$stock_apk"
git -C "$work_dir/decoded" apply -p3 \
  "$kit_dir/apk-patches/0001-lgcamera-classes1-android16-compat.patch"
git -C "$work_dir/decoded" apply -p3 \
  "$kit_dir/apk-patches/0002-lgcamera-classes2-modes-and-compat.patch"
"${apktool[@]}" b "$work_dir/decoded" -o "$work_dir/LGCameraApp-unsigned.apk"

cp "$work_dir/LGCameraApp-unsigned.apk" "$output_apk"
cp "$kit_dir/apk-patches/AndroidManifest.port.bin" "$work_dir/AndroidManifest.xml"
cp "$kit_dir/apk-patches/classes3-compat.dex" "$work_dir/classes3.dex"

# Remove any copied stock signature, then install the tested manifest and
# compatibility dex as root ZIP entries.
zip -qd "$output_apk" 'META-INF/*' 2>/dev/null || true
(cd "$work_dir" && zip -q "$output_apk" AndroidManifest.xml classes3.dex)

echo "Created unsigned camera APK: $output_apk"
sha256sum "$output_apk"
