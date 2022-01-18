package com.exercises.base.statistics;

import android.graphics.Canvas;
import android.os.SystemClock;

import com.components.detection.ObjectDetectionState;
import com.location.DetectionLocation;
import com.utils.Paint443;

import java.util.List;
import java.util.stream.IntStream;

public class AppStatistics {
    public long exerciseTime;
    public long startTime;
    private Long[] averageCtS;
    private int frameCounter = 0;

    public void startExercise() {
        exerciseTime = SystemClock.elapsedRealtime();
    }

    public void start() {
        startTime = SystemClock.elapsedRealtime();
    }
    //initializing averageCtS array

    public void initAverageCts(List<ObjectDetectionState> objectDetections) {
        averageCtS = new Long[objectDetections.size()];
        IntStream.range(0, objectDetections.size()).forEach(idx -> averageCtS[idx] = 0L);
    }


    public void drawModelStatistics(Canvas canvas, List<ObjectDetectionState> objectDetections) {

        if (averageCtS == null) {
            initAverageCts(objectDetections);
        }

        frameCounter++;

        for (int i = 0; i < objectDetections.size(); i++) {
            ObjectDetectionState objectDetection = objectDetections.get(i);
            DetectionLocation loc = objectDetection.getLocation();

            averageCtS[i] += objectDetection.getInfoBlobArrayList().getLast() == null ? 0 : objectDetection.getInfoBlobArrayList().getLast().sinceStart();

            String s = objectDetection.getLabel() + " frame: " + (loc == null ? 0 : loc.getFrameID()) +
                    " ms/i: " + String.format("%.1f", (SystemClock.elapsedRealtime() - startTime) / (float) objectDetection.getFrameInferenceCount()) +
                    " skip: " + objectDetection.getSkippedFrameCount() +
                    " CtS: " + (int) (averageCtS[i] / frameCounter);

            canvas.drawText(s, 20, Paint443.getNewDrawDebugHeight(), new Paint443().red().fillStroke().small().monospace());
            // todo what about this?
            //objectDetection.drawDebug(canvas);
        }
    }

}
