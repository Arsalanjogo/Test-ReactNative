package com.models;

import android.content.Context;
import android.os.SystemClock;
import android.util.Pair;

import com.activities.GameActivity;
import com.google.android.gms.tasks.Task;
import com.google.android.odml.image.MlImage;
import com.google.mlkit.vision.common.PointF3D;
import com.google.mlkit.vision.pose.Pose;
import com.google.mlkit.vision.pose.PoseDetection;
import com.google.mlkit.vision.pose.PoseDetector;
import com.google.mlkit.vision.pose.PoseLandmark;
import com.google.mlkit.vision.pose.accurate.AccuratePoseDetectorOptions;
import com.google.mlkit.vision.pose.defaults.PoseDetectorOptions;
import com.location.DetectionLocation;
import com.location.PointLocation;
import com.logger.SLOG;
import com.utils.ExtendedMLImage;
import com.utils.InfoBlob;
import com.utils.Triplet;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;


public class PoseNet extends MLKitModel<PoseDetector> implements BodyParts {

    Task<Pose> result;
    //MAPPINGS
    Map<Integer, String> map = new ConcurrentHashMap<>();
    Triplet<Float, Float, Float> postProcessed;
    private boolean busy = false;
    private long waitingTime = 0;

    {
        map.put(PoseLandmark.NOSE, BODYPART.NOSE.label);
        map.put(PoseLandmark.LEFT_EYE_INNER, BODYPART.LEFT_EYE_INNER.label);
        map.put(PoseLandmark.LEFT_EYE, BODYPART.LEFT_EYE.label);
        map.put(PoseLandmark.LEFT_EYE_OUTER, BODYPART.LEFT_EYE_OUTER.label);
        map.put(PoseLandmark.RIGHT_EYE_INNER, BODYPART.RIGHT_EYE_INNER.label);
        map.put(PoseLandmark.RIGHT_EYE, BODYPART.RIGHT_EYE.label);
        map.put(PoseLandmark.RIGHT_EYE_OUTER, BODYPART.RIGHT_EYE_OUTER.label);
        map.put(PoseLandmark.LEFT_EAR, BODYPART.LEFT_EAR.label);
        map.put(PoseLandmark.RIGHT_EAR, BODYPART.RIGHT_EAR.label);
        map.put(PoseLandmark.LEFT_MOUTH, BODYPART.LEFT_MOUTH.label);
        map.put(PoseLandmark.RIGHT_MOUTH, BODYPART.RIGHT_MOUTH.label);
        map.put(PoseLandmark.LEFT_SHOULDER, BODYPART.LEFT_SHOULDER.label);
        map.put(PoseLandmark.RIGHT_SHOULDER, BODYPART.RIGHT_SHOULDER.label);
        map.put(PoseLandmark.LEFT_ELBOW, BODYPART.LEFT_ELBOW.label);
        map.put(PoseLandmark.RIGHT_ELBOW, BODYPART.RIGHT_ELBOW.label);
        map.put(PoseLandmark.LEFT_WRIST, BODYPART.LEFT_WRIST.label);
        map.put(PoseLandmark.RIGHT_WRIST, BODYPART.RIGHT_WRIST.label);
        map.put(PoseLandmark.LEFT_PINKY, BODYPART.LEFT_PINKY.label);
        map.put(PoseLandmark.RIGHT_PINKY, BODYPART.RIGHT_PINKY.label);
        map.put(PoseLandmark.LEFT_INDEX, BODYPART.LEFT_INDEX.label);
        map.put(PoseLandmark.RIGHT_INDEX, BODYPART.RIGHT_INDEX.label);
        map.put(PoseLandmark.LEFT_THUMB, BODYPART.LEFT_THUMB.label);
        map.put(PoseLandmark.RIGHT_THUMB, BODYPART.RIGHT_THUMB.label);
        map.put(PoseLandmark.LEFT_HIP, BODYPART.LEFT_HIP.label);
        map.put(PoseLandmark.RIGHT_HIP, BODYPART.RIGHT_HIP.label);
        map.put(PoseLandmark.LEFT_KNEE, BODYPART.LEFT_KNEE.label);
        map.put(PoseLandmark.RIGHT_KNEE, BODYPART.RIGHT_KNEE.label);
        map.put(PoseLandmark.LEFT_ANKLE, BODYPART.LEFT_ANKLE.label);
        map.put(PoseLandmark.RIGHT_ANKLE, BODYPART.RIGHT_ANKLE.label);
        map.put(PoseLandmark.LEFT_HEEL, BODYPART.LEFT_HEEL.label);
        map.put(PoseLandmark.RIGHT_HEEL, BODYPART.RIGHT_HEEL.label);
        map.put(PoseLandmark.LEFT_FOOT_INDEX, BODYPART.LEFT_FOOT_INDEX.label);
        map.put(PoseLandmark.RIGHT_FOOT_INDEX, BODYPART.RIGHT_FOOT_INDEX.label);
    }


    public PoseNet() {
        super(0.85f);
    }

    @Override
    public void loadModel(Context context) {
        {
            AccuratePoseDetectorOptions options =
                    new AccuratePoseDetectorOptions.Builder()
                            .setDetectorMode(PoseDetectorOptions.STREAM_MODE)
                            //DO NOT CHANGE THIS!! use PoseNetFast
                            .build();

            detectionModel = PoseDetection.getClient(options);
        }
    }

    // todo redundant class now.
    public Pair<MlImage, InfoBlob> preProcessImage(Pair<ExtendedMLImage, InfoBlob> extendedMlImageInfoBlobPair) {
        ExtendedMLImage mlImage = extendedMlImageInfoBlobPair.first;
        return new Pair<>(mlImage.getMlImage(), extendedMlImageInfoBlobPair.second);
    }

    public Triplet<Float, Float, Float> postProcess(PointF3D pointF, MlImage mlImage) {
        Triplet<Float, Float, Float> temp;

        if (GameActivity.getActivity().isOrientationLandscape()) temp = new Triplet<>(pointF.getX() / mlImage.getWidth(), pointF.getY() / mlImage.getHeight(), pointF.getZ() / mlImage.getHeight());
        else  temp = new Triplet<>(pointF.getX() / mlImage.getHeight(), pointF.getY() / mlImage.getWidth(), pointF.getZ() / mlImage.getHeight());

        if (GameActivity.getFacing() == 0)
            return new Triplet<>(1 - temp.getFirst(), temp.getSecond(), temp.getThird()); // for frontFacing (the skeleton is mirrored otherwise)

        return temp;
    }

    public void runModel() {
        if (busy || processed || !running) return;
        busy = true;
        processed = true;

        long runModelTime = SystemClock.elapsedRealtime();
        SLOG.d("model wait TIme:" + (SystemClock.elapsedRealtime() - waitingTime));
        InfoBlob infoBlob = preProcessed.second;
        result = detectionModel.process(preProcessed.first)
                .addOnSuccessListener(
                        pose -> {

                            if (!running) return;
                            SLOG.d("model execution TIme:" + (SystemClock.elapsedRealtime() - runModelTime));
                            busy = false;
                            waitingTime = SystemClock.elapsedRealtime();

                            List<PoseLandmark> allPoseLandmarks = pose.getAllPoseLandmarks();
                            List<DetectionLocation> detectionLocations = new ArrayList<>();

                            for (PoseLandmark mk : allPoseLandmarks) {
                                if (mk.getInFrameLikelihood() < confidenceScore) continue;
                                postProcessed = postProcess(mk.getPosition3D(), preProcessed.first);
                                String label = map.getOrDefault(mk.getLandmarkType(), "");
                                detectionLocations.add(new PointLocation(label, postProcessed.getFirst(), postProcessed.getSecond(), postProcessed.getThird(), infoBlob.getFrameID(), mk.getInFrameLikelihood()));
                            }

                            distributeLocations(new Pair<>(detectionLocations, infoBlob));
                            runModel();
                        })
                .addOnFailureListener(
                        e -> {
                            SLOG.e("PoseNet Failure: " + e);
                            throw new IllegalStateException(e);
                        });

    }


    @Override
    public void stop() {
        super.stop();
        detectionModel.close();
    }
}
