package com.components.detection.person.bodyPartDetection;

import com.components.detection.ObjectDetectionState;
import com.logger.SLOG;
import com.models.ModelManager;

public class BodyElement extends ObjectDetectionState {
    // One small Element, like hand or feet

    public BodyElement(String label, ModelManager.MODELTYPE modelType, boolean exerciseLead) {
        super(label, modelType, exerciseLead);
        SLOG.d("body element" + label + "instantiated");
    }

}

