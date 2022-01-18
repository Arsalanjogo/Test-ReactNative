package com.render.lottie;

import android.graphics.Color;
import android.widget.ImageView;

import com.football433.R;

public class LottieFinish extends LottieBase<LottieFinish> {

    LottieRender preload;

    public LottieFinish() {
        super(R.raw.exercise_finish);
        ephemeral(false);
        background(Color.BLACK);

        preload = createPreload();
        preload.onEnd(super::play);
    }

    @Override
    public LottieFinish play() {
        preload.play();
        return this;
    }

    private LottieRender createPreload() {
        return new LottieRender(R.raw.black_fade_in_out)
                .setScaleType(ImageView.ScaleType.FIT_XY)
                .minFrame(0).maxFrame(30)
                .speed(2.5f);
    }

}

