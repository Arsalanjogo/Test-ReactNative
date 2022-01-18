package com.components.basic.calibration;

import com.football433.R;
import com.render.lottie.LottieRender;
import com.ssvc.Controller;

public class SensorCalibrationController extends Controller<SensorCalibrationState> {

    protected LottieRender tiltLevel;
    protected LottieRender rotationLevel;

    protected final int TOTAL_LEVEL_ANIMATION_FRAME = 41;
    protected final int FRAME_DIFFERENCE = 10;

    public SensorCalibrationController(SensorCalibrationState state) {
        super(state);

        if (state.isLandscape) {

            state.rotationYHigh = 17;
            state.rotationYLow = 7;

            state.rotationZHigh = -80;
            state.rotationZLow = -95;

        } else {

            state.rotationYHigh = 25;
            state.rotationYLow = 17;

            state.rotationZHigh = 8;
            state.rotationZLow = -8;

        }

        tiltLevel = new LottieRender(R.raw.level_tilt).ephemeral(false).setScale(0.3f, 0.3f).setNormalizedPosition(0.75, 0.5).play();
        rotationLevel = new LottieRender(R.raw.level_rotation).ephemeral(false).setScale(0.6f, 0.6f).setNormalizedPosition(0.5, 0.90).play();
        setupSensor();

    }

    private void sensorCallback(float[] orientations) {

        state.rotationSensorY = orientations[1];
        state.rotationSensorZ = orientations[2];

        double adjustedYValue = Math.max(Math.min(state.rotationSensorY, state.rotationYHigh + FRAME_DIFFERENCE), state.rotationYLow - FRAME_DIFFERENCE);
        double adjustedZValue = Math.max(Math.min(state.rotationSensorZ, state.rotationZHigh + FRAME_DIFFERENCE), state.rotationZLow - FRAME_DIFFERENCE);

        // Calculate yAxis Correctness values. should be between (0-1).
        // correctness = (value - lowestLimit) / (highestLimit - lowestLimit)
        // correctnessFrame = correctness * TOTAL_LEVEL_ANIMATION_FRAME

        double yAxisValue = (adjustedYValue - (state.rotationYLow - FRAME_DIFFERENCE)) /
                ((state.rotationYHigh + FRAME_DIFFERENCE) - (state.rotationYLow - FRAME_DIFFERENCE));
        int tiltValue = (int)(yAxisValue * TOTAL_LEVEL_ANIMATION_FRAME);

        double zAxisValue = (adjustedZValue - (state.rotationZLow - FRAME_DIFFERENCE)) /
                ((state.rotationZHigh + FRAME_DIFFERENCE) - (state.rotationZLow - FRAME_DIFFERENCE));
        int rotationValue = (int)((1 - zAxisValue) * TOTAL_LEVEL_ANIMATION_FRAME);


        tiltLevel.goToFrame(tiltValue);
        rotationLevel.goToFrame(rotationValue);


        if (state.rotationSensorY < state.rotationYHigh && state.rotationSensorY > state.rotationYLow &&
                state.rotationSensorZ < state.rotationZHigh && state.rotationSensorZ > state.rotationZLow) {
            state.isRotationCalibrated = true;

        } else {

            state.isRotationCalibrated = false;

            if (state.rotationSensorY > state.rotationYHigh || state.rotationSensorY < state.rotationYLow) {
                // tilt up
                tiltLevel.showAnimationContainer();
            }

            if (state.rotationSensorZ > state.rotationZHigh || state.rotationSensorZ < state.rotationZLow) {
                // rotate left
                rotationLevel.showAnimationContainer();
            }
        }
    }

    protected void deleteAllDirectionLottie() {
        if (tiltLevel == null || rotationLevel == null) return;
        tiltLevel.delete();
        rotationLevel.delete();
    }

    // todo need discussion
    public void cleanUp(boolean forceful) {
        if (state.isRotationCalibrated || forceful) {
            state.cleanup();
            deleteAllDirectionLottie();
        }
    }

    public Boolean isRotationCalibrated() {
        return state.isRotationCalibrated;
    }

    private void setupSensor() {
        state.sensorListener = state.sensorManager.getXYZOrientation(this::sensorCallback);
    }


    @Override
    public String getDebugText() {
        return "";
    }
}
