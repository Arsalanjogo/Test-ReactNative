package com.components.detection.ball;

import com.components.detection.ObjectDetectionState;
import com.location.DetectionLocation;
import com.location.RectLocation;
import com.logger.SLOG;
import com.models.ModelManager;
import com.utils.InfoBlob;

import org.json.JSONException;
import org.json.JSONObject;

import java.util.List;


public class BallDetectionState extends ObjectDetectionState {
    protected final static String LABEL = "ball";
    public DetectionLocation low1pt = null, low2pt = null, highPt = null;  // debug purposes: peak visualization
    public boolean isCalibrated = false;
    protected double width = 0;
    protected double height = 0;
    protected double radius = 0;
    protected int lastBounceID = 0;
    protected boolean bounce;

    public BallDetectionState(ModelManager.MODELTYPE modelType, boolean exerciseLead) {
        super(LABEL, modelType, exerciseLead);
    }

    public BallDetectionState(boolean exerciseLead) {
        this(ModelManager.MODELTYPE.FOOTBALLv16, exerciseLead);
    }


    @Override
    public void parse(List<DetectionLocation> detectedLocations, InfoBlob info) {
        super.parse(detectedLocations, info);
        DetectionLocation l = getLocation();
        if (l.getStatus() == DetectionLocation.STATUS.DETECTED) {
            //here we know it's a rectLocation

            //todo should be equal
            width = (width + ((RectLocation) l).getRect().width() / 2) / 2f;
            height = (height + ((RectLocation) l).getRect().height() / 2) / 2f;
            radius = (radius + l.getRadius()) / 2f;
        }
        SLOG.d("ballHeight: " + height);
    }

    public double getWidth() {
        return width;
    }

    public double getHeight() {
        return height;
    }


    @Override
    public void writeToJSON(JSONObject dataJSONWriter) throws JSONException {
        super.writeToJSON(dataJSONWriter);
        dataJSONWriter.put("width", locations.getAsFlatJsonArray((d) -> d instanceof RectLocation ? ((RectLocation) d).getWidth() : 0));
        dataJSONWriter.put("height", locations.getAsFlatJsonArray((d) -> d instanceof RectLocation ? ((RectLocation) d).getHeight() : 0));
    }


    public enum ORIENTATION {
        LEFT,
        RIGHT,
        ANY
    }


}
