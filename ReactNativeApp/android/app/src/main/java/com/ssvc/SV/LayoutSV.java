package com.ssvc.SV;

import android.graphics.Canvas;
import android.view.View;

import com.loop.CustomCameraView;
import com.render.DebugText;
import com.ssvc.State;
import com.ssvc.StateObserver;
import com.views.AutoFitTextureView;

import static com.activities.GameActivity.getActivity;


public abstract class LayoutSV<S extends State> extends View implements StateObserver, StateView, DebugText {

    protected S state;

    public LayoutSV(S state) {
        super(getActivity());
        this.state = state;
        state.addObserver(this);
    }


    public void delete() {
    }


    @Override
    public void onNotify() {


    }

    public void detachFromLayoutSV() {
        if (AutoFitTextureView.getAutoFitTextureView() != null)
        AutoFitTextureView.removeLayoutSV(this);
    }


    public abstract View getView();

    @Override
    public void draw(Canvas canvas) {
        super.draw(canvas);
    }
}
