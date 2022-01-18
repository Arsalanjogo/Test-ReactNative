package com.phases.instances;

import com.activities.GameActivity;
import com.components.basic.calibration.CalibrationBuilder;
import com.components.basic.calibration.CalibrationController;
import com.components.basic.calibration.CalibrationState;
import com.components.basic.calibration.CalibrationView;
import com.components.basic.calibration.SensorCalibrationBuilder;
import com.components.basic.calibration.SensorCalibrationController;
import com.components.basic.calibration.SensorCalibrationState;
import com.components.basic.calibration.SensorCalibrationView;
import com.phases.base.Phase;
import com.phases.phasemanager.PhaseManager;
import com.ssvc.SSVC;

public class CalibrationPhase extends Phase {

    SSVC<CalibrationState, CalibrationView, CalibrationController> calibration;
    SSVC<SensorCalibrationState, SensorCalibrationView, SensorCalibrationController> sensorCalibration;

    @Override
    public void process() {
        calibration.controller.processCalibration();
        if (calibration.controller.isCalibrated())
            sensorCalibration.controller.cleanUp(false);
    }

    @Override
    public void initialize() {
        this.prevPhase = PhaseManager.GamePhases.PROMO_PHASE;
        this.nextPhase = PhaseManager.GamePhases.COUNTDOWN_PHASE;
        calibration = CalibrationBuilder.buildCalibration();
//        if (GameActivity.getActivity().isOrientationLandscape())
        sensorCalibration = SensorCalibrationBuilder.buildSensorCalibration();
        GameActivity.getActivity().showButtons();

    }

    @Override
    public boolean isDone() {
        return (sensorCalibration.controller.isRotationCalibrated() && calibration.controller.isCalibrated());
//        return calibration.controller.isCalibrated();
    }

    @Override
    public String getDebugText() {
        return "";
    }

    @Override
    public void cleanup() {
        super.cleanup();
        sensorCalibration.controller.cleanUp(true);
        sensorCalibration.state.cleanup();
        sensorCalibration.stateView.detachFromLayoutSV();
        calibration.stateView.detachFromLayoutSV();
    }

    @Override
    public PhaseManager.GamePhases getNextPhase() {
        return this.nextPhase;
    }

    @Override
    public PhaseManager.GamePhases getPrevPhase() {
        return this.prevPhase;
    }

}
