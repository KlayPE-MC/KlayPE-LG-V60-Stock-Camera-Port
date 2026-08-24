package com.lge.app.permission;

import android.content.Context;
import android.graphics.drawable.Drawable;

public class DefaultUiProvider implements GuideUiProvider {
    public Drawable getAppIcon(Context c) { return c.getApplicationInfo().loadIcon(c.getPackageManager()); }
    public CharSequence getAppName(Context c, String[] p) { return c.getApplicationInfo().loadLabel(c.getPackageManager()); }
    public CharSequence getDisabledFeatures(Context c, String[] p) { return ""; }
    public CharSequence getFullMessageForRequestingPermissions(Context c, String[] p) { return ""; }
    public CharSequence getReasonForRequestingPermissions(Context c, String[] p) { return ""; }
    public Class<?> getRequestPermissionsActivity() { return null; }
}
