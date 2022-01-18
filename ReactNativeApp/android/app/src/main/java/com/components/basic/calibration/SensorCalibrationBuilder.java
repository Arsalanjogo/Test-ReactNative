package com.components.basic.calibration;

import com.ssvc.SSVC;
import com.ssvc.SSVCBuilder;

public class SensorCalibrationBuilder extends SSVCBuilder {
    static private SensorCalibrationState buildState() {
        return new SensorCalibrationState();
    }

    public static SSVC<SensorCalibrationState, SensorCalibrationView, SensorCalibrationController> buildSensorCalibration() {
        SensorCalibrationState state = new SensorCalibrationState();
        SensorCalibrationView sensorCalibrationView = new SensorCalibrationView(state);
        SensorCalibrationController sensorCalibrationController = new SensorCalibrationController(state);
        return new SSVC<>(state, sensorCalibrationView, sensorCalibrationController);
    }
}
