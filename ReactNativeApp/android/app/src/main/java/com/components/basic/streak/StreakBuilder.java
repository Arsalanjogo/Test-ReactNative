package com.components.basic.streak;

import com.ssvc.SSVC;
import com.ssvc.SSVCBuilder;

public class StreakBuilder extends SSVCBuilder {

    static private StreakState buildState() {
        return new StreakState();
    }

    public static SSVC<StreakState, StreakView, StreakController> build() {
        StreakState state = buildState();
        StreakView streakView = new StreakView(state);
        StreakController pointsController = new StreakController(state);
        return new SSVC<>(state, streakView, pointsController);
    }

}
