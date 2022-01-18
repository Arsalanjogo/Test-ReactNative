package com.render.lottie;

import com.airbnb.lottie.LottieAnimationView;

public class LottieCounter extends LottieBase<LottieCounter> {

    public LottieCounter(LottieAnimationView animationView) {
        super(0, animationView);
        this.ephemeral(false).setScale(10,10).setNormalizedPosition(0.3,0.3).play();

    }
}
