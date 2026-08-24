package com.lge.media;

import android.media.MediaRecorder;
import android.util.Log;
import java.lang.reflect.Method;

/** Compatibility bridge for the LG camera on current Android media APIs. */
public class MediaRecorderEx extends MediaRecorder {
    private static final String TAG = "LGCameraCompat";
    private static Method parameterMethod;

    public MediaRecorderEx() {
        super();
    }

    private void sendParameter(String value) {
        try {
            if (parameterMethod == null) {
                parameterMethod = MediaRecorder.class.getDeclaredMethod("setParameter", String.class);
                parameterMethod.setAccessible(true);
            }
            parameterMethod.invoke(this, value);
        } catch (ReflectiveOperationException | RuntimeException e) {
            Log.w(TAG, "MediaRecorder rejected LG parameter: " + value, e);
        }
    }

    public void setParameter(String value) { sendParameter(value); }
    public void setLGParameters(String value) { sendParameter(value); }
    public void setRecordingType(String value) { sendParameter("recording-type=" + value); }
    public void setUUID(String value) { sendParameter("uuid=" + value); }
    public void setLoopback(int value) { sendParameter("loopback=" + value); }
    public void setLoopRecordEnable(int value) { sendParameter("loop-record=" + value); }
    public void setLoopRecordFilePath(String value) { sendParameter("loop-record-path=" + value); }
    public void setAudioZooming() { sendParameter("audio-zoom=1"); }
    public void changeMaxFileSize(long bytes) { setMaxFileSize(bytes); }
    public void doLoopRecording() { }
    public void seamlessSwitchCamera(int cameraId) { sendParameter("seamless-camera=" + cameraId); }
    public void setCameraIdSeamlessSwitch(int cameraId) { sendParameter("seamless-camera-id=" + cameraId); }
    public void switchCamera(int cameraId, String value) { sendParameter("switch-camera=" + cameraId + "," + value); }
    public boolean stopCameraSeamlessSwitch(int cameraId) { return false; }
}
