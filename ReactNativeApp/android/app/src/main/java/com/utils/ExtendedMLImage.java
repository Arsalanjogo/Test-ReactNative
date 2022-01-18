package com.utils;

import android.graphics.Bitmap;

import com.google.android.odml.image.BitmapMlImageBuilder;
import com.google.android.odml.image.MlImage;

public class ExtendedMLImage {

    protected final int screenOrientation;
    private final int frameID;
    private final MlImage mlImage;

    public ExtendedMLImage(Bitmap bitmap, int frameID, int screenOrientation) {
        this.frameID = frameID;
        this.screenOrientation = screenOrientation;
        mlImage = new BitmapMlImageBuilder(bitmap).setRotation(screenOrientation).build();
    }

    public ExtendedMLImage(Bitmap bitmap, int frameID) {
        this(bitmap, frameID, 0);
    }

    public int getFrameID() {
        return frameID;
    }

    public MlImage getMlImage() {
        return mlImage;
    }

    public int getScreenOrientation() {
        return screenOrientation;
    }
}

