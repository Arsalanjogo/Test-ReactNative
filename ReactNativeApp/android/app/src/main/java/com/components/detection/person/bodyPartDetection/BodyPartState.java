package com.components.detection.person.bodyPartDetection;

import androidx.collection.ArraySet;

import com.components.detection.ObjectDetectionState;
import com.components.detection.person.bone.BoneState;
import com.logger.SLOG;
import com.models.ModelManager;

import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;
import java.util.List;
import java.util.Set;

public abstract class BodyPartState extends ObjectDetectionState {
    // An Bodypart, consisting of multiple bodyElements
    public final List<ObjectDetectionState> bodyElements = new ArrayList<>();
    public final List<BoneState> bones = new ArrayList<>();
    protected Orientation orientation;
    Set<String> associatedLabels = null;
    private Set<ObjectDetectionState> objectDetectionSet;


    public BodyPartState(String label, ModelManager.MODELTYPE modelType, boolean exerciseLead, Orientation orientation) {
        super(label, modelType, exerciseLead);
        this.orientation = orientation;
    }

    public BodyPartState(String label, ModelManager.MODELTYPE modelType, boolean exerciseLead) {
        this(label, modelType, exerciseLead, Orientation.LEFT);
    }

    public List<ObjectDetectionState> getBodyElements() {
        return bodyElements;
    }


    @Override
    public void setConfidenceScore(float confidenceScore) {
        super.setConfidenceScore(confidenceScore);
        bodyElements.forEach(bodyElement -> bodyElement.setConfidenceScore(confidenceScore));
    }

    public Orientation getOrientation() {
        return orientation;
    }

    public Set<String> getAssociatedLabels() {
        //ensures we do it only once
        if (associatedLabels == null) {
            associatedLabels = new ArraySet<>();

            bodyElements.forEach(bodyElement -> associatedLabels.add(bodyElement.getLabel()));
            SLOG.d("labels of " + getName() + " : " + associatedLabels);
        }
        return associatedLabels;
    }

    public Set<ObjectDetectionState> getObjectDetections() {
        if (objectDetectionSet == null) {
            objectDetectionSet = new ArraySet<>();
            objectDetectionSet.addAll(bodyElements);
        }
        //ensures we do it only once
        return objectDetectionSet;
    }

    public abstract String getName();


    public void writeToJSON(JSONObject dataJSONWriter, int locIdx) {
        bodyElements.forEach(element -> {
            try {
                element.writeToJSON(dataJSONWriter);
            } catch (JSONException e) {
                e.printStackTrace();
            }
        });
    }

    @Override
    public void unSubscribe() {
        super.unSubscribe();
        bodyElements.forEach(ObjectDetectionState::unSubscribe);
    }

    public enum Orientation {
        LEFT, RIGHT
    }
}