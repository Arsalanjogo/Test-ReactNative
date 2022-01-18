package com.location;

import android.graphics.Canvas;
import android.graphics.Paint;

import com.utils.Gear;
import com.utils.Paint443;

public class PointLocation extends DetectionLocation {
    private double radius;

    public PointLocation(String classLabel, double centerX, double centerY, double centerZ, int frameID, float confidence, STATUS status, double radius) {
        super(classLabel, centerX, centerY, centerZ, frameID, confidence, status);
        this.radius = radius;
    }

    public PointLocation(String classLabel, double centerX, double centerY, double centerZ, int frameID, float confidence) {
        this(classLabel, centerX, centerY, centerZ, frameID, confidence, STATUS.DETECTED, 0.01);
    }


    public void updateLocation(double centerX, double centerY, STATUS status) {
        this.x = centerX;
        this.y = centerY;
        this.status = status;

    }


    public void drawNames(Canvas canvas, Paint paint) {
        // draw circle for names
        drawPoints(canvas, paint);
        // draw names
        canvas.drawText(label + " " + String.format("%.2f", confidence), (int) ((getX() * canvas.getWidth()) + radius * Math.min(canvas.getWidth(), canvas.getHeight())), (int) ((getY() * canvas.getHeight()) + radius * Math.min(canvas.getWidth(), canvas.getHeight())), new Paint443().red().fillStroke().small().monospace());
    }

    public void drawPoints(Canvas canvas, Paint paint) {
        canvas.drawCircle((float) getX() * canvas.getWidth(),
                (float) getY() * canvas.getHeight(),
                (float) (radius * Math.min(canvas.getWidth(), canvas.getHeight())),
                paint);
    }

    public void drawDebug(Canvas canvas) {
        drawDebug(canvas, new Paint443().transparancy(.95));
    }


    @Override
    public void drawDebug(Canvas canvas, Paint paint) {

        if (Gear.iff("points", true))
            drawPoints(canvas, paint);
        if (Gear.iff("names", false))
            drawNames(canvas, new Paint443().red().narrowStroke().medium());

    }

    public void draw(Canvas canvas) {
        canvas.drawCircle((float) getX() * canvas.getWidth(),
                (float) getY() * canvas.getHeight(),
                (float) (radius * Math.min(canvas.getWidth(), canvas.getHeight())),
                new Paint443().red().narrowStroke().medium());
    }

    public double getRadius() {
        return radius;
    }

    public void setRadius(int radius) {
        this.radius = radius;
    }
}
