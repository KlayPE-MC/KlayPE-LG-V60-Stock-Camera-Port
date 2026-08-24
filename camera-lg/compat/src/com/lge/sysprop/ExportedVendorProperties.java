package com.lge.sysprop;

import android.os.SystemProperties;
import java.util.Optional;

public final class ExportedVendorProperties {
    private ExportedVendorProperties() { }
    private static Optional<String> value(String key) {
        String value = SystemProperties.get(key, "");
        return value.isEmpty() ? Optional.empty() : Optional.of(value);
    }
    public static Optional<String> build_default_country() { return value("ro.build.default_country"); }
    public static Optional<String> data_front_minfps() { return value("persist.vendor.lge.data.front.minfps"); }
    public static Optional<String> data_rear_minfps() { return value("persist.vendor.lge.data.rear.minfps"); }
    public static Optional<String> dev_fmode() { return value("ro.vendor.lge.dev.fmode"); }
    public static Optional<String> dev_fmode_exif() { return value("ro.vendor.lge.dev.fmode_exif"); }
    public static Optional<String> dev_fmode_exif_atnt() { return value("ro.vendor.lge.dev.fmode_exif_atnt"); }
    public static Optional<String> livedemounit() { return value("persist.vendor.lge.LiveDemoUnit"); }
    public static Optional<String> opensw() { return value("ro.vendor.lge.opensw"); }
}
