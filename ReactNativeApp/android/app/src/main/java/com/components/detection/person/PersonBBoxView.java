package com.components.detection.person;

import android.content.res.Resources;
import android.graphics.Canvas;
import android.graphics.RectF;
import android.view.View;

import com.components.detection.ObjectDetectionState;
import com.components.games.base.GameContext;
import com.location.DetectionLocation;
import com.logger.SLOG;
import com.ssvc.SV.LayoutSV;
import com.utils.Paint443;
import com.views.AutoFitTextureView;

import java.util.ArrayList;
import java.util.List;
import java.util.Objects;
import java.util.stream.Collectors;

public class PersonBBoxView extends LayoutSV<PersonState> {

    Paint443 bbPaint = new Paint443().strokeWidth(30).stroke().transparancy(0.5);

    public PersonBBoxView(PersonState state) {
        super(state);
        AutoFitTextureView.addLayoutSV(this);
    }

    @Override
    public View getView() {
        return null;
    }

    public void drawBBox(Canvas canvas) {

        List<DetectionLocation> lastLocations = state.getDetectionSubClasses().stream().map(ObjectDetectionState::getDetectedLocation)
                .filter(Objects::nonNull)
                .filter((d -> d.getStatus() == DetectionLocation.STATUS.DETECTED))
                .collect(Collectors.toCollection(ArrayList::new));


        // todo might be optimized using a normal loop
        if (lastLocations.isEmpty()) return;
        try {
            float minX = lastLocations.stream().min(DetectionLocation::compareByX).get().getXf();
            float maxX = lastLocations.stream().max(DetectionLocation::compareByX).get().getXf();
            float minY = lastLocations.stream().min(DetectionLocation::compareByY).get().getYf();
            float maxY = lastLocations.stream().max(DetectionLocation::compareByY).get().getYf();
            canvas.drawRect(new RectF(minX * canvas.getWidth(), minY * canvas.getHeight(),
                            maxX * canvas.getWidth(), maxY * canvas.getHeight()),
                    GameContext.getContext().person.state.isCalibrated ? bbPaint.yellow433() : bbPaint.red());
        } catch (Resources.NotFoundException e) {
            SLOG.e(e);
        }
    }

    public void draw(Canvas canvas) {
        super.draw(canvas);
        // drawBBox(canvas);
    }

    public void detachFromLayoutSV() {
        AutoFitTextureView.removeLayoutSV(this);
    }

    @Override
    public String getDebugText() {
        return null;
    }
}
