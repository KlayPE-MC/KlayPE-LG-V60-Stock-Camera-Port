package com.lge.media;

import android.media.CamcorderProfile;

/** Presents standard Android profiles using the field layout expected by LGCamera. */
public class CamcorderProfileEx {
    public int duration, quality, fileFormat, videoCodec, videoBitRate, videoFrameRate;
    public int videoFrameWidth, videoFrameHeight, audioCodec, audioBitRate, audioSampleRate, audioChannels;

    private CamcorderProfileEx(CamcorderProfile p) {
        duration = p.duration; quality = p.quality; fileFormat = p.fileFormat;
        videoCodec = p.videoCodec; videoBitRate = p.videoBitRate; videoFrameRate = p.videoFrameRate;
        videoFrameWidth = p.videoFrameWidth; videoFrameHeight = p.videoFrameHeight;
        audioCodec = p.audioCodec; audioBitRate = p.audioBitRate;
        audioSampleRate = p.audioSampleRate; audioChannels = p.audioChannels;
    }

    private static int fallbackQuality(int quality) {
        if (quality >= 0x2725 && quality <= 0x2730) return CamcorderProfile.QUALITY_2160P;
        if (quality >= 0x271c && quality <= 0x271f) return CamcorderProfile.QUALITY_1080P;
        if (quality >= 0x2720 && quality <= 0x2724) return CamcorderProfile.QUALITY_720P;
        if (quality == 0xbb9 || quality == 0x36 || quality == 0x41d) return CamcorderProfile.QUALITY_2160P;
        return quality;
    }

    public static CamcorderProfileEx get(int quality) { return get(0, quality); }
    public static CamcorderProfileEx get(int cameraId, int quality) {
        int mapped = fallbackQuality(quality);
        if (!CamcorderProfile.hasProfile(cameraId, mapped)) mapped = CamcorderProfile.QUALITY_HIGH;
        return new CamcorderProfileEx(CamcorderProfile.get(cameraId, mapped));
    }
    public static boolean hasProfile(int quality) { return hasProfile(0, quality); }
    public static boolean hasProfile(int cameraId, int quality) {
        return CamcorderProfile.hasProfile(cameraId, fallbackQuality(quality));
    }
    public static String getManualSupportedList(int cameraId, int quality, float ratio) { return null; }
}
