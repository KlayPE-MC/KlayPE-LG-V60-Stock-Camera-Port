package com.lge.app.permission;

import android.app.Activity;
import android.content.Context;
import android.content.pm.PackageManager;
import java.util.ArrayList;

public final class RequestPermissionsHelper {
    private RequestPermissionsHelper() { }
    public static boolean hasPermissions(Context context, String[] permissions) {
        for (String p : permissions) if (context.checkSelfPermission(p) != PackageManager.PERMISSION_GRANTED) return false;
        return true;
    }
    public static boolean requestPermissionsIfNeeded(Activity activity, String[] permissions, GuideUiProvider provider) {
        ArrayList<String> missing = new ArrayList<>();
        for (String p : permissions) if (activity.checkSelfPermission(p) != PackageManager.PERMISSION_GRANTED) missing.add(p);
        if (missing.isEmpty()) return false;
        activity.requestPermissions(missing.toArray(new String[0]), 100);
        return true;
    }
}
