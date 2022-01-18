package com.logger;

import android.os.SystemClock;
import android.util.Log;

public class Timer {

    long startTime = SystemClock.elapsedRealtime();
    long lastSplit = SystemClock.elapsedRealtime();
    String TAG;
    int frameID;

    public Timer(String tag, String text) {
        TAG = tag;
        Log.d("JOGO-" + TAG, "BEGIN: " + text);
    }

    public Timer(String method_name_tag) {
        TAG = method_name_tag;
    }

    public Timer(int frameID) {
        this.frameID = frameID;
    }

    public int getFrameID() {
        return frameID;
    }

    public void end(int frameID) {
        Log.d(TAG, (SystemClock.elapsedRealtime() - startTime) + "ms" + " for FrameId " + frameID);
    }

    public void addSplit(String text) {
        Log.d("JOGO-" + TAG, "[ " + (SystemClock.elapsedRealtime() - lastSplit) + "ms ] " + text);
        lastSplit = SystemClock.elapsedRealtime();
    }

    public void end() {
        Log.d("JOGO-" + TAG, "END [ " + (SystemClock.elapsedRealtime() - startTime) + "ms ]");
    }

    public long getTime() {
        return SystemClock.elapsedRealtime() - startTime;
    }

}
