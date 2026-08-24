package com.lge.lgdynamicactionbar;

import android.content.Context;
import android.util.AttributeSet;
import android.widget.LinearLayout;

public class AppBarLayout extends LinearLayout {
    public AppBarLayout(Context c) { super(c); }
    public AppBarLayout(Context c, AttributeSet a) { super(c, a); }
    public void setAppBarTitle(String title) { setContentDescription(title); }
    public void setAppBarGone(boolean gone) { setVisibility(gone ? GONE : VISIBLE); }
    public void setExpanded(boolean expanded) { }
}
