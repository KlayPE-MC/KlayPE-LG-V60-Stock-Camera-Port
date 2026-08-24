package com.lge.app.permission;

import android.content.Context;
import android.graphics.drawable.Drawable;
import java.io.Serializable;

public interface GuideUiProvider extends Serializable {
    Drawable getAppIcon(Context context);
    CharSequence getAppName(Context context, String[] permissions);
    CharSequence getDisabledFeatures(Context context, String[] permissions);
    CharSequence getFullMessageForRequestingPermissions(Context context, String[] permissions);
    CharSequence getReasonForRequestingPermissions(Context context, String[] permissions);
    Class<?> getRequestPermissionsActivity();
}
