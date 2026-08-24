#!/usr/bin/env bash
set -euo pipefail

if [[ $# -gt 1 ]]; then
  echo "Usage: $0 [vendor/lge/timelm]" >&2
  exit 2
fi

script_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
device_tree=$(cd -- "$script_dir/../.." && pwd)
source_root="$device_tree/camera-lg/prebuilt/vendor-overrides"
manifest="$device_tree/porting/STABLE_VENDOR_CAMERA_SHA256SUMS"
vendor_tree=$(realpath -m "${1:-vendor/lge/timelm}")
destination_root="$vendor_tree/proprietary"

if [[ ! -d "$destination_root/vendor" ]]; then
  echo "Vendor tree not found: $destination_root/vendor" >&2
  echo "Sync or extract vendor/lge/timelm before applying the camera overrides." >&2
  exit 1
fi

echo "Verifying bundled stable camera files"
(cd "$source_root" && sha256sum -c "$manifest")

if [[ -n "${ANDROID_BUILD_TOP:-}" ]]; then
  backup_root="$ANDROID_BUILD_TOP/out/klaype-camera-vendor-backup/original"
else
  backup_root="$(pwd)/out/klaype-camera-vendor-backup/original"
fi

while read -r expected relative; do
  [[ -n "$expected" && -n "$relative" ]] || continue
  source_file="$source_root/$relative"
  destination_file="$destination_root/$relative"
  backup_file="$backup_root/$relative"

  mkdir -p "$(dirname -- "$destination_file")"
  if [[ -f "$destination_file" && ! -e "$backup_file" ]]; then
    mkdir -p "$(dirname -- "$backup_file")"
    cp -a -- "$destination_file" "$backup_file"
  fi
  install -m 0644 -- "$source_file" "$destination_file"
done < "$manifest"

echo "Verifying installed vendor camera set"
(cd "$destination_root" && sha256sum -c "$manifest")

echo "Stable KlayPE camera vendor overrides installed in: $vendor_tree"
echo "Original files, when present, were preserved in: $backup_root"
