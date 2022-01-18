package com.components.basic.timer;

import com.ssvc.SSVC;
import com.ssvc.SSVCBuilder;

public class TimerBuilder extends SSVCBuilder {

    public static SSVC<TimerState, TimerView, TimerController> buildTimer() {
        TimerState state = new TimerState();
        TimerView timerView = new TimerView(state);
        TimerController timerController = new TimerController(state);

        return new SSVC<>(state, timerView, timerController);
    }


}
