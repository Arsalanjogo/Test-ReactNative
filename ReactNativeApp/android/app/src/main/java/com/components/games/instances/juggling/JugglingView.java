package com.components.games.instances.juggling;

import android.graphics.Canvas;
import android.view.View;

import com.components.detection.ball.BallDetectionState;
import com.loop.CustomCameraView;
import com.ssvc.SV.LayoutSV;
import com.views.AutoFitTextureView;

public class JugglingView extends LayoutSV<JugglingState> {
    // todo inherit from another class (BaseGameView), there will add the render base logic like plus one.

    private final BallDetectionState ballState;

    public JugglingView(JugglingState state, BallDetectionState ballDetectionState) {
        super(state);
        this.ballState = ballDetectionState;
        AutoFitTextureView.addLayoutSV(this);
    }

    public void draw(Canvas canvas) {
        super.draw(canvas);

        // todo, how the hell i trigger plus one animation.
        // todo need point state access too here. what the hell!!!!

    }


    @Override
    public View getView() {
        return null;
    }

    @Override
    public String getDebugText() {
        return "JugglingView";
    }
}
