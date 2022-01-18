package com.components.detection.person;

import android.graphics.Canvas;
import android.graphics.Paint;
import android.view.View;

import com.components.detection.person.bodyPartDetection.BodyPartState;
import com.components.detection.person.bone.BoneState;
import com.location.DetectionLocation;
import com.loop.CustomCameraView;
import com.ssvc.SV.LayoutSV;
import com.utils.Paint443;
import com.views.AutoFitTextureView;

public class PersonSkeletonView extends LayoutSV<PersonState> {

    Paint443 bonePaint = new Paint443().yellow433().strokeWidth(10).stroke();


    public PersonSkeletonView(PersonState state) {
        super(state);
        AutoFitTextureView.addLayoutSV(this);
    }

    @Override
    public View getView() {
        return null;
    }

    public void drawPoints(Canvas canvas, Paint paint, DetectionLocation location) {
        if (location == null || !location.locationKnown()) return;
        canvas.drawCircle((float) location.getX() * canvas.getWidth(),
                (float) location.getY() * canvas.getHeight(),
                (float) (location.getRadius() * Math.min(canvas.getWidth(), canvas.getHeight())),
                paint);
    }

    public void drawBones(Canvas canvas, BoneState boneState, Paint paint) {
        DetectionLocation l1 = boneState.getBodyPart1().getLocation();
        DetectionLocation l2 = boneState.getBodyPart2().getLocation();
        if (l1 == null || !l1.locationKnown() || l2 == null || !l2.locationKnown()) return;
        canvas.drawLine((float) l1.getX() * canvas.getWidth(), (float) l1.getY() * canvas.getHeight(), (float) l2.getX() * canvas.getWidth(), (float) l2.getY() * canvas.getHeight(), paint);
    }

    public void drawDebug(Canvas canvas) {
//        state.bodyParts.forEach(bp -> bp.bodyElements.forEach(bp2 ->
//                drawPoints(canvas,
//                        bp.getOrientation() == BodyPartState.Orientation.LEFT ? pointPaint.red() : pointPaint.blue(),
//                        bp2.getLocation())));

        state.bones.forEach(bone -> drawBones(canvas, bone, bonePaint.yellow433()));

        state.bodyParts.forEach(bp -> bp.bones.forEach(bone ->
                drawBones(canvas, bone, bp.getOrientation() == BodyPartState.Orientation.LEFT ? bonePaint.red() : bonePaint.blue() )));
    }

    public void draw(Canvas canvas) {
        super.draw(canvas);
        drawDebug(canvas);
    }

    public void detachFromLayoutSV() {
        CustomCameraView.removeLayoutSV(this);
    }

    @Override
    public String getDebugText() {
        return null;
    }
}