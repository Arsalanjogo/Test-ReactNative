package com.components.basic.calibration;

import android.graphics.Canvas;
import android.view.View;

import com.ssvc.SV.LayoutSV;
import com.views.AutoFitTextureView;

public class SensorCalibrationView extends LayoutSV<SensorCalibrationState> {

    public SensorCalibrationView(SensorCalibrationState state) {
        super(state);
        AutoFitTextureView.addLayoutSV(this);
    }

    @Override
    public View getView() {
        return null;
    }

    public void draw(Canvas canvas) {
        super.draw(canvas);

    }

    @Override
    public String getDebugText() {
        return "";
    }
}
