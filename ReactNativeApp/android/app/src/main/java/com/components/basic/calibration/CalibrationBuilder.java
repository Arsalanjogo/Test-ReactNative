package com.components.basic.calibration;

import com.ssvc.SSVC;
import com.ssvc.SSVCBuilder;

public class CalibrationBuilder extends SSVCBuilder {
    static private CalibrationState buildState() {
        return new CalibrationState();
    }

    public static SSVC<CalibrationState, CalibrationView, CalibrationController> buildCalibration() {
        CalibrationState state = buildState();
        CalibrationView calibrationView = new CalibrationView(state);
        CalibrationController calibrationController = new CalibrationController(state);
        return new SSVC<>(state, calibrationView, calibrationController);
    }
}
