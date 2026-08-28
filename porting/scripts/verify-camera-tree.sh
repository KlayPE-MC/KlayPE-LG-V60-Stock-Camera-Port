#!/usr/bin/env bash
set -euo pipefail

TREE="${1:-device/lge/timelm}"
TREE=$(realpath "$TREE")

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
  "$TREE/camera-lg/prebuilt/vendor-overrides/vendor/lib64/hw/camera.kona.so"
  "$TREE/camera-lg/prebuilt/vendor-overrides/vendor/lib64/camera/com.qti.tuned.s5kgw1.bin"
  "$TREE/camera-lg/prebuilt/vendor-overrides/vendor/lib64/camera/components/com.lge.stats.aec.so"
  "$TREE/camera-lg/prebuilt/vendor-overrides/vendor/lib64/camera/components/com.lge.stats.aecwrapper.so"
  "$TREE/camera-lg/prebuilt/vendor-overrides/vendor/lib64/camera/components/com.lge.stats.af.so"
  "$TREE/camera-lg/prebuilt/vendor-overrides/vendor/lib64/camera/components/com.lge.stats.awb.so"
  "$TREE/porting/patches/frameworks-av/0001-camera3-support-legacy-lg-opaque-output-usage.patch"
  "$TREE/porting/STABLE_VENDOR_CAMERA_SHA256SUMS"
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

expected_camera_hash=011c0956961dea6dc29e79923ea8461d4b1c5f3c5dee64b949b47c32c4e87245
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

if ! grep -q '^vendor.camera.aux.packagelist=org.codeaurora.snapcam,com.android.camera$' \
    "$TREE/system_ext.prop"; then
  printf 'INVALID auxiliary-camera allowlist in %s/system_ext.prop\n' "$TREE" >&2
  printf 'LGCamera must see only public IDs; use the tested snapcam/AOSP list.\n' >&2
  failed=1
fi

if ! (cd "$TREE/camera-lg/prebuilt/vendor-overrides" && \
      sha256sum -c "$TREE/porting/STABLE_VENDOR_CAMERA_SHA256SUMS"); then
  printf 'HASH MISMATCH in stable vendor camera override set\n' >&2
  failed=1
fi

exit "$failed"
