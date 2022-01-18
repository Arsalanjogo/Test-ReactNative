package com.components.basic.points;

import android.util.Pair;

import com.ssvc.State;

import java.util.ArrayList;

public class PointsState extends State {
    public final int defaultPoints = 0;
    public ArrayList<Pair<Integer, Long>> points = new ArrayList<>();
    public int currentPoints;
    public boolean playAnimation = false;
    public double ballX, ballY;

    public int pointChangeFactor = 1;

    protected PointsState() {
        currentPoints = defaultPoints;
    }

    public int getPoints() {
        return currentPoints;
    }

    @Override
    public String getDebugText() {
        return String.valueOf(currentPoints);
    }
}
