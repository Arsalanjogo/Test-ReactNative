package com.components.basic.timer;


import android.annotation.SuppressLint;
import android.os.CountDownTimer;

import com.activities.GameActivity;
import com.ssvc.State;
import com.utils.STimer;

import java.util.concurrent.TimeUnit;


public class TimerState extends State {

    private final int COUNT_DOWN_INTERVAL = 1000;
    public STimer sTimer;
    public long startTime;
    public boolean running;
    public boolean finished = false;
    public long gameTime ;
    public int timeProgressBarLength;
    public double timerPercentage;
    public String timeText = "00:00";

    CountDownTimer cTimer;

    public TimerState() {
        //gameTime = GameContext.getContext().getGameDuration();
        gameTime = 45000;
        initializeTimer();
        sTimer = new STimer(false);
        running = true;
    }


    void initializeTimer() {
        GameActivity.getActivity().runOnUiThread(() -> {
            cTimer = new CountDownTimer(gameTime, COUNT_DOWN_INTERVAL) {

                @SuppressLint("DefaultLocale")
                public void onTick(long millis) {
                    timeText = String.format("%02d:%02d",
                            TimeUnit.MILLISECONDS.toMinutes(millis) % TimeUnit.HOURS.toMinutes(1),
                            TimeUnit.MILLISECONDS.toSeconds(millis) % TimeUnit.MINUTES.toSeconds(1));
                }

                public void onFinish() {
                    cancelTimer();
                    finished = true;
                }

            };
            cTimer.start();
        });

    }

    public void cleanUp() {
        sTimer.cancel();
        cancelTimer();
    }

    public void cancelTimer() {
        running = false;
        if (cTimer != null) {
            cTimer.cancel();
        }
    }


    @Override
    public String getDebugText() {
        return "TimerState";
    }
}
