package com.views;

import android.content.Context;
import android.graphics.Canvas;
import android.util.AttributeSet;

import com.airbnb.lottie.LottieAnimationView;

public class RedrawLottie extends LottieAnimationView {
    public RedrawLottie(Context context) {
        super(context);
    }

    public RedrawLottie(Context context, AttributeSet attrs) {
        super(context, attrs);
    }

    public RedrawLottie(Context context, AttributeSet attrs, int defStyleAttr) {
        super(context, attrs, defStyleAttr);
    }


    @Override
    protected void onDraw(Canvas canvas) {
        super.onDraw(canvas);
        if (getDrawable() != null)
            getDrawable().invalidateSelf();
    }
}
