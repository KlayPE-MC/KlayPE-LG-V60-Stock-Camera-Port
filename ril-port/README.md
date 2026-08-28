# LG V60 RIL signal-strength bridge

This optional port fixes the status-bar cellular signal indicator on `timelm`
without changing modem calibration, transmit power, registration or data
behaviour. It replaces the stock Qualcomm radio service entry point with LG's
HIDL bridge and translates LG's proprietary `LgeSignalStrength` callbacks into
the standard Android `radio@1.4::SignalStrength` structure.

The tested base is LineageOS `android_hardware_lge` commit
`ee5f30995bc1c024d5d75786bc802e86e2fc41a6`. The patch also makes the bridge
delegate the Android 1.5 requests used by the SM8250 vendor radio. Applying only
the product-package line to an older 1.4 wrapper is not sufficient and can
break radio functions.

## Integration

From the Android source root, with this repository checked out as
`device/lge/timelm`:

```bash
device/lge/timelm/ril-port/scripts/prepare-ril-port.sh
```

Then add this line to the product/device makefile if it is not already present:

```makefile
$(call inherit-product, $(LOCAL_PATH)/ril-port/ril.mk)
```

Run the preparation script again after updating or resetting `hardware/lge`.
It safely detects an already-applied patch.

## What the patch does

- registers an Android 1.5 radio instance for every configured SIM slot;
- obtains and delegates the vendor 1.5 radio implementation per SIM slot;
- forwards normal 1.0–1.5 requests and responses instead of replacing modem
  logic;
- converts both LG solicited and unsolicited signal-strength structures to the
  standard 1.4 callback consumed by Android telephony;
- keeps the service name `android.hardware.radio@1.4-service.lge` because that
  is the existing LineageOS module name, despite its new 1.5 delegation.

No `CellSignalStrengthLte.java` fallback is required. Hard-coding a fixed
number of bars hides real coverage changes and is deliberately excluded.

## Verification

After building, boot the ROM and run:

```bash
device/lge/timelm/ril-port/scripts/verify-ril-device.sh
```

Also test calls, SMS, mobile data, airplane mode, SIM disable/enable, network
mode changes and every physical SIM slot. The displayed bars should change
with real LTE/NR measurements rather than remaining pinned to one level.

If `logcat` repeatedly reports `sendLgeSignalStrength ind or msg is NULL`,
confirm that the LG service is running, owns every configured slot and that no
second Qualcomm radio service is competing for the same HIDL instance.
