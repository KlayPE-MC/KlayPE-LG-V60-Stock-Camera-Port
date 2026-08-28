# Port milestones

## 2026-08-28 reproducibility update

- Replaced the older mixed vendor override set with the exact coherent V40G
  `camera.kona`, LG AEC/AF/AWB and `s5kgw1` tuning files tested on-device.
- Added the final LG Camera APK with fixed 60/60 capture ranges for 1080p60
  and 4K60. Measured output now reaches real 60 fps instead of dropping to
  roughly 24-30 fps in low light.
- Added deterministic reconstruction patch `0004` and a one-command tree
  preparation script.
- Corrected the auxiliary-camera allowlist so LG Camera sees only public IDs
  0/1 instead of deriving the nonexistent ID 10.
- Documented the remaining 60 fps continuous-autofocus limitation explicitly.

## Reproducible developer kit

- Bundled the six-file stable vendor camera override set from the working
  2026-08-23 reference ROM, with automatic backup, installation and hash
  verification against a normal `vendor/lge/timelm` tree.
- Published the complete LineageOS 23.2 `timelm` device tree on the exact
  working base revision.
- Added the required `frameworks/av` opaque-output usage patch; the earlier
  private kit did not contain this platform-side requirement.
- Added the LG auxiliary-camera package allowlist in `system_ext.prop`.
- Added ready-to-build proprietary artifacts through Git LFS and a complete
  SHA-256 manifest.
- Isolated the camera work from GApps, UDFPS and radio experiments.
- Captured the exact working `camera-lg` Soong integration tree.
- Converted accumulated LG Camera changes into two verified smali patches.
- Converted LG CameraSolution changes into a verified smali patch.
- Added deterministic V40G input hash checks and Linux reconstruction scripts.
- Added a device-tree-only patch and a regression test matrix.

## Functional milestones reached during device testing

- Eliminated startup crashes caused by absent LG framework APIs/resources.
- Restored preview and capture after supplying matching V40G Feature2 graphs.
- Added IQM models and LG film data required by advanced processing paths.
- Restored rear/front photography, flash, lens selection and gallery handoff.
- Restored video paths including 8K on the tested configuration.
- Restored stabilization and timelapse paths.
- Repaired manual-video resolution control grouping and audio startup.
- Repaired portrait mode camera mapping.
- Added boot-safe handling following the slow-motion crash investigation.
