package com.components.detection.person;

import androidx.collection.ArraySet;

import com.components.detection.ObjectDetectionState;
import com.components.detection.person.bodyPartDetection.ArmState;
import com.components.detection.person.bodyPartDetection.BodyPartState;
import com.components.detection.person.bodyPartDetection.FaceState;
import com.components.detection.person.bodyPartDetection.LegState;
import com.components.detection.person.bone.BoneState;
import com.location.DetectionLocation;
import com.models.ModelManager;
import com.utils.InfoBlob;
import com.utils.UtilArrayList;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.concurrent.ConcurrentHashMap;

public class PersonState extends ObjectDetectionState {

    public final FaceState face;
    public final ArmState leftArm;
    public final ArmState rightArm;
    protected final UtilArrayList<BoneState> bones = new UtilArrayList<>();
    public boolean isCalibrated = false;
    public LegState leftLeg;
    public LegState rightLeg;
    public BoneState shoulderToShoulder, rightShoulderRightHip, leftShoulderLeftHip, hipToHip;
    public boolean up = true;
    UtilArrayList<BodyPartState> bodyParts = new UtilArrayList<>();
    Map<String, Long> tempInfoBlobMap = new ConcurrentHashMap<>();
    private Set<ObjectDetectionState> objectDetectionSet;

    public PersonState(boolean exerciseLead, ModelManager.MODELTYPE modelType) {
        super("person", modelType, false);

        leftArm = new ArmState(BodyPartState.Orientation.LEFT, modelType, exerciseLead);
        bodyParts.add(leftArm);

        rightArm = new ArmState(BodyPartState.Orientation.RIGHT, modelType, exerciseLead);
        bodyParts.add(rightArm);

        face = new FaceState(modelType, exerciseLead);
        bodyParts.add(face);

        shoulderToShoulder = new BoneState(leftArm.shoulder, rightArm.shoulder);
        bones.add(shoulderToShoulder);

        leftLeg = new LegState(BodyPartState.Orientation.LEFT, modelType, exerciseLead);
        bodyParts.add(leftLeg);

        rightLeg = new LegState(BodyPartState.Orientation.RIGHT, modelType, exerciseLead);
        bodyParts.add(rightLeg);

        rightShoulderRightHip = new BoneState(rightArm.shoulder, rightLeg.hip);
        bones.add(rightShoulderRightHip);

        leftShoulderLeftHip = new BoneState(leftArm.shoulder, leftLeg.hip);
        bones.add(leftShoulderLeftHip);

        hipToHip = new BoneState(leftLeg.hip, rightLeg.hip);
        bones.add(hipToHip);
    }

    public PersonState() {
        //default POSENET (ACCURATE MODE)
        this(false, ModelManager.MODELTYPE.POSENET);
    }

    public PersonState(ModelManager.MODELTYPE modelType) {
        this(false, modelType);

    }

    public Set<ObjectDetectionState> getDetectionSubClasses() {
        if (objectDetectionSet == null) {
            objectDetectionSet = new ArraySet<>();
            bodyParts.forEach(bodyPart -> objectDetectionSet.addAll(bodyPart.getObjectDetections()));
        }
        //ensures we do it only once
        return objectDetectionSet;
    }

    public void setConfidenceScore(float confidenceScore) {
        //!!NOTE this changes the confidence score of posenet, but this confidence score is only used for the inframe likelihood.
        // we cannot change the posenet detection accuracy, as it's determined internally by the posenet module
        super.setConfidenceScore(confidenceScore);
        bodyParts.forEach(bodyPartDetection -> bodyPartDetection.setConfidenceScore(confidenceScore));
    }

    @Override
    public void parse(List<DetectionLocation> detectedLocations, InfoBlob info) {
        synchronized (this) {
            super.parse(detectedLocations, info);
        }
    }

    // todo: after object detection state conversion
    private void inferTimeStamps() {
        // todo use a normal list instead of a hashmap
        tempInfoBlobMap.clear();

        // first add all the timeStamps for known/available frameIDs
        if (getInfoBlobArrayList().isEmpty()) return;
        long timeOffset = getInfoBlobArrayList().get(0).getStartTime();
        for (InfoBlob infoBlob : getInfoBlobArrayList()) {
            tempInfoBlobMap.put("" + infoBlob.getFrameID(), infoBlob.getStartTime() - timeOffset);
        }
        final int DIFF_LIMIT = 1;

        // approximate the timeStamps for the missing frames
        for (int idx = 1; idx < getInfoBlobArrayList().size(); idx++) {
            int prevFrameID = getInfoBlobArrayList().get(idx - 1).getFrameID();
            int currFrameID = getInfoBlobArrayList().get(idx).getFrameID();
            int diff = Math.abs(currFrameID - prevFrameID);
            if (diff > DIFF_LIMIT) { // a frame was skipped (or multiple frames were skipped)
                int i = 1;
                while (i <= diff - 1) {
                    long prevTimeStamp = getInfoBlobArrayList().get(idx - 1).getStartTime() - timeOffset;
                    long currTimeStamp = getInfoBlobArrayList().get(idx).getStartTime() - timeOffset;
                    long timeDiff = Math.abs(currTimeStamp - prevTimeStamp);
                    long newTime = timeDiff / (diff + 1);
                    newTime = (newTime * i) + prevTimeStamp;
                    tempInfoBlobMap.put("" + (prevFrameID + i), newTime);
                    i++;
                }
            }

        }
    }


    public void writeToJSON(JSONObject dataJSONWriter) throws JSONException {

        try {

            // some of the frames in infoBlobArrayList are skipped, therefore we don't have the timeStamps for every frame/location.
            // that's why we will have to approximate the timeStamps for the missing frames.
            inferTimeStamps();  // the timeStamps for the missing frames and for the available frames are contained in the tempInfoBlobMap <frameID : timeStamp>

            JSONObject data = new JSONObject();
            for (ObjectDetectionState obj : getDetectionSubClasses()) {
                JSONObject object = new JSONObject();
                obj.writeToJSON(object);
                data.put(obj.getLabel(), object);
            }

            JSONArray time = new JSONArray();
            JSONArray frame = new JSONArray();

            for (int i = 0; i < getLocations().size(); i++) {
                frame.put(getLocations().get(i).getFrameID());
                time.put(tempInfoBlobMap.get("" + i));
            }
            // data.put(object);
            dataJSONWriter.put("time_Stamp", time);
            dataJSONWriter.put("frame", frame);
            dataJSONWriter.put("person_data", data);

        } catch (JSONException e) {
            throw new JSONException(e);
        }

    }

    @Override
    public void unSubscribe() {
        super.unSubscribe();
        bodyParts.forEach(BodyPartState::unSubscribe);
    }


    @Override
    public String getDebugText() {
        return "";
    }
}
