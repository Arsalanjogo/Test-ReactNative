package com.components.basic.streak;

import static com.activities.GameActivity.getActivity;

import android.graphics.Canvas;
import android.view.View;
import android.widget.TextView;

import com.activities.GameActivity;
import com.football433.R;
import com.render.lottie.LottieRender;
import com.ssvc.SV.LayoutSV;
import com.views.AutoFitTextureView;

public class StreakView extends LayoutSV<StreakState> {

    TextView tv;
    public StreakView(StreakState state) {
        super(state);
        AutoFitTextureView.addLayoutSV(this);
        setStreakCounterPosition();
    }

    private void setStreakCounterPosition() {
        GameActivity.getActivity().runOnUiThread(() -> {
            Integer screenWidth = GameActivity.getActivity().getViewBinding().streakContainer.getWidth();
            Integer screenHeight = GameActivity.getActivity().getViewBinding().streakContainer.getHeight();
            GameActivity.getActivity().getViewBinding().streakCount.setX((float) ((0.88f * screenWidth) - (GameActivity.getActivity().getViewBinding().streakCount.getWidth() / 2f)));
            GameActivity.getActivity().getViewBinding().streakCount.setY((float) ((0.88f * screenHeight) - (GameActivity.getActivity().getViewBinding().streakCount.getHeight() / 2f)));
            getActivity().getViewBinding().streakContainer.setVisibility(View.VISIBLE);
        });
    }

    private void setCounter(String count) {
        GameActivity.getActivity().getViewBinding().streakCount.setText(count);
    }

    private void updateLayout() {
        if (state.triggerStreakFlash){
            new LottieRender(R.raw.power_bar_energy).ephemeral(false).setNormalizedPosition(0.5f, 0.88f).play();
            state.triggerStreakFlash = false;
        }
    }


    @Override
    protected void onDraw(Canvas canvas) {
        super.onDraw(canvas);
        updateLayout();

        setCounter(state.streak.toString());
    }

    public void cleanUp(){
        GameActivity.getActivity().getViewBinding().getRoot().findViewById(R.id.streakContainer).setVisibility(View.INVISIBLE);
        GameActivity.getActivity().getViewBinding().streakContainer.invalidate();
    }

    @Override
    public String getDebugText() {
        return null;
    }

    @Override
    public View getView() {
        return null;
    }
}
