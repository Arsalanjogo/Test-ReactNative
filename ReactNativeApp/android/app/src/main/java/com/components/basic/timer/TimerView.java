package com.components.basic.timer;

import static com.activities.GameActivity.getActivity;

import android.content.Context;
import android.graphics.Canvas;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.RelativeLayout;

import com.activities.GameActivity;
import com.football433.R;
import com.football433.databinding.TimerViewBinding;
import com.ssvc.SV.LayoutSV;
import com.utils.SMath;
import com.views.AutoFitTextureView;

public class TimerView extends LayoutSV<TimerState> {

    public TimerViewBinding timerViewBinding;
    public View layout;
    private View scoreTimerBgView;

    public TimerView(TimerState state) {
        super(state);
        initialize();

        //Set score timer bg to be visible
        scoreTimerBgView =  getActivity().findViewById(R.id.score_timer_bg);
        getActivity().runOnUiThread(() -> {scoreTimerBgView.setVisibility(VISIBLE);});

        AutoFitTextureView.addLayoutSV(this);
    }


    @Override
    public View getView() {
        return layout;
    }


    @Override
    public String getDebugText() {
        return null;
    }


    @Override
    public void draw(Canvas canvas) {
        super.draw(canvas);
        if (state.running) {   // todo This might be a problem if chronometer is paused for some reason.
            GameActivity.getActivity().runOnUiThread(() -> {
                if (timerViewBinding != null) // inflation might not have been done when control reaches to this point.
                    timerViewBinding.timerTxt.setText(state.timeText);
            });
        }
    }


    public void initialize() {

        LayoutInflater layoutInflater = (LayoutInflater) getActivity().getApplicationContext().getSystemService(Context.LAYOUT_INFLATER_SERVICE);
        timerViewBinding = TimerViewBinding.inflate(layoutInflater);

        layout = timerViewBinding.getRoot();

        //Setup Layout Parameters
        RelativeLayout.LayoutParams scoreLayoutParameters = new RelativeLayout.LayoutParams(RelativeLayout.LayoutParams.WRAP_CONTENT, RelativeLayout.LayoutParams.WRAP_CONTENT);

        //as layout parameter only accepts px
        int marginLeftDp = SMath.convertDpToPx(getActivity().getResources(), 110);
        int margin25Dp = SMath.convertDpToPx(getActivity().getResources(), 30);
        int margin15Dp = SMath.convertDpToPx(getActivity().getResources(), 15);

        scoreLayoutParameters.setMargins(marginLeftDp, margin25Dp, margin15Dp, 0);
        scoreLayoutParameters.addRule(RelativeLayout.ALIGN_TOP,R.id.score_timer_bg);
        scoreLayoutParameters.addRule(RelativeLayout.ALIGN_START,R.id.score_timer_bg);
        layout.setLayoutParams(scoreLayoutParameters);

        timerViewBinding.timerTxt.setVisibility(View.VISIBLE);

    }


    public void cleanUp(){
        detachFromLayoutSV();
        GameActivity.getActivity().runOnUiThread(() -> {
            timerViewBinding.timerTxt.setVisibility(View.GONE);
        });

        getActivity().runOnUiThread(() -> {scoreTimerBgView.setVisibility(INVISIBLE);});
    }


}
