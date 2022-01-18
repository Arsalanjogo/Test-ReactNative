package com.render.lottie;

import com.football433.R;

public class LottieTimerCountDown extends LottieBase<LottieTimerCountDown> {

    public LottieTimerCountDown() {
        super(R.raw.timer_count_down);
        setNormalizedPosition(0.5f, 0.5f);
        setScale(0.6f, 0.6f);
        speed(1.2f);
    }


}
