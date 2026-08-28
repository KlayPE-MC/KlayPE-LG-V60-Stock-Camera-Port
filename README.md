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
- the pinned, coherent V40G camera HAL/LG statistics/tuning override set;
- the required Android camera-service compatibility patch;
- APK reconstruction patches, one-command preparation, verification scripts
  and a regression matrix.

This repository intentionally contains **camera work only**. It does not
contain the experimental RIL/signal-strength wrapper, UDFPS changes, GApps or
root integration.

## Known working reference

The reference build is LineageOS 23.2 (`BP4A`, Android 16). The tested camera
APK has this SHA-256:

```text
011c0956961dea6dc29e79923ea8461d4b1c5f3c5dee64b949b47c32c4e87245
```

Testing reached rear/front photography, flash, lens selection, normal video,
8K, stabilization, timelapse, manual video and portrait. The bundled camera
also forces a real 60/60 capture range when 1080p60 or 4K60 is selected; the
previous 24/60 range could produce 24-30 fps files in low light. Continuous
autofocus at 60 fps remains under investigation. This remains an engineering
port; run `porting/TEST_MATRIX.md` on every ROM branch and update.

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

## Pin the tested vendor camera set

After syncing or extracting `vendor/lge/timelm`, install the six coherent
camera files captured from the tested V40G configuration:

```bash
device/lge/timelm/porting/scripts/apply-stable-camera-vendor-overrides.sh \
  vendor/lge/timelm
```

The script verifies every bundled file, saves the original vendor files below
`out/klaype-camera-vendor-backup/original`, installs the stable set at the
paths already consumed by the normal vendor makefiles, and verifies the result.
Run it again after replacing or re-extracting the vendor tree.

This avoids duplicate Soong modules and pins `camera.kona.so`, the matching
LG AEC/AF/AWB components and the `s5kgw1` tuning file without importing the
whole vendor repository. Do not substitute the similarly named
`com.qti.stats.*` files for the four `com.lge.stats.*` files in the manifest.

Keep the supplied `vendor.camera.aux.packagelist` unchanged. In particular,
do not add `com.lge.camera`: this LG HAL then exposes auxiliary IDs that make
the application derive and query nonexistent camera ID 10.

## One-command preparation

After cloning this tree and syncing `vendor/lge/timelm`, run from the Android
source root:

```bash
device/lge/timelm/porting/scripts/prepare-camera-port.sh
```

The script verifies all required artifacts, installs the exact V40G vendor
override set with backups, applies the required `frameworks/av` patch only
when necessary, and verifies the prepared tree. It stops on a missing file,
wrong hash or incompatible platform patch instead of allowing a broken ROM
build to continue.

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

## Troubleshooting known integration failures

- **Black preview or buttons that do nothing:** run
  `porting/scripts/prepare-camera-port.sh` again after every proprietary-file
  extraction. This normally means that the APK, `camera.kona.so`, Feature2
  tuning or LG AEC/AF/AWB components came from different firmware sets.
- **Logcat refers to camera ID 10:** restore the exact
  `vendor.camera.aux.packagelist` shipped in `system_ext.prop`. LG Camera must
  not be added to that allow-list; it expects `getCameraIdList()` to expose
  only the public IDs and opens its logical cameras explicitly.
- **The UI says 60 fps but the recording is 24–30 fps:** confirm that the APK
  hash passes `verify-camera-tree.sh`, then measure the output with `ffprobe`
  as described in `porting/TEST_MATRIX.md`. Older APK revisions requested a
  variable 24–60 range instead of fixed 60/60.
- **The build succeeds but runtime behaviour is unchanged:** remove stale
  product output for the camera packages, rerun the preparation script and
  rebuild. Soong accepting the modules does not prove that the coherent
  vendor override set reached the generated vendor image.

Continuous autofocus while recording at 60 fps is not claimed as fixed by
this release. The repository intentionally reports this remaining limitation
instead of presenting the port as fully complete.

## Optional cellular signal indicator fix

The tested LG RIL bridge is now published separately under [`ril-port`](ril-port/README.md).
It translates the proprietary LG signal-strength callbacks to standard Android
telephony while delegating the vendor radio through HIDL 1.5. It is optional
and does not need to be enabled for the camera port.

## Attribution and third-party files

Integration, compatibility code, documentation and patches are published by
KlayPE for LG V60 ROM development. LG applications and proprietary binaries
remain the property of their respective copyright holders. See `NOTICE.md`.
