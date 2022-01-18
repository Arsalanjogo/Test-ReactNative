package com.utils;

import android.util.Pair;

import com.components.games.base.GameContext;

import java.net.URI;
import java.util.ArrayList;
import java.util.List;

public class ExerciseStatsJsonManager {

    private static ExerciseStatsJsonManager exerciseStatsJsonManager;

    String exerciseName;

    UtilArrayList<Long> timeStamps = new UtilArrayList();
    UtilArrayList<Integer> frames = new UtilArrayList();

    UtilArrayList<GamesEventPacket> gameEvents = new UtilArrayList<>();

    private URI exerciseJsonPath;

    private ExerciseStatsJsonManager() {
        this.exerciseName = GameContext.getContext().getGame().toString();
    }

    public static ExerciseStatsJsonManager get() {
        if (exerciseStatsJsonManager == null)
            exerciseStatsJsonManager = new ExerciseStatsJsonManager();
        return exerciseStatsJsonManager;
    }

    public void insertEvent(GamesEventPacket eventPacket) {
        gameEvents.add(eventPacket);
    }


//    public func setScoreIds(value: ScoreJson) {
//        this.scoreFrameIDs.add(value);
//    }

    private void setFrameIds(int value) {
        this.frames.add(value);
    }

    private void setTimeStamps(Long value) {
        this.timeStamps.add(value);
    }

    public void setCameraInfo(int frameId, long timeStamp) {
        this.setFrameIds(frameId);
        this.setTimeStamps(timeStamp);
    }


}
