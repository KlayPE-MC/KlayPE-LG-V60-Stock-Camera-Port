package com.lge.os;

import android.os.SystemProperties;

public final class PropertyUtils {
    private static final PropertyUtils INSTANCE = new PropertyUtils();
    private PropertyUtils() { }
    public static PropertyUtils getInstance() { return INSTANCE; }
    public String get(int id, String fallback) { return fallback; }
    public String get(String key, String fallback) { return SystemProperties.get(key, fallback); }
}
