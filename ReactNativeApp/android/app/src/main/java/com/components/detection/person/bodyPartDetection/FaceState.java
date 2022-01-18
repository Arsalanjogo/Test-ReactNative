package com.components.detection.person.bodyPartDetection;

import com.components.detection.person.bone.BoneState;
import com.location.DetectionLocation;
import com.models.BodyParts;
import com.models.ModelManager;
import com.utils.InfoBlob;

import java.util.List;

public class FaceState extends BodyPartState {
    protected final BoneState noseLeftEye, noseRightEye, rightEyeRightEar, leftEyeLeftEar;
    final ModelManager.MODELTYPE modeltype;
    public BodyElement nose, leftEye, rightEye, innerRightEye, leftEar, rightEar, innerLeftEye;

    public FaceState(ModelManager.MODELTYPE modeltype, boolean exerciseLead) {
        super("face", modeltype, exerciseLead);
        this.modeltype = modeltype;
        addNose(exerciseLead);
        addLeftEye(exerciseLead);
        addRightEye(exerciseLead);
        addLeftEar(exerciseLead);
        addRightEar(exerciseLead);

        noseLeftEye = new BoneState(nose, leftEye);
        bones.add(noseLeftEye);
        noseRightEye = new BoneState(nose, rightEye);
        bones.add(noseRightEye);
        rightEyeRightEar = new BoneState(rightEye, rightEar);
        bones.add(rightEyeRightEar);
        leftEyeLeftEar = new BoneState(leftEye, leftEar);
        bones.add(leftEyeLeftEar);

    }

    public void addNose(boolean exerciseLead) {
        nose = new BodyElement(BodyParts.BODYPART.NOSE.label, modeltype, exerciseLead);
        bodyElements.add(nose);
    }

    public void addLeftEye(boolean exerciseLead) {
        leftEye = new BodyElement(BodyParts.BODYPART.LEFT_EYE.label, modeltype, exerciseLead);
        innerLeftEye = new BodyElement(BodyParts.BODYPART.LEFT_EYE_INNER.label, modelType, exerciseLead);
        bodyElements.add(leftEye);
        bodyElements.add(innerLeftEye);
    }

    public void addRightEye(boolean exerciseLead) {
        rightEye = new BodyElement(BodyParts.BODYPART.RIGHT_EYE.label, modeltype, exerciseLead);
        bodyElements.add(rightEye);
    }


    public void addLeftEar(boolean exerciseLead) {
        leftEar = new BodyElement(BodyParts.BODYPART.LEFT_EAR.label, modeltype, exerciseLead);
        bodyElements.add(leftEar);
    }

    public void addRightEar(boolean exerciseLead) {
        rightEar = new BodyElement(BodyParts.BODYPART.RIGHT_EAR.label, modeltype, exerciseLead);
        bodyElements.add(rightEar);
    }


    @Override
    public String getName() {
        return "face";
    }

    @Override
    public void parse(List<DetectionLocation> detectedLocations, InfoBlob info) {
        super.parse(detectedLocations, info);
    }
}
