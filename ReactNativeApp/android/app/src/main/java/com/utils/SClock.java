package com.utils;

import android.os.SystemClock;
import android.util.Pair;

import com.logger.SLOG;

import java.util.ArrayList;
import java.util.List;
import java.util.TimerTask;


public class SClock {
    List<Pair<Long, Runnable>> scheduler = new ArrayList<>();
    List<TimerTask> timerTasks = new ArrayList<>();
    STimer timer;
    private long elapsedTime = 0;
    private long startTime = 0;
    private boolean running = false;

    public SClock(STimer sTimer) {
        this.timer = sTimer;
    }

    public long getElapsed() {
        return elapsedTime;
    }

    public boolean isRunning() {
        return running;
    }

    public void start() {
        if (!running) {
            startTime = SystemClock.elapsedRealtime();
            //remove already executed
            scheduler.removeIf(p -> elapsedTime > p.first);
            SLOG.d("scheduling:" + scheduler);
            scheduler.forEach(p -> timerTasks.add(timer.schedule(p.second, p.first - elapsedTime)));
            running = true;
        }
    }

    public void stop() {
        if (running) {
            timerTasks.forEach(TimerTask::cancel);
            timerTasks.clear();
            elapsedTime = SystemClock.elapsedRealtime() - startTime + elapsedTime;
            running = false;

        }
    }

    public void scheduleOnTime(long time, final Runnable r) {
        scheduler.add(new Pair<>(time, r));
        if (running) timerTasks.add(timer.schedule(r, time - elapsedTime));
        if (time < elapsedTime)
            throw new IllegalStateException("time" + time + " has already passed:"); //todo lets see if this revoles it!!! check back again pose-scan!
    }


}
