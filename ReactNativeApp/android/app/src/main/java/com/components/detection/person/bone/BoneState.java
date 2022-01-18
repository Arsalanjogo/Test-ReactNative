package com.components.detection.person.bone;

import com.components.detection.person.bodyPartDetection.BodyElement;
import com.ssvc.State;

public class BoneState extends State {

    protected final BodyElement bodyPart1;
    protected final BodyElement bodyPart2;
    protected final String boneName;


    public BoneState(BodyElement bodyPart1, BodyElement bodyPart2) {
        this.bodyPart1 = bodyPart1;
        this.bodyPart2 = bodyPart2;
        this.boneName = bodyPart1.getLabel() + " " + bodyPart2.getLabel();
    }

    public String getBoneName() {
        return boneName;
    }

    public BodyElement getBodyPart1() {
        return bodyPart1;
    }

    public BodyElement getBodyPart2() {
        return bodyPart2;
    }

    @Override
    public String getDebugText() {
        return "";
    }
}
