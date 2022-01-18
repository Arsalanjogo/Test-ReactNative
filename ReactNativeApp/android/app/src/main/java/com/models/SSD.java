package com.models;

import android.content.Context;
import android.content.res.AssetManager;
import android.graphics.Bitmap;
import android.graphics.RectF;
import android.os.SystemClock;
import android.util.Pair;

import com.activities.GameActivity;
import com.location.DetectionLocation;
import com.location.RectLocation;
import com.logger.SLOG;
import com.logger.TLOG;
import com.utils.InfoBlob;

import org.tensorflow.lite.support.image.TensorImage;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Map;
import java.util.Vector;
import java.util.concurrent.ConcurrentHashMap;

import io.reactivex.rxjava3.core.Flowable;


public class SSD extends TFLiteModel {

    final int labelOffset;
    final String labelFileName;
    protected List<String> labels = new Vector<>();
    int MAXDETECTIONS = 10;
    long waitingTime = 0;
    int frameID;

    public SSD(String modelFileName, String labelFileName, int labelOffset) {
        super(0.55f, modelFileName);
        this.labelOffset = labelOffset;
        this.labelFileName = labelFileName;
    }

    public void loadLabels(AssetManager assetManager) throws IOException {
        InputStream labelsInput = assetManager.open(labelFileName);
        BufferedReader br = new BufferedReader(new InputStreamReader(labelsInput));
        String line;
        while ((line = br.readLine()) != null) {
            SLOG.d(line);
            labels.add(line);
        }
        labelsInput.close();
        br.close();
    }

    public void loadModel(Context context) throws IOException {
        super.loadModel(context);
        loadLabels(context.getAssets());
    }

    protected Map<Integer, Object> buildOutputMap() {

        int[] shape = detectionModel.getOutputTensor(0).shape();

        float[][][] outputLocations = new float[shape[0]][shape[1]][shape[2]];

        shape = detectionModel.getOutputTensor(1).shape();

        float[][] outputClasses = new float[shape[0]][shape[1]];

        shape = detectionModel.getOutputTensor(2).shape();
        float[][] outputScores = new float[shape[0]][shape[1]];

        shape = detectionModel.getOutputTensor(3).shape();
        float[] numDetections = new float[shape[0]];

        Map<Integer, Object> outputMap = new ConcurrentHashMap<>();
        outputMap.put(0, outputLocations);
        outputMap.put(1, outputClasses);
        outputMap.put(2, outputScores);
        outputMap.put(3, numDetections);
        return outputMap;
    }

    @Override
    protected Flowable<Pair<List<DetectionLocation>, InfoBlob>> RunModel(Pair<TensorImage, InfoBlob> blob) {
        if (!running) return null;
        SLOG.d("runModel SSD:" + blob.second.getFrameID());
        SLOG.d("SSD wait Time:" + (SystemClock.elapsedRealtime() - waitingTime));

        TensorImage inputImage = blob.first;
        frameID = blob.second.getFrameID();
        String ONIMAGE = "run SSD";
        TLOG.start(ONIMAGE);

        Map<Integer, Object> outputmap = buildOutputMap();
        detectionModel.runForMultipleInputsOutputs(new Object[]{inputImage.getBuffer()}, outputmap);

        float[][][] outputLocations = (float[][][]) outputmap.get(0);

        float[][] outputClasses = (float[][]) outputmap.get(1);

        float[][] outputScores = (float[][]) outputmap.get(2);

        float[] numDetections = (float[]) outputmap.get(3);

        TLOG.addSplit(ONIMAGE, "Ran TFLite");

        int numDetectionsOutput = Math.min(MAXDETECTIONS, (int) numDetections[0]); // cast from float to integer, use min for safety

        final List<DetectionLocation> recognitions = new ArrayList<>(numDetectionsOutput);

        SLOG.d("NumDetectionsOutput" + numDetectionsOutput);
        SLOG.d("OutputScores" + Arrays.deepToString(outputScores));
        SLOG.d("OutputClasses" + Arrays.deepToString(outputClasses));

        for (int i = 0; i < numDetectionsOutput; ++i) {
            if (outputScores[0][i] < confidenceScore) continue;
            SLOG.d("before RectF init");

            //TODO if an object is square on camera, it will be projected as rectangular in cropped dimensions.
            float left = outputLocations[0][i][1];
            float top = outputLocations[0][i][0];
            float right = outputLocations[0][i][3];
            float bottom = outputLocations[0][i][2];

            if (GameActivity
                    .getFacing() == 0) {
                left = 1 - left;
                right = 1 - right;
            }

            RectF rectF = new RectF(
                    left,
                    top,
                    right,
                    bottom);

            DetectionLocation detection = new RectLocation(
                    rectF,
                    labels.get((int) outputClasses[0][i] + labelOffset),
                    frameID,
                    outputScores[0][i]
            );
            SLOG.d("detection confidence: " + detection.getConfidence());
            SLOG.d("detection label: " + detection.getLabel());

            recognitions.add(detection);
        }
        waitingTime = SystemClock.elapsedRealtime();
        TLOG.end(ONIMAGE);


        return Flowable.just(new Pair<>(recognitions, blob.second));
    }
}
