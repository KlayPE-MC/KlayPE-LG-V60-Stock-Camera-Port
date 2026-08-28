#!/usr/bin/env bash
set -euo pipefail

script_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
device_tree=$(cd -- "$script_dir/../.." && pwd)
android_root=${ANDROID_BUILD_TOP:-$(pwd)}
vendor_tree=${1:-$android_root/vendor/lge/timelm}
frameworks_av=$android_root/frameworks/av
platform_patch=$device_tree/porting/patches/frameworks-av/0001-camera3-support-legacy-lg-opaque-output-usage.patch

[[ -d "$frameworks_av/.git" ]] || {
  echo "Run this script from the Android source root or export ANDROID_BUILD_TOP." >&2
  exit 1
}

"$script_dir/verify-camera-tree.sh" "$device_tree"
"$script_dir/apply-stable-camera-vendor-overrides.sh" "$vendor_tree"

if git -C "$frameworks_av" apply --reverse --check "$platform_patch" 2>/dev/null; then
  echo "frameworks/av camera compatibility patch is already applied"
elif git -C "$frameworks_av" apply --check "$platform_patch"; then
  git -C "$frameworks_av" apply "$platform_patch"
  echo "Applied frameworks/av camera compatibility patch"
else
  echo "The frameworks/av patch does not apply to this branch." >&2
  echo "Port its guarded GRALLOC_USAGE_HW_CAMERA_WRITE change manually." >&2
  exit 1
fi

"$script_dir/verify-camera-tree.sh" "$device_tree"
echo "LG V60 stock camera integration is ready for compilation."
