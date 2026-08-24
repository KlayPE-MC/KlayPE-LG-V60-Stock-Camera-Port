# Regression checklist

Run after a clean flash and again after one reboot. Capture `logcat`,
`dumpsys media.camera` and tombstones for any failure.

| Area | Required checks |
|---|---|
| Startup | Cold start, warm start, start after reboot, start from lock screen |
| Rear photo | Main, ultrawide, flash, HDR, lens switching, gallery thumbnail |
| Front photo | Normal photo, portrait/beauty controls, gallery thumbnail |
| Video | 1080p30, 1080p60, 4K30, 4K60, 8K where exposed |
| Stabilization | Main and ultrawide, supported resolutions, walking sample |
| LG modes | Timelapse, slow motion, manual video, portrait, CineShot if exposed |
| Audio | Speech versus ambient noise, orientation changes, front/rear recording |
| Lifecycle | Background/foreground, screen lock, incoming call, repeated mode changes |
| Storage | Internal storage, low-space error, delete/open from gallery |

Known engineering cautions:

- Do not infer lens identity only from the displayed zoom label; verify camera
  ID and field of view.
- A mode opening is not sufficient. Start/stop recording and play the result.
- A black preview with working process usually points to missing/mismatched
  Feature2 libraries or IQM data.
- A camera process that no longer starts after one mode crashes requires a
  tombstone check before changing the APK.

