# Port milestones

## Reproducible developer kit

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
