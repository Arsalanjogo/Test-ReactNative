package com.components.basic.calibration;

import com.activities.GameActivity;
import com.components.games.base.GameContext;
import com.ssvc.State;
import com.utils.sensors.SSensorManager;
import com.utils.sensors.callbackManager;

public class SensorCalibrationState extends State {

    public SSensorManager sensorManager;
    protected float rotationSensorY = 0;
    protected float rotationSensorZ = 0;
    protected callbackManager sensorListener = null;
    protected double rotationZHigh;
    protected double rotationZLow;
    protected double rotationYHigh;
    protected double rotationYLow;
    protected boolean isRotationCalibrated;
    // todo get landscape flag from settings
    protected boolean isLandscape;

    public SensorCalibrationState() {
        sensorManager = GameContext.getContext().sensorManager;
        isLandscape = GameActivity.getActivity().isOrientationLandscape();
    }


    public void cleanup() {
        // unregister listener
        if (sensorListener != null) {
            sensorListener.cancel();
        }
    }

    @Override
    public String getDebugText() {
        return "";
    }
}
