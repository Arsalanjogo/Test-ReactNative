package com.components.basic.calibration;

import com.activities.GameActivity;
import com.ssvc.State;


public class CalibrationState extends State {

    protected float topScreen = 0.1f;
    protected float bottomScreen = 0.95f;
    protected float leftScreen = 0.25f;
    protected float rightScreen = 0.75f;
    protected Long calibratedSince = null;
    protected boolean isCalibrated = false;

    public CalibrationState() {
     if (!GameActivity.getActivity().isOrientationLandscape()) {
         rightScreen = 0.82f;
         leftScreen = 0.18f;
     }
    }


    @Override
    public String getDebugText() {
        return "CalibrationState";
    }
}
