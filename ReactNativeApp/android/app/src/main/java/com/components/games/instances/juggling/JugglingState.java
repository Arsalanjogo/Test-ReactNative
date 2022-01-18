package com.components.games.instances.juggling;

import com.ssvc.State;

public class JugglingState extends State {


    public final int BALL_COOL_DOWN = 0; // how many frames the ball should touch the groundline before we reset the jugglingcounter
    public final int FOOT_DETECT_RANGE = 15;
    public final int GROUND_LINE_TOUCHED_COOL_DOWN = 5;
    public final boolean stillJuggling = true;
    public double KNEE_LINE_ADJUSTMENT = 0.35;
    public int BALL_ON_GROUND_COUNTER = 1; // How many times we skip searching for a bounce after the ball has touched the ground
    public int determineBounceRange;

    //the lastBounceID is used to keep track of what the last analyzed frame is, to ensure we only count a juggle once
    public int lastBounceID = 0;
    public int determineBounceStartID = 0;
    public double groundLine;
    public double kneeLine;
    public double leftKneeLoc;
    public double rightKneeLoc;
    public double rightAnkleY, leftAnkleY; // for motion detection
    public boolean bounce = false;

    public int count = 0;


    @Override
    public String getDebugText() {
        return "JugglingState";
    }
}
