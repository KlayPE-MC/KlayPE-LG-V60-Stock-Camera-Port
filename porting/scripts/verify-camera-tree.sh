#!/usr/bin/env bash
set -euo pipefail

TREE="${1:-device/lge/timelm}"

required=(
  "$TREE/camera-lg/Android.bp"
  "$TREE/camera-lg/prebuilt/LGCameraApp.apk"
  "$TREE/camera-lg/prebuilt/LGCameraSolution.apk"
  "$TREE/camera-lg/prebuilt/lge-res.apk"
  "$TREE/camera-lg/prebuilt/com.lge.camerasolution.jar"
  "$TREE/camera-lg/prebuilt/lib64/libLGCameraSolution-jni.so"
  "$TREE/camera-lg/prebuilt/vendor/lib64/com.lge.feature2.swmf.so"
  "$TREE/camera-lg/prebuilt/vendor/lib64/com.qti.feature2.hdr.so"
  "$TREE/camera-lg/prebuilt/vendor/etc/camera/iqm/ai_checker_graph.dlc"
  "$TREE/camera-lg/prebuilt/vendor/etc/camera/film/0_film.dat"
  "$TREE/porting/patches/frameworks-av/0001-camera3-support-legacy-lg-opaque-output-usage.patch"
)

failed=0
for file in "${required[@]}"; do
  if [[ -s "$file" ]]; then
    printf 'OK      %s\n' "$file"
  else
    printf 'MISSING %s\n' "$file" >&2
    failed=1
  fi
done

expected_camera_hash=4f9ac1b8edde0f469524f8efc7bfa8f1258634b26ac6ef385be32a37a7f83f60
actual_camera_hash=$(sha256sum "$TREE/camera-lg/prebuilt/LGCameraApp.apk" | cut -d' ' -f1)
if [[ "$actual_camera_hash" != "$expected_camera_hash" ]]; then
  printf 'HASH MISMATCH LGCameraApp.apk\nexpected %s\nactual   %s\n' \
    "$expected_camera_hash" "$actual_camera_hash" >&2
  failed=1
else
  printf 'OK      LGCameraApp.apk SHA-256\n'
fi

if ! grep -q 'LGCameraAppPort' "$TREE/device.mk"; then
  printf 'MISSING camera product integration in %s/device.mk\n' "$TREE" >&2
  failed=1
fi

if ! grep -q 'com.lge.camera' "$TREE/system_ext.prop"; then
  printf 'MISSING LG auxiliary-camera allowlist in %s/system_ext.prop\n' "$TREE" >&2
  failed=1
fi

exit "$failed"

