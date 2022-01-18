package com.location;

import android.graphics.Canvas;

import com.components.detection.ObjectDetectionState;
import com.logger.SLOG;

import java.text.DecimalFormat;
import java.text.DecimalFormatSymbols;
import java.util.Locale;

public abstract class Location {
    protected double x;
    protected double y;
    protected double z;

    DecimalFormat df = new DecimalFormat("#.##");

    {
        //otherwise the , coming from the decimalformat might crash the parsefloat
        df.setDecimalFormatSymbols(DecimalFormatSymbols.getInstance(Locale.ENGLISH));
    }

    public Location(double x, double y, double z) {
        this.x = x;
        this.y = y;
        this.z = z;
    }

    public Location(double x, double y) {
        this(x, y, 0.0);
    }

    abstract public double getRadius();

    public double getX() {
        return x;
    }

    public void setX(double x) {
        this.x = x;
    }

    public double getY() {
        return y;
    }

    public void setY(double y) {
        this.y = y;
    }

    public double getZ() {
        return z;
    }

    public float getXf() {
        return (float) x;
    }

    public float getYf() {
        return (float) y;
    }

    public float getZf() {
        return (float) z;
    }

    public float getX2f() {
        return Float.parseFloat(df.format(x));
    }

    public float getY2f() {
        return Float.parseFloat(df.format(y));
    }

    public float getZ2f() {
        return Float.parseFloat(df.format(z));
    }

    public double getEuclideanDistance(double x, double y) {
        return Math.hypot(x - getX(), y - getY());
    }

    public boolean checkIntersection(ObjectDetectionState objectDetection) {
        return checkIntersection(objectDetection.getDetectedLocation());
    }

    public boolean checkIntersection(Location loc) {
        return checkIntersection(loc.getX(), loc.getY(), loc.getRadius());
    }

    public boolean checkIntersection(double x, double y, double radius) {
        SLOG.d("checkInterSection", "radius:" + Math.max(getRadius(), radius) + "distance:" + getEuclideanDistance(x, y));
        return Math.max(getRadius(), radius) > getEuclideanDistance(x, y);
    }

    public double getEuclideanDistance(Location l) {
        return getEuclideanDistance(l.getX(), l.getY());
    }

    public boolean checkIntersection(Location loc, double locRadius) {
        return Math.max(getRadius(), locRadius) > getEuclideanDistance(loc);
    }

    public boolean checkIntersectionLenient(Location loc) {
        return checkIntersectionLenient(loc, 1);
    }

    public boolean checkIntersectionLenient(Location loc, double multiplier) {
        return getRadius() * multiplier + loc.getRadius() * multiplier > getEuclideanDistance(loc);
    }


    public float canvX(Canvas canvas) {
        //get the X canvas coordinates

        return (float) (canvas.getWidth() * x);
    }

    public float canvY(Canvas canvas) {
        //get the Y canvas coordinates
        return (float) (canvas.getHeight() * y);
    }

    public float canvRad(Canvas canvas) {
        return (float) (Math.min(canvas.getWidth(), canvas.getHeight()) * getRadius());
    }

}
