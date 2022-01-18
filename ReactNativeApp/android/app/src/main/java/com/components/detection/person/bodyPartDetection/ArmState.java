package com.components.detection.person.bodyPartDetection;

import com.components.detection.person.bone.BoneState;
import com.location.DetectionLocation;
import com.models.ModelManager;
import com.models.PoseNet;
import com.utils.InfoBlob;

import java.util.List;

public class ArmState extends BodyPartState {

    public final BodyElement shoulder;
    public final BodyElement elbow;
    public final BodyElement wrist;
    public final BodyElement pinky;
    public final BodyElement index;
    public final BodyElement thumb;
    public final BoneState underArm;
    public final BoneState upperArm;

    public ArmState(Orientation orientation, ModelManager.MODELTYPE modelType, boolean exerciseLead) {
        super("Arm", modelType, exerciseLead, orientation);

        switch (orientation) {
            case LEFT:
                shoulder = new BodyElement(PoseNet.BODYPART.LEFT_SHOULDER.label, modelType, exerciseLead);
                elbow = new BodyElement(PoseNet.BODYPART.LEFT_ELBOW.label, modelType, exerciseLead);
                wrist = new BodyElement(PoseNet.BODYPART.LEFT_WRIST.label, modelType, exerciseLead);

                if (modelType == ModelManager.MODELTYPE.OLD_POSENET) {
                    pinky = wrist;
                    index = wrist;
                    thumb = wrist;
                } else { // POSENET_FASTMODE or POSENET
                    pinky = new BodyElement(PoseNet.BODYPART.LEFT_PINKY.label, modelType, exerciseLead);
                    index = new BodyElement(PoseNet.BODYPART.LEFT_INDEX.label, modelType, exerciseLead);
                    thumb = new BodyElement(PoseNet.BODYPART.LEFT_THUMB.label, modelType, exerciseLead);
                }

                break;

            case RIGHT:
                shoulder = new BodyElement(PoseNet.BODYPART.RIGHT_SHOULDER.label, modelType, exerciseLead);
                elbow = new BodyElement(PoseNet.BODYPART.RIGHT_ELBOW.label, modelType, exerciseLead);
                wrist = new BodyElement(PoseNet.BODYPART.RIGHT_WRIST.label, modelType, exerciseLead);

                if (modelType == ModelManager.MODELTYPE.OLD_POSENET) {
                    pinky = wrist;
                    index = wrist;
                    thumb = wrist;
                } else { // POSENET_FASTMODE or POSENET
                    pinky = new BodyElement(PoseNet.BODYPART.RIGHT_PINKY.label, modelType, exerciseLead);
                    index = new BodyElement(PoseNet.BODYPART.RIGHT_INDEX.label, modelType, exerciseLead);
                    thumb = new BodyElement(PoseNet.BODYPART.RIGHT_THUMB.label, modelType, exerciseLead);

                }


                break;
            default:
                throw new IllegalStateException("Unexpected value: " + orientation);
        }

        bodyElements.add(shoulder);
        bodyElements.add(elbow);
        bodyElements.add(wrist);


        bodyElements.add(pinky);
        bodyElements.add(index);
        bodyElements.add(thumb);


        underArm = new BoneState(wrist, elbow);
        upperArm = new BoneState(elbow, shoulder);
        bones.add(underArm);
        bones.add(upperArm);
    }

    @Override
    public String getName() {
        return orientation + "arm";
    }


    @Override
    public void parse(List<DetectionLocation> detectedLocations, InfoBlob info) {
        super.parse(detectedLocations, info);
    }

    @Override
    public String toString() {
        return "ArmDetection{" +
                "orientation=" + orientation +
                ", shoulder=" + shoulder +
                ", elbow=" + elbow +
                ", wrist=" + wrist +
                '}';
    }
}
