package com.lge.mdm.config;

public class LGMDMApplicationState {
    private final String packageName;
    private final int enable;

    public LGMDMApplicationState() {
        this("", 1);
    }

    public LGMDMApplicationState(String packageName, int enable) {
        this.packageName = packageName;
        this.enable = enable;
    }

    public String getPackageName() { return packageName; }
    public int getEnable() { return enable; }
}
