package com.components.basic.calibration;

import android.os.SystemClock;

import com.components.detection.ObjectDetectionState;
import com.components.games.base.GameContext;
import com.location.DetectionLocation;
import com.logger.SLOG;
import com.ssvc.Controller;

import java.util.ArrayList;
import java.util.List;
import java.util.function.Predicate;

public class CalibrationController extends Controller<CalibrationState> {

    protected final List<Predicate<DetectionLocation>> extraChecks = new ArrayList<>();
    protected int CALIBRATION_TIME = 700;

    public CalibrationController(CalibrationState state) {
        super(state);
    }

    protected boolean isInsideBox(DetectionLocation detection) {
        return state.bottomScreen > detection.getY() && state.topScreen < detection.getY()
                && state.leftScreen < detection.getX() && state.rightScreen > detection.getX();
    }

    protected boolean detectionsCalibrated() {
        //check if all detections are calibrated
        return GameContext.getContext().detections.stream().map(ObjectDetectionState::getDetectedLocation).allMatch(
                (d -> (d != null) &&
                        extraChecks.stream().allMatch((p) -> p.test(d))
                        && isInsideBox(d)));
    }

    public void processCalibration() {
        if (!detectionsCalibrated()) {
            state.calibratedSince = null;
            state.isCalibrated = false;
        } else {
            if (state.calibratedSince == null) {
                state.calibratedSince = SystemClock.elapsedRealtime();
                state.isCalibrated = false;
            } else if (isCalibrated()) {
                state.isCalibrated = true;
            }
        }

        GameContext.getContext().ball.state.isCalibrated = state.calibratedSince != null;
        GameContext.getContext().person.state.isCalibrated = state.calibratedSince != null;


    }


    public boolean isCalibrated() {
        return state.calibratedSince != null && (state.calibratedSince + CALIBRATION_TIME) < SystemClock.elapsedRealtime();
    }

    @Override
    public String getDebugText() {
        return "";
    }

}
