package com.lge.media;

import android.graphics.Bitmap;

/** Safe fallback for the discontinued LG GIF encoder. */
public class GifEncoder {
    public GifEncoder() { }
    public void setDelay(int delayMs) { }
    public boolean start(String path) { return false; }
    public boolean addFrame(Bitmap frame) { return false; }
    public boolean addFrameDouble(Bitmap first, Bitmap second) { return false; }
    public boolean addFrameTriple(Bitmap first, Bitmap second, Bitmap third) { return false; }
    public boolean finish() { return false; }
}
