package com.components.basic.points;

import static com.activities.GameActivity.getActivity;

import android.content.Context;
import android.graphics.Canvas;
import android.view.LayoutInflater;
import android.view.View;

import android.widget.RelativeLayout;

import com.football433.R;
import com.football433.databinding.ScoreViewBinding;
import com.render.lottie.LottieRender;
import com.ssvc.SV.LayoutSV;
import com.utils.SMath;
import com.views.AutoFitTextureView;

import java.util.Locale;


public class PointsView extends LayoutSV<PointsState> {

    private ScoreViewBinding scoreViewBinding; // todo is this even required now?
    private View layout;
    LottieRender powerBarBase;

    public PointsView(PointsState state) {
        super(state);
        initialize();
        AutoFitTextureView.addLayoutSV(this);
    }

    @Override
    public View getView() {
        return this.layout;
    }

    private void initialize() {
        //Inflate the layout
        LayoutInflater layoutInflater = (LayoutInflater) getContext().getSystemService(Context.LAYOUT_INFLATER_SERVICE);
        scoreViewBinding = ScoreViewBinding.inflate(layoutInflater);

        //Set the layout view
        layout = scoreViewBinding.getRoot();
        layout.setDrawingCacheEnabled(true);

        //Setup Layout Parameters
        RelativeLayout.LayoutParams scoreLayoutParameters = new RelativeLayout.LayoutParams(RelativeLayout.LayoutParams.WRAP_CONTENT, RelativeLayout.LayoutParams.WRAP_CONTENT);
        //As margins are in px so convert dp to px

        int margin10Dp = SMath.convertDpToPx(getActivity().getResources(), 15);

        scoreLayoutParameters.setMargins(margin10Dp, margin10Dp, 0, 0);
        scoreLayoutParameters.addRule(RelativeLayout.ALIGN_TOP,R.id.score_timer_bg);
        scoreLayoutParameters.addRule(RelativeLayout.ALIGN_START,R.id.score_timer_bg);

        layout.setLayoutParams(scoreLayoutParameters);
        powerBarBase = new LottieRender(R.raw.power_bar_base).ephemeral(false).setNormalizedPosition(0.5f, 0.88f).play();


    }

    private void updateScoreLayout() {
        String points = String.format(Locale.ENGLISH, "%02d", state.getPoints());

        //Update points value
        getActivity().runOnUiThread(() -> {
            scoreViewBinding.score.setText(points);
        });

    }

    private void playFloatingPointAnimation(){

        if (state.pointChangeFactor >= 4) return;

        int animationName = R.raw.score_plus_one;

        if (state.pointChangeFactor == 2){
            animationName = R.raw.score_plus_two;
        }

        if (state.pointChangeFactor == 3){
            animationName = R.raw.score_plus_three;
        }

        new LottieRender(animationName).ephemeral(false).setNormalizedPosition(state.ballX, state.ballY).setScaleXY(0.3).play();;
    }

    public void cleanUp() {
        super.detachFromLayoutSV();
        powerBarBase.delete();
    }


    @Override
    protected void onDraw(Canvas canvas) {
        super.onDraw(canvas);
        updateScoreLayout();
    }

    @Override
    public void detachFromLayoutSV() {
        super.detachFromLayoutSV();
    }


    @Override
    public String getDebugText() {
        return "";
    }

}
