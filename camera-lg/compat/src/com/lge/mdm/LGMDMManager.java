package com.lge.mdm;

import android.content.ComponentName;
import java.util.Collections;
import java.util.List;

/** AOSP-compatible policy bridge; no LG enterprise policy means camera and microphone are allowed. */
public final class LGMDMManager {
    private static final LGMDMManager INSTANCE = new LGMDMManager();
    private LGMDMManager() { }

    public static LGMDMManager getInstance() { return INSTANCE; }
    public boolean getAllowCameraWithWhitelist(ComponentName admin) { return true; }
    public boolean getAllowMicrophone(ComponentName admin) { return true; }
    public List getCameraWhitelist(ComponentName admin) { return Collections.emptyList(); }
    public List getMicrophoneWhitelist(ComponentName admin) { return Collections.emptyList(); }
    public List getApplicationState(ComponentName admin) { return Collections.emptyList(); }
}
