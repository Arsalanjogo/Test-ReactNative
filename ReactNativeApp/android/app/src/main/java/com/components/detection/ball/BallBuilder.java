package com.components.detection.ball;

import com.models.ModelManager;
import com.ssvc.SSVC;
import com.ssvc.SSVCBuilder;

public class BallBuilder extends SSVCBuilder {
    static BallDetectionState buildState(ModelManager.MODELTYPE modelType, boolean exerciseLead) {
        return new BallDetectionState(modelType, exerciseLead);
    }

    public static SSVC<BallDetectionState, BallDetectionView, BallDetectionController> buildBallDetection(ModelManager.MODELTYPE modelType, boolean exerciseLead) {
        BallDetectionState state = buildState(modelType, exerciseLead);
        BallDetectionView ballStateView = new BallDetectionView(state);
        BallDetectionController ballController = new BallDetectionController(state);
        return new SSVC<>(state, ballStateView, ballController);
    }
}