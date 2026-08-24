package com.lge.view;

import android.view.View;

public final class ViewUtil {
    private ViewUtil() { }
    public static void setLGSystemUiVisibility(View view, int visibility) {
        if (view != null) view.setSystemUiVisibility(visibility);
    }
}
