package com.lge.systemservice.core;

import android.os.Binder;
import android.os.IBinder;
import android.os.SystemProperties;

public class OsManager {
    public void setSystemProperty(String key, String value) {
        try {
            SystemProperties.set(key, value);
        } catch (RuntimeException ignored) { }
    }

    public IBinder makePersistent(String packageName) { return new Binder(); }
    public void makeNonPersistent(IBinder token) { }
    public void makeNonPersistentUsingPackageName(String packageName) { }
}
