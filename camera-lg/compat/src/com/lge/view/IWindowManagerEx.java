package com.lge.view;

import android.os.Binder;
import android.os.IBinder;
import android.os.IInterface;
import java.util.Collections;
import java.util.List;

public interface IWindowManagerEx extends IInterface {
    List getWindowInfoList(int displayId, boolean visibleOnly);

    abstract class Stub extends Binder implements IWindowManagerEx {
        public static IWindowManagerEx asInterface(IBinder binder) {
            return new IWindowManagerEx() {
                @Override public List getWindowInfoList(int displayId, boolean visibleOnly) {
                    return Collections.emptyList();
                }
                @Override public IBinder asBinder() { return binder; }
            };
        }
    }
}
