package com.components.basic.calibration;

import android.graphics.Canvas;
import android.graphics.Paint;
import android.view.View;

import com.ssvc.SV.LayoutSV;
import com.utils.Paint443;
import com.views.AutoFitTextureView;

public class CalibrationView extends LayoutSV<CalibrationState> {

    public final Paint443 background = new Paint443().transparancy(0.5).fill();
    protected float XScreenMessage = 0.5f;
    protected float YScreenMessage = 0.5f;
    protected Paint443 textPaint;
    protected int textSize = 100;
    protected String calibrationMessage = "";

    public CalibrationView(CalibrationState state) {
        super(state);
        AutoFitTextureView.addLayoutSV(this);
    }

    @Override
    public View getView() {
        return null;
    }

    protected void drawCalibrationText(Canvas canvas) {
        calibrationMessage = state.isCalibrated ? "Move inside\nthe screen" : "";
        float y = YScreenMessage;
        if (textPaint == null)
            textPaint = new Paint443().white().textSize(textSize).align(Paint.Align.CENTER).bioSansBold();

        for (String line : calibrationMessage.split("\n")) {
            canvas.drawText(line, XScreenMessage * canvas.getWidth(), YScreenMessage * canvas.getHeight() + y, textPaint);
            y += textPaint.descent() - textPaint.ascent();
        }
    }

    public void draw(Canvas canvas) {
        super.draw(canvas);
       // drawCalibrationText(canvas);
        drawIndication(canvas);
    }

    private void drawIndication(Canvas canvas) {

        canvas.drawRect(state.leftScreen * canvas.getWidth(), state.topScreen * canvas.getHeight(),
                state.rightScreen * canvas.getWidth(), state.bottomScreen * canvas.getHeight(),
                state.calibratedSince != null ? new Paint443().yellow433().largeStroke() : new Paint443().red().stroke().strokeWidth(20));

        // rect1 left
        canvas.drawRect(0.0f, state.topScreen * canvas.getHeight(), state.leftScreen * canvas.getWidth(),
                state.bottomScreen * canvas.getHeight(), background);

        // rect2 top
        canvas.drawRect(0.0f, 0.0f, canvas.getWidth(), state.topScreen * canvas.getHeight(), background);


        //rect right
        canvas.drawRect(state.rightScreen * canvas.getWidth(), state.topScreen * canvas.getHeight(),
                canvas.getWidth(), state.bottomScreen * canvas.getHeight(), background);

        // rect bottom

        canvas.drawRect(0.0f, state.bottomScreen * canvas.getHeight(), canvas.getWidth(),
                canvas.getHeight(), background);

    }


    @Override
    public String getDebugText() {
        return "CalibrationView";
    }
}
