package com.location;

import android.graphics.Canvas;
import android.graphics.Paint;

public abstract class DetectionLocation extends Location {

    protected final int frameID;
    protected String label;
    protected float confidence;
    protected STATUS status;
    private boolean processed = false;


    public DetectionLocation(String label, double centerX, double centerY, double centerZ, int frameID, float confidence, STATUS status) {
        super(centerX, centerY, centerZ);
        this.label = label;
        this.frameID = frameID;
        this.confidence = confidence;
        this.status = status;
    }

    public DetectionLocation(String label, double centerX, double centerY, int frameID, float confidence, STATUS status) {
        this(label, centerX, centerY, 0.0, frameID, confidence, status);
    }

    public static int compareByY(DetectionLocation firstLocation, DetectionLocation secondLocation) {
        return (firstLocation.getY() < secondLocation.getY()) ? -1 : 1;
    }

    public static int compareByX(DetectionLocation firstLocation, DetectionLocation secondLocation) {
        return (firstLocation.getX() < secondLocation.getX()) ? -1 : 1;

    }

    abstract public void updateLocation(double centerX, double centerY, STATUS inferred);

    public String getLabel() {
        return label;
    }

    public int getFrameID() {
        return frameID;
    }

    public float getConfidence() {
        return confidence;
    }

    public boolean locationKnown() {
        return (status == STATUS.DETECTED || status == STATUS.INFERRED);
    }

    public boolean isProcessed() {
        return processed;
    }

    public void process() {
        this.processed = true;
    }

    public STATUS getStatus() {
        return status;
    }

    public String getStatusChar() {
        if (getStatus() == STATUS.DETECTED) return "D";
        if (getStatus() == STATUS.INFERRED) return "I";
        if (getStatus() == STATUS.MISSING) return "M";
        if (getStatus() == STATUS.SKIPPED) return "S";
        return null;
    }

    abstract public void drawDebug(Canvas canvas, Paint paint);

    @Override
    public String toString() {
        return "DetectionLocation{" +
                "label='" + label + '\'' +
                ", frameID=" + frameID +
                ", confidence=" + confidence +
                ", status=" + status +
                ", processed=" + processed +
                ", radius=" + getRadius() +
                ", x=" + x +
                ", y=" + y +
                '}';
    }

    public enum STATUS {
        DETECTED,
        INFERRED,
        MISSING,
        SKIPPED
    }
}
