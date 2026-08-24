# KlayPE LG V60 stock camera port

Device tree and reproducible integration kit for running the stock LG Camera
on Android 16 / LineageOS 23.2 for the LG V60 ThinQ (`timelm`). The camera
artifacts are based on the stable `LMV600EA V40G` firmware.

Maintained and tested by **KlayPE** (`KlayPE-MC`).

## What is included

- the complete LineageOS `device/lge/timelm` tree at base commit
  `21d4520b4dc69025b46baa6eeead3249b4f5e6a6`;
- the patched LG Camera and LG CameraSolution applications;
- LG framework/resource compatibility classes and permissions;
- the CameraSolution, ArcSoft, Morpho, CVP, SNPE and OpenCL libraries;
- matching V40G Feature2 libraries, IQM models and film data;
- the required Android camera-service compatibility patch;
- APK reconstruction patches, verification scripts and a regression matrix.

This repository intentionally contains **camera work only**. It does not
contain the experimental RIL/signal-strength wrapper, UDFPS changes, GApps or
root integration.

## Known working reference

The reference build is LineageOS 23.2 (`BP4A`, Android 16). The tested camera
APK has this SHA-256:

```text
4f9ac1b8edde0f469524f8efc7bfa8f1258634b26ac6ef385be32a37a7f83f60
```

Testing reached rear/front photography, flash, lens selection, normal video,
8K, stabilization, timelapse, manual video and portrait. This remains an
engineering port; run `porting/TEST_MATRIX.md` on every ROM branch and update.

## Clone

Git LFS is required because the ready-to-build tree includes the proprietary
camera artifacts:

```bash
git lfs install
rm -rf device/lge/timelm
git clone https://github.com/KlayPE-MC/KlayPE-LG-V60-Stock-Camera-Port \
  device/lge/timelm
git -C device/lge/timelm lfs pull
```

Use the normal Lineage `vendor/lge/timelm` repository or extraction workflow
for the base V60 vendor blobs. The additional files unique to this camera port
are already under `camera-lg/prebuilt`.

## Required platform patch

From the Android source root:

```bash
git -C frameworks/av apply --check \
  ../../device/lge/timelm/porting/patches/frameworks-av/0001-camera3-support-legacy-lg-opaque-output-usage.patch
git -C frameworks/av apply \
  ../../device/lge/timelm/porting/patches/frameworks-av/0001-camera3-support-legacy-lg-opaque-output-usage.patch
```

The patch was produced against LineageOS `frameworks/av` commit
`d92cfd6a292548b40b570476dda13e6c4412e1f2`. It supplies the missing camera
writer usage for opaque streams returned by the legacy LG/Qualcomm HAL. Without
it, advanced modes may open with a black preview or non-working controls.

## Build

```bash
source build/envsetup.sh
lunch lineage_timelm-bp4a-userdebug

# Fast integration check before a full ROM build
m LGCameraAppPort LGCameraSolutionPort com.lge.camerasolution

# Full build
m bacon
```

The three imported applications are platform-signed by Soong. Installing the
APKs later as ordinary applications is not equivalent to building this tree.

## Validation

Before building:

```bash
device/lge/timelm/porting/scripts/verify-camera-tree.sh
```

With a booted userdebug build and ADB connected:

```bash
device/lge/timelm/porting/scripts/verify-device.sh
```

Then complete `porting/TEST_MATRIX.md`, including a clean boot and a reboot.

## Porting to another AOSP ROM

Keep the `camera-lg` directory and the camera blocks in `BoardConfig.mk`,
`device.mk` and `system_ext.prop`. Adapt only product naming and ROM-specific
inheritance. Apply the `frameworks/av` patch to that ROM's matching camera
service; if the context changed, port the same guarded
`GRALLOC_USAGE_HW_CAMERA_WRITE` logic rather than applying it blindly.

Do not mix Feature2 graphs or tuning files from another LG firmware release.
That previously caused rejected capture requests (`ENOSYS -38`), black preview
and inert controls.

## Attribution and third-party files

Integration, compatibility code, documentation and patches are published by
KlayPE for LG V60 ROM development. LG applications and proprietary binaries
remain the property of their respective copyright holders. See `NOTICE.md`.

