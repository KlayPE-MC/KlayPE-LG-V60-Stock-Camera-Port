package com.lge.systemservice.core;

import android.content.Context;
import java.util.Locale;

/** Maps the small subset of LG services used by LGCamera to safe compatibility objects. */
public class LGContext {
    private final Context context;

    public LGContext(Context context) { this.context = context; }

    public Object getLGSystemService(String name) {
        if (name == null) return null;
        String service = name.toLowerCase(Locale.ROOT);
        if (service.contains("thermal")) return new LGThermalManager();
        if (service.contains("cover")) return new SmartCoverManager();
        if (service.contains("vibrat") || service.contains("volume")) return new VolumeVibratorManager();
        if (service.contains("power") || service.contains("dual")) return new LGPowerManagerHelper();
        if (service.contains("os") || service.contains("persist")) return new OsManager();
        return context.getSystemService(name);
    }
}
