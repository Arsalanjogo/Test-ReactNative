package com.components.basic.points;

import android.util.Pair;
import android.widget.ImageView;

import com.football433.R;
import com.render.lottie.LottieRender;
import com.render.sounds.SoundRender;
import com.ssvc.Controller;

public class PointsController extends Controller<PointsState> {

    public PointsController(PointsState state) {
        super(state);

    }

    public int getCurrentPoint() {
        return state.getPoints();
    }


    private void setPointsInternal(int amount, boolean blink) {
        state.points.add(new Pair<>(amount, System.currentTimeMillis()));
        state.currentPoints = amount;
        state.playAnimation = blink;

        if (state.getPoints() == 21){
            new LottieRender(R.raw.twenty_points_new).ephemeral(false).speed(0.5f).setScaleType(ImageView.ScaleType.FIT_XY).play();;

        }
    }

    public void addPoints(double x, double y) {
        addPoints(1, x, y);
    }

    public void addPoints(int points, double x, double y) {
        state.ballX = x;
        state.ballY = y;
        addPoints(points, true, true);
    }

    public void addPoints(int value) {
        addPoints(value, true, true);
    }

    public void addPoints(int value, boolean blink, boolean beep) {
        if (beep) new SoundRender(R.raw.score_count).play();
        state.pointChangeFactor = value;
        setPointsInternal(value + state.getPoints(), blink);
    }


    public void decrementPoints() {
        decrementPoints(1, true, true);
    }

    public void decrementPoints(int value, boolean blink, boolean beep) {
        if (beep) new SoundRender(R.raw.error_433).play();
        setPointsInternal(Math.max(state.getPoints() - value, 0), blink);
    }

    public void resetPoints() {
        resetPoint(true, true);
    }

    public void resetPoint(boolean blink, boolean beep) {
        if (beep) new SoundRender(R.raw.jogo_cone_error).play();
        setPointsInternal(state.defaultPoints, blink);
    }


    @Override
    public String getDebugText() {
        return "";
    }
}
