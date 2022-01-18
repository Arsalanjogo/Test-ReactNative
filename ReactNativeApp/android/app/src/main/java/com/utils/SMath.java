package com.utils;

import android.content.res.Resources;
import android.util.TypedValue;

import com.components.detection.ObjectDetectionState;
import com.location.DetectionLocation;

public class SMath {


    /***** SLOPE X *****/
    public static double calculateSlopeWithXAxis(double x1, double x2, double y1, double y2) {
        return Math.abs((y2 - y1) / (x2 - x1));
    }

    public static double calculateSlopeWithXAxis(DetectionLocation loc1, DetectionLocation loc2) {
        return calculateSlopeWithXAxis(loc1.getX(), loc2.getX(), loc1.getY(), loc2.getY());
    }

    public static double calculateSlopeWithXAxis(ObjectDetectionState obj1, ObjectDetectionState obj2) {
        return calculateSlopeWithXAxis(obj1.getDetectedLocation(), obj2.getDetectedLocation());
    }


    /***** ANGLE X *****/
    public static double calculateAngleWithXAxis(double x1, double x2, double y1, double y2) {
        return Math.round(Math.toDegrees(Math.atan((calculateSlopeWithXAxis(x1, x2, y1, y2)))) * 100.0) / 100.0;
    }

    public static double calculateAngleWithXAxis(DetectionLocation loc1, DetectionLocation loc2) {
        return calculateAngleWithXAxis(loc1.getX(), loc2.getX(), loc1.getY(), loc2.getY());
    }

    public static double calculateAngleWithXAxis(ObjectDetectionState obj1, ObjectDetectionState obj2) {
        return calculateAngleWithXAxis(obj1.getDetectedLocation(), obj2.getDetectedLocation());
    }


    /***** ANGLE Y *****/
    public static double calculateAngleWithYAxis(double x1, double x2, double y1, double y2) {
        return (Math.abs(90 - Math.round(Math.toDegrees(Math.atan(calculateSlopeWithXAxis(x1, x2, y1, y2))) * 100.0) / 100.0));
    }

    public static double calculateAngleWithYAxis(DetectionLocation loc1, DetectionLocation loc2) {
        return calculateAngleWithYAxis(loc1.getX(), loc2.getX(), loc1.getY(), loc2.getY());
    }

    public static double calculateAngleWithYAxis(ObjectDetectionState obj1, ObjectDetectionState obj2) {
        return calculateAngleWithYAxis(obj1.getDetectedLocation(), obj2.getDetectedLocation());
    }


    public static double calculateAngle3Points(DetectionLocation dlA, DetectionLocation dlB, DetectionLocation dlC, boolean negativeAngle) {
        /*
        * Forming a triangle
        * dlA = elbow
        * dlB = shoulder
        * dlC = hip
        * OR
        * dlA = shoulder
        * dlB = hip
        * dlC = ankle
        *
        * Let in ABC triangle,
                a = distance(C, B)
                b = distance(C, A)
                c = distance(A, B)
        *
        * B= arccos(a^2+c^2−b^2)/2.c.a
        */
        if (dlA == null || dlB == null || dlC == null) return -1;
        double distanceA = dlC.getEuclideanDistance(dlB);
        double distanceB = dlC.getEuclideanDistance(dlA);
        double distanceC = dlA.getEuclideanDistance(dlB);

        double theta = Math.acos((Math.pow(distanceA, 2) + Math.pow(distanceC, 2) - Math.pow(distanceB, 2)) / (2 * distanceC * distanceA));

        if (negativeAngle) return Math.round((180.0 - Math.toDegrees(theta)) * 100.0) / 100;
        return Math.round(Math.toDegrees(theta) * 100.0) / 100.0;
    }


    public static double calculateAngle3Points(ObjectDetectionState dlA, ObjectDetectionState dlB, ObjectDetectionState dlC, boolean negativeAngle) {
        return calculateAngle3Points(dlA.getDetectedLocation(), dlB.getDetectedLocation(), dlC.getDetectedLocation(), negativeAngle);
    }


    public static double clip(double in) {
        return Math.min(Math.max(in, 0), 1);
    }

    public static double clip(double in, double rad) {
        return Math.min(Math.max(in, 0 + rad), 1 - rad);
    }

    public static double clip(double in, double max, double min) {
        return Math.min(Math.max(in, min), max);
    }

    public static int convertDpToPx(Resources res, int dpVal) {
        return (int) TypedValue.applyDimension(TypedValue.COMPLEX_UNIT_DIP, dpVal, res.getDisplayMetrics());
    }

}
