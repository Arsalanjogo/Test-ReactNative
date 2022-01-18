package com.components.detection.person.bodyPartDetection;

import com.components.detection.person.bone.BoneState;
import com.location.DetectionLocation;
import com.models.ModelManager;
import com.models.OldPoseNet;
import com.utils.InfoBlob;

import java.util.List;

public class LegState extends BodyPartState {
    public final BodyElement hip;
    public final BodyElement knee;
    public final BodyElement ankle;
    public final BoneState lowerLeg;
    public final BoneState upperLeg;
    public final BodyElement heel;
    public final BodyElement index;

    public LegState(Orientation orientation, ModelManager.MODELTYPE modeltype, boolean exerciseLead) {
        super("Leg", modeltype, exerciseLead, orientation);

        switch (orientation) {
            case LEFT:
                hip = new BodyElement(OldPoseNet.BODYPART.LEFT_HIP.label, modeltype, exerciseLead);
                knee = new BodyElement(OldPoseNet.BODYPART.LEFT_KNEE.label, modeltype, exerciseLead);
                ankle = new BodyElement(OldPoseNet.BODYPART.LEFT_ANKLE.label, modeltype, exerciseLead);

                if (modeltype == ModelManager.MODELTYPE.OLD_POSENET) {
                    heel = ankle;
                    index = ankle;
                } else {
                    heel = new BodyElement(OldPoseNet.BODYPART.LEFT_HEEL.label, modeltype, exerciseLead);
                    index = new BodyElement(OldPoseNet.BODYPART.LEFT_FOOT_INDEX.label, modeltype, exerciseLead);
                }
                break;
            case RIGHT:
                hip = new BodyElement(OldPoseNet.BODYPART.RIGHT_HIP.label, modeltype, exerciseLead);
                knee = new BodyElement(OldPoseNet.BODYPART.RIGHT_KNEE.label, modeltype, exerciseLead);
                ankle = new BodyElement(OldPoseNet.BODYPART.RIGHT_ANKLE.label, modeltype, exerciseLead);

                if (modeltype == ModelManager.MODELTYPE.OLD_POSENET) {
                    heel = ankle;
                    index = ankle;
                } else {
                    heel = new BodyElement(OldPoseNet.BODYPART.RIGHT_HEEL.label, modeltype, exerciseLead);
                    index = new BodyElement(OldPoseNet.BODYPART.RIGHT_FOOT_INDEX.label, modeltype, exerciseLead);
                }
                break;
            default:
                throw new IllegalStateException("Unexpected value: " + orientation);
        }

        bodyElements.add(hip);
        bodyElements.add(knee);
        bodyElements.add(ankle);
        bodyElements.add(heel);

        lowerLeg = new BoneState(ankle, knee);
        upperLeg = new BoneState(knee, hip);
        bones.add(lowerLeg);
        bones.add(upperLeg);

    }

    @Override
    public String getName() {
        return orientation + "leg";
    }


    @Override
    public void parse(List<DetectionLocation> detectedLocations, InfoBlob info) {
        super.parse(detectedLocations, info);
    }

    @Override
    public String toString() {
        return "LegDetection{" +
                "hip=" + hip +
                ", knee=" + knee +
                ", ankle=" + ankle +
                ", orientation=" + orientation +
                '}';
    }

}
