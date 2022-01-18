package com.components.detection.ball;

import android.graphics.Canvas;
import android.graphics.Paint;
import android.view.View;

import com.components.games.base.GameContext;
import com.location.DetectionLocation;
import com.ssvc.SV.LayoutSV;
import com.utils.Gear;
import com.utils.Paint443;
import com.views.AutoFitTextureView;

public class BallDetectionView extends LayoutSV<BallDetectionState> {
    public BallDetectionView(BallDetectionState state) {
        super(state);
        AutoFitTextureView.addLayoutSV(this);
    }

    @Override
    public View getView() {
        return null;
    }


    public void draw(Canvas canvas) {
        super.draw(canvas);
        DetectionLocation ballLocation = state.getLocation();
        if (ballLocation == null || !ballLocation.locationKnown()) return;
        Paint443 paint = new Paint443().largeStroke();
        canvas.drawCircle((float) ballLocation.getX() * canvas.getWidth(), (float) ballLocation.getY() * canvas.getHeight(), (float) Math.max((state.width * canvas.getWidth()), (state.height * canvas.getHeight())),
                GameContext.getContext().ball.state.isCalibrated ? paint.yellow433() : paint.red());

        //can be overridden if required
    }

    public void drawDebug(Canvas canvas) {
        DetectionLocation ballLocation = state.getLocation();
        if (ballLocation == null || !ballLocation.locationKnown()) return;
        Paint paint = new Paint443().yellow433().largeStroke();
        canvas.drawCircle((float) ballLocation.getX() * canvas.getWidth(), (float) ballLocation.getY() * canvas.getHeight(), (float) Math.max((state.width * canvas.getWidth()), (state.height * canvas.getHeight())), paint);

        if (Gear.iff("bounce", true) && state.low1pt != null && state.low2pt != null && state.highPt != null) {
            canvas.drawCircle(state.low1pt.canvX(canvas), state.low1pt.canvY(canvas), (float) 0.03 * canvas.getWidth(), new Paint443().fillStroke().yellow());
            canvas.drawCircle(state.low2pt.canvX(canvas), state.low2pt.canvY(canvas), (float) 0.03 * canvas.getWidth(), new Paint443().fillStroke().yellow());
            canvas.drawCircle(state.highPt.canvX(canvas), state.highPt.canvY(canvas), (float) 0.03 * canvas.getWidth(), new Paint443().fillStroke().red());
        }
    }

    @Override
    public String getDebugText() {
        return "";
    }
}
