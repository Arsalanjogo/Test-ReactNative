package com.models;

import android.util.Pair;

import com.location.DetectionLocation;
import com.location.PointLocation;
import com.logger.SLOG;
import com.logger.TLOG;
import com.utils.InfoBlob;

import org.tensorflow.lite.support.image.TensorImage;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

import io.reactivex.rxjava3.core.Flowable;

import static java.lang.Math.exp;

public class OldPoseNet extends TFLiteModel implements BodyParts {

    public OldPoseNet() {
        super(0.6f, "posenet-225.tflite");

        //todo we should decide more smartly here
        device = Device.GPU;
    }

    private float sigmoid(float x) {
        return (float) (1.0f / (1.0f + exp(-x)));
    }

    protected Map<Integer, Object> buildOutputMap() {

        // 1 * 9 * 9 * 17 contains heatmaps
        int[] shape = detectionModel.getOutputTensor(0).shape();
        float[][][][] heatmaps = new float[shape[0]][shape[1]][shape[2]][shape[3]];


        // 1 * 9 * 9 * 34 contains offsets
        shape = detectionModel.getOutputTensor(1).shape();
        float[][][][] offsets = new float[shape[0]][shape[1]][shape[2]][shape[3]];

        // 1 * 9 * 9 * 32 contains forward displacements
        shape = detectionModel.getOutputTensor(2).shape();
        float[][][][] displacementsFwd = new float[shape[0]][shape[1]][shape[2]][shape[3]];

        // 1 * 9 * 9 * 32 contains backward displacements
        shape = detectionModel.getOutputTensor(3).shape();
        float[][][][] displacementsBwd = new float[shape[0]][shape[1]][shape[2]][shape[3]];


        Map<Integer, Object> outputMap = new ConcurrentHashMap<>();
        outputMap.put(0, heatmaps);
        outputMap.put(1, offsets);
        outputMap.put(2, displacementsFwd);
        outputMap.put(3, displacementsBwd);
        return outputMap;

    }

    @Override
    protected Flowable<Pair<List<DetectionLocation>, InfoBlob>> RunModel(Pair<TensorImage, InfoBlob> extendedMlImageInfoBlobPair) {
        TLOG.start("posenet");
        TensorImage inputImage = extendedMlImageInfoBlobPair.first;
        int frameID = extendedMlImageInfoBlobPair.second.getFrameID();


        Map outputMap = buildOutputMap();

        TLOG.start("run posenet");
        detectionModel.runForMultipleInputsOutputs(new Object[]{inputImage.getBuffer()}, outputMap);
        TLOG.end("run posenet");

        float[][][][] heatmaps = (float[][][][]) outputMap.get(0);
        float[][][][] offsets = (float[][][][]) outputMap.get(1);

//        float[][][][] displacementsFwd = (float[][][][]) outputMap.get(2);
//        float[][][][] displacementsBwd = (float[][][][]) outputMap.get(3);


        int height = heatmaps[0].length;
        int width = heatmaps[0][0].length;
        int numKeypoints = heatmaps[0][0][0].length;

        // Finds the (row, col) locations of where the keypoints are most likely to be.
        Pair<Integer, Integer>[] keypointPositions = new Pair[numKeypoints];

        for (int keypoint = 0; keypoint < numKeypoints; keypoint++) {

            float maxVal = heatmaps[0][0][0][keypoint];
            int maxRow = 0;
            int maxCol = 0;
            for (int row = 0; row < height; row++) {
                for (int col = 0; col < width; col++) {
                    if (heatmaps[0][row][col][keypoint] > maxVal) {
                        maxVal = heatmaps[0][row][col][keypoint];
                        maxRow = row;
                        maxCol = col;
                    }
                }
            }
            keypointPositions[keypoint] = new Pair(maxRow, maxCol);
        }


        // Calculating the x and y coordinates of the keypoints with offset adjustment.
        float[] xCoords = new float[numKeypoints];
        float[] yCoords = new float[numKeypoints];
        float[] confidenceScores = new float[numKeypoints];
        for (int idx = 0; idx < numKeypoints; idx++) {
            int positionY = keypointPositions[idx].first;
            int positionX = keypointPositions[idx].second;
            yCoords[idx] = (positionY / (height - 1f) +
                    offsets[0][positionY][positionX][idx] / ((float) inputImage.getHeight()));

            xCoords[idx] = ((positionX / (width - 1f)) +
                    offsets[0][positionY][positionX][idx + numKeypoints] / ((float) inputImage.getWidth())
            );
            confidenceScores[idx] = sigmoid(heatmaps[0][positionY][positionX][idx]);
        }


        List<DetectionLocation> locations = new ArrayList<>();
        Person person = new Person();
        List<KeyPoint> keypointList = new ArrayList<>();
        float totalScore = 0;
        int cnt = 0;
        for (OLD_BODYPART old_part : OLD_BODYPART.values()) {
            //this is not clean code...
            BODYPART part;
            part = BODYPART.valueOf(old_part.toString());

            KeyPoint keyPoint = new KeyPoint();
            keyPoint.bodyPart = part;
            keyPoint.position.x = (int) xCoords[cnt];
            keyPoint.position.y = (int) yCoords[cnt];


            keyPoint.score = confidenceScores[cnt];

            if (confidenceScores[cnt] > this.confidenceScore) {
                locations.add(new PointLocation(part.label, xCoords[cnt], yCoords[cnt], 0.0, frameID, confidenceScores[cnt]));
            }

            SLOG.d(String.valueOf(keyPoint));
            totalScore += confidenceScores[cnt];
            keypointList.add(keyPoint);
            cnt++;
        }
        person.keyPoints = keypointList;
        person.score = totalScore / numKeypoints;
        TLOG.end("posenet");
        return Flowable.just(new Pair<>(locations, extendedMlImageInfoBlobPair.second));
    }

    public enum OLD_BODYPART {
        NOSE("nose"),
        LEFT_EYE("left_eye"),
        RIGHT_EYE("right_eye"),
        LEFT_EAR("left_ear"),
        RIGHT_EAR("right_ear"),
        LEFT_SHOULDER("left_shoulder"),
        RIGHT_SHOULDER("right_shoulder"),
        LEFT_ELBOW("left_elbow"),
        RIGHT_ELBOW("right_elbow"),
        LEFT_WRIST("left_wrist"),
        RIGHT_WRIST("right_wrist"),
        LEFT_HIP("left_hip"),
        RIGHT_HIP("right_hip"),
        LEFT_KNEE("left_knee"),
        RIGHT_KNEE("right_knee"),
        LEFT_ANKLE("left_ankle"),
        RIGHT_ANKLE("right_ankle");

        protected final String label;

        OLD_BODYPART(String label) {
            this.label = label;
        }
    }

    private class Position {
        int x = 0;
        int y = 0;
    }

    private class KeyPoint {
        BODYPART bodyPart = BODYPART.NOSE;
        Position position = new Position();
        float score = 0.0f;

        @Override
        public String toString() {
            return "KeyPoint{" +
                    "bodyPart=" + bodyPart +
                    ", position=" + position +
                    ", score=" + score +
                    '}';
        }
    }

    private class Person {
        List<KeyPoint> keyPoints = new ArrayList<>();
        float score = 0.0f;
    }
}
