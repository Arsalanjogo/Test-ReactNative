package com.components.detection.person;

import android.graphics.Canvas;
import android.graphics.Paint;
import android.view.View;

import com.components.detection.person.bone.BoneState;
import com.location.DetectionLocation;
import com.ssvc.SV.LayoutSV;
import com.utils.Paint443;


public class PersonView extends LayoutSV<PersonState> {

    public PersonView(PersonState state) {
        super(state);
        //new PersonSkeletonView(state);
    }

    @Override
    public View getView() {
        return null;
    }

    public void drawBoneDebug(Canvas canvas, Paint paint, BoneState bone) { //drawDebug replica
        DetectionLocation l1 = bone.getBodyPart1().getLocation();
        DetectionLocation l2 = bone.getBodyPart2().getLocation();
        if (l1 == null || !l1.locationKnown() || l2 == null || !l2.locationKnown()) return;

        canvas.drawLine((float) l1.getX() * canvas.getWidth(), (float) l1.getY() * canvas.getHeight(), (float) l2.getX() * canvas.getWidth(), (float) l2.getY() * canvas.getHeight(), paint);
    }

    public void drawBoneDebug(Canvas canvas, BoneState bone) {
        drawBoneDebug(canvas, new Paint443().yellow433().mediumStroke(), bone);
    }

    public void drawDebug(Canvas canvas) {
        state.bones.forEach(b -> drawBoneDebug(canvas, b));
    }


    @Override
    public String getDebugText() {
        return "";
    }
}
