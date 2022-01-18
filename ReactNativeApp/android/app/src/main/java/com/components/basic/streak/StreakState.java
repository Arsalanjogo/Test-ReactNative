package com.components.basic.streak;

import static java.lang.Math.max;
import static java.lang.Math.min;

import com.ssvc.State;

public class StreakState extends State {

    Integer BASE_MULTIPLIER = 1;
    Integer BASE_EVENTS = 12;
    Integer MAX_EVENTS = 30;

    public boolean triggerStreakFlash = false;

    Integer streak = 1;
    Integer eventsInCurrrentStreak = 0;
    Integer eventIncrementValue = 1;
    Integer eventDecrementValue = 3;

    Integer eventMultiplier() {

        return  (this.streak - BASE_MULTIPLIER) * 2;

    }

    Integer eventsPerStreak () {

            return min(BASE_EVENTS + eventMultiplier(), MAX_EVENTS);

    }

    @Override
    public String getDebugText() {
        return null;
    }
}
