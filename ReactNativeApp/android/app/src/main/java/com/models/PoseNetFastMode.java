package com.models;

import android.content.Context;

import com.google.mlkit.vision.pose.PoseDetection;
import com.google.mlkit.vision.pose.defaults.PoseDetectorOptions;

public class PoseNetFastMode extends PoseNet {

    @Override
    public void loadModel(Context context) {
        PoseDetectorOptions options =
                new PoseDetectorOptions.Builder()
                        .setDetectorMode(PoseDetectorOptions.STREAM_MODE)
//                        .setPerformanceMode(PoseDetectorOptions.PERFORMANCE_MODE_FAST)
                        .build();

        detectionModel = PoseDetection.getClient(options);
    }
}
