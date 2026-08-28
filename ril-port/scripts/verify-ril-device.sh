#!/usr/bin/env bash
set -euo pipefail

adb_cmd=(adb)
if ! "${adb_cmd[@]}" get-state >/dev/null 2>&1; then
  echo "No ADB device is connected." >&2
  exit 1
fi

service=$(${adb_cmd[@]} shell getprop init.svc.vendor.radio-1-4-lge | tr -d '\r')
[[ "$service" == "running" ]] || {
  echo "LG radio bridge is not running (state: ${service:-missing})." >&2
  exit 1
}

${adb_cmd[@]} shell lshal 2>/dev/null | grep -q 'android.hardware.radio@1.5::IRadio/slot1' || {
  echo "radio@1.5 slot1 HIDL instance is not registered." >&2
  exit 1
}

echo "PASS: LG radio bridge is running and radio@1.5/slot1 is registered."
echo "Complete the call, SMS, data, airplane-mode and per-slot tests manually."
