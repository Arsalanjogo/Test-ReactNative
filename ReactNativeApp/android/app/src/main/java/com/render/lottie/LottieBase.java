package com.render.lottie;

import android.animation.Animator;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.LinearLayout;

import com.activities.GameActivity;
import com.airbnb.lottie.LottieAnimationView;
import com.airbnb.lottie.LottieDrawable;
import com.airbnb.lottie.RenderMode;
import com.football433.R;
import com.football433.databinding.ExerciseViewBinding;
import com.utils.interfaces.NoArgMethod;

import java.util.ArrayList;
import java.util.List;


public class LottieBase<T extends LottieBase<T>> {

    private static int screenWidth = 0;
    private static int screenHeight = 0;
    protected final GameActivity activity;
    private final List<NoArgMethod> onStart = new ArrayList<>();
    private final List<NoArgMethod> onEnd = new ArrayList<>();
    private final List<NoArgMethod> onCancel = new ArrayList<>();
    private final List<NoArgMethod> onRepeat = new ArrayList<>();
    public int animationName;
    LottieAnimationView animationContainer;
    ExerciseViewBinding viewBinding;
    private boolean ephemeral = true;
    private boolean running = false;

    protected LottieBase(int animationName, LottieAnimationView targetView) {
        this.activity = GameActivity.getActivity();
        viewBinding = GameActivity.getActivity().getViewBinding();

        //make sure the screenwidth is set for normalized position
        // lavContainer = activity.findViewById(R.id.lavContainer);
        if (screenWidth == 0) viewBinding.lavContainer.post(this::initWidth);

        if (targetView == null) targetView = getAndCreateContainer();
        animationContainer = targetView;

        this.animationName = animationName;
        this.animationContainer.setRenderMode(RenderMode.HARDWARE);

        if (animationName != 0) animationContainer.setAnimation(animationName);
        animationContainer.setAdjustViewBounds(true);
        setAnimationListeners();

    }


    public LottieBase(int animationName) {
        this(animationName, null);
    }


    public int getAnimationName() {
        return animationName;
    }

    protected final LottieAnimationView getAndCreateContainer() {
        LottieAnimationView lottieAnimationView = new LottieAnimationView(activity);
        lottieAnimationView.setId(LottieAnimationView.generateViewId());

        final LinearLayout.LayoutParams params = new LinearLayout.LayoutParams(LinearLayout.LayoutParams.MATCH_PARENT,
                ViewGroup.LayoutParams.MATCH_PARENT);

        lottieAnimationView.setLayoutParams(params);
        lottieAnimationView.setVisibility(View.INVISIBLE);
//        lottieAnimationView.

//        LayoutInflater vi = (LayoutInflater) eActivity.getApplicationContext().getSystemService(Context.LAYOUT_INFLATER_SERVICE);
//        View v = vi.inflate(R.layout.basic_exercise_view, null);

        ViewGroup insertPoint = activity.findViewById(R.id.lavContainer);

        activity.runOnUiThread(() ->
                insertPoint.addView(lottieAnimationView));

        return lottieAnimationView;

    }

    public T setLayout(int l, int t, int r, int b) {
        animationContainer.layout(l, t, r, b);
        return (T) this;
    }

    public float getWidth() {
        return animationContainer.getWidth();
    }

    public float getX() {
        return animationContainer.getX();
    }

    public float getY() {
        return animationContainer.getY();
    }

    public float getHeight() {
        return animationContainer.getHeight();
    }

    public T setScaleType(ImageView.ScaleType scaleType) {
        activity.runOnUiThread(() -> animationContainer.setScaleType(scaleType));
        return (T) this;
    }


    public T wrapContent() {
        ViewGroup.LayoutParams layoutParams = animationContainer.getLayoutParams();
        layoutParams.width = ViewGroup.LayoutParams.WRAP_CONTENT;
        layoutParams.height = ViewGroup.LayoutParams.WRAP_CONTENT;
        animationContainer.setLayoutParams(layoutParams);
        return (T) this;
    }


    protected void runningCheck() {
        if (running && ephemeral)
            throw new IllegalStateException("Cannot set methods on ephemeral animation after running");
    }

    private void initWidth() {
        if (screenWidth == 0) {
            screenWidth = viewBinding.lavContainer.getWidth();
            screenHeight = viewBinding.lavContainer.getHeight();
        }
    }

    public T setNormalizedPosition(double x, double y) {
        runningCheck();
        animationContainer.post(() -> {
            //we use the scale, because scaleX is a viewport transformation that does not update the area,
            initWidth();
            animationContainer.setX((float) ((x * screenWidth) - (animationContainer.getWidth() / 2f)));
            animationContainer.setY((float) ((y * screenHeight) - (animationContainer.getHeight() / 2f)));
        });
        return (T) this;
    }


    public T setNormalizedLayout(double l, double t, double r, double b) {
        runningCheck();
        animationContainer.post(() ->
                animationContainer.layout((int) (l * screenWidth), (int) (t * screenHeight), (int) (r * screenWidth), (int) (b * screenHeight)));
        return (T) this;
    }


    public T loop() {
        this.animationContainer.setRepeatCount(LottieDrawable.INFINITE);
        return (T) this;
    }


    public T setScale(float x, float y) {
        runningCheck();
        animationContainer.setScaleX(x);
        animationContainer.setScaleY(y);
        return (T) this;
    }

    public T setScale(double x, double y) {
        return setScale((float) x, (float) y);
    }

    public T setScaleX(float x) {
        runningCheck();
        animationContainer.setScaleX(x);
        return (T) this;
    }

    public T setScaleXY(double scaleFactor) {
        return setScale((float) scaleFactor, (float) scaleFactor);
    }

    public T ephemeral(boolean ephemeral) {
        runningCheck();
        this.ephemeral = ephemeral;
        return (T) this;
    }

    public float getMinFrame(){
        runningCheck();
        return animationContainer.getMinFrame();
    }

    public T minFrame(Integer minFrame) {
        runningCheck();
        animationContainer.setMinFrame(minFrame);
        return (T) this;
    }

    public T maxFrame(Integer maxFrame) {
        runningCheck();
        animationContainer.setMaxFrame(maxFrame);
        return (T) this;
    }

    public T minMaxFrame(int minframe, int maxFrame) {
        animationContainer.setMinAndMaxFrame(minframe, maxFrame);
        return (T) this;
    }

    public T goToFrame(int frame) {
        animationContainer.setMinAndMaxFrame(frame, frame);
        return (T) this;
    }

    public T setPosition(float pos) {
        runningCheck();
        animationContainer.setX(pos);
        return (T) this;
    }

    public T setZ(float z) {
        runningCheck();
        animationContainer.setZ(z);
        return (T) this;
    }


    public T background(int color) {
        runningCheck();
        onStart(() -> animationContainer.setBackgroundColor(color));
        return (T) this;
    }


    public int getFrame() {
        return animationContainer.getFrame();
    }

    public T setFrame(int frame) {
        animationContainer.setFrame(frame);
        return (T) this;
    }

    public float getMaxFrame() {
        return animationContainer.getMaxFrame();
    }

    public float getProgress() {
        return animationContainer.getProgress();
    }

    public T play() {
        runningCheck();
        running = true;
        activity.runOnUiThread(() -> {
            this.animationContainer.setVisibility(View.VISIBLE);
            this.animationContainer.playAnimation();
        });
        return (T) this;
    }

    public T resume() {
        runningCheck();
        activity.runOnUiThread(this.animationContainer::resumeAnimation);
        return (T) this;
    }

    public T pause() {
        runningCheck();
        activity.runOnUiThread(this.animationContainer::pauseAnimation);
        return (T) this;
    }

    public T onStart(NoArgMethod onStart) {
        runningCheck();
        this.onStart.add(onStart);
        return (T) this;
    }

    public T onRepeat(NoArgMethod onRepeat) {
        runningCheck();
        this.onRepeat.add(onRepeat);
        return (T) this;
    }

    public T onEnd(NoArgMethod onEnd) {
        runningCheck();
        this.onEnd.add(onEnd);
        return (T) this;
    }

    public T addAnimationUpdateListener(NoArgMethod onUpdate, int frame) {
        runningCheck();
        this.animationContainer.addAnimatorUpdateListener((valueAnimator) -> {
            if (getFrame() == frame)
                onUpdate.run();
        });
        return (T) this;
    }

    protected final void setAnimationListeners() {
        animationContainer.addAnimatorListener(new Animator.AnimatorListener() {
            @Override
            public void onAnimationStart(Animator animation) {
                if (onStart != null) onStart.forEach(NoArgMethod::run);
            }

            @Override
            public void onAnimationEnd(Animator animation) {
                if (onEnd != null) onEnd.forEach(NoArgMethod::run);
                if (ephemeral) cleanup();
            }

            @Override
            public void onAnimationCancel(Animator animation) {
                if (onCancel != null) onCancel.forEach(NoArgMethod::run);
                animationContainer.clearAnimation();
                // the cleanUp would result in crash sometimes.
            }

            @Override
            public void onAnimationRepeat(Animator animation) {
                if (onRepeat != null) onRepeat.forEach(NoArgMethod::run);
            }
        });
    }

    private void cleanup() {
        animationContainer.clearAnimation();
        activity.runOnUiThread(() -> {
            if (animationContainer != null && animationContainer.getParent() != null) //NPE can be thrown through a race condition
                ((ViewGroup) animationContainer.getParent()).removeView(animationContainer);
        });
    }


    public void delete() {
        cleanup();
    }

    public T clear() {
        animationContainer.clearAnimation();
        return (T) this;
    }

    public void hideAnimation() {
        activity.runOnUiThread(() -> animationContainer.setVisibility(View.INVISIBLE));
    }

    public void showAnimation() {
        activity.runOnUiThread(() -> animationContainer.setVisibility(View.VISIBLE));
    }

    public T speed(float speed) {
        this.animationContainer.setSpeed(speed);
        return (T) this;
    }


    public void showUI() {
        //callback target
        // viewBinding.containerScore.setAlpha(1);
    }

    public T rotation(float rotate) {
        this.animationContainer.setRotation(rotate);
        return (T) this;
    }

    public T progress(float min, float max) {
        this.animationContainer.setMinAndMaxProgress(min, max);
        return (T) this;
    }

    public T hide() {
        //this will also stop playing the animation
        animationContainer.setVisibility(View.INVISIBLE);
        return (T) this;
    }

    public T showAnimationContainer() {
        //this will also start playing the animation

        animationContainer.setVisibility(View.VISIBLE);
        return (T) this;
    }

    public T setRenderMode(RenderMode renderMode) {
        animationContainer.setRenderMode(renderMode);
        return (T) this;
    }

}
