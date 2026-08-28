#!/usr/bin/env bash
set -euo pipefail

script_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
device_tree=$(cd -- "$script_dir/../.." && pwd)
android_root=${ANDROID_BUILD_TOP:-$(pwd)}
hardware_lge=${1:-$android_root/hardware/lge}
patch=$device_tree/ril-port/patches/0001-lge-radio-bridge-1.5-and-signal-strength.patch

[[ -d "$hardware_lge/.git" ]] || {
  echo "Run from the Android source root or export ANDROID_BUILD_TOP." >&2
  exit 1
}

if git -C "$hardware_lge" apply --reverse --check "$patch" 2>/dev/null; then
  echo "LG radio bridge patch is already applied."
elif git -C "$hardware_lge" apply --check "$patch"; then
  git -C "$hardware_lge" apply "$patch"
  echo "Applied LG radio 1.5 delegation and signal-strength bridge."
else
  echo "Patch is incompatible with this hardware/lge revision." >&2
  echo "Port the same changes manually; do not force or partially apply it." >&2
  exit 1
fi

if grep -Rqs 'android.hardware.radio@1.4-service.lge' \
    "$device_tree/device.mk" "$device_tree"/*.mk 2>/dev/null; then
  echo "Device product includes the LG radio service."
else
  echo "Add this to the device product makefile:" >&2
  echo '$(call inherit-product, $(LOCAL_PATH)/ril-port/ril.mk)' >&2
  exit 2
fi

echo "RIL bridge source is ready for compilation."

