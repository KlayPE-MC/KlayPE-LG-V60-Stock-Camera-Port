package com.lge.display;

import android.content.Context;

public class DisplayManagerHelper {
    public static class CoverDisplayCallback { public void onStateChanged(int state) { } }
    public static class SmartCoverCallback { public void onStateChanged(int state) { } }
    public static class SwivelStateCallback { public void onStateChanged(int state) { } }
    public DisplayManagerHelper(Context context) { }
    public static int getMultiDisplayType() { return 0; }
    public static boolean isMultiDisplayDevice() { return false; }
    public int getCoverDisplayState() { return 0; }
    public int getCoverState() { return 0; }
    public int getSwivelState() { return 1; }
    public void registerSwivelStateCallback(SwivelStateCallback callback) { }
    public void unregisterSwivelStateCallback(SwivelStateCallback callback) { }
}
