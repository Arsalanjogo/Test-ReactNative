package com.phases.instances;

import android.graphics.Color;

import com.football433.R;
import com.phases.base.Phase;
import com.phases.phasemanager.PhaseManager;
import com.render.lottie.LottieRender;

public class PromoPhase extends Phase {

    @Override
    public void initialize() {
        this.prevPhase = PhaseManager.GamePhases.CONTEXT_INITIALIZATION_PHASE;
        this.nextPhase = PhaseManager.GamePhases.CALIBRATION_PHASE;

        new LottieRender(R.raw.getinpos).background(Color.BLACK).setScaleXY(1.5)
                .onEnd(() -> completed = true)
                .play();
    }

    @Override
    public void process() {
    }

    @Override
    public boolean isDone() {
        return completed;
    }


    @Override
    public void cleanup() {
        super.cleanup();
    }

    @Override
    public PhaseManager.GamePhases getNextPhase() {
        return this.nextPhase;
    }

    @Override
    public PhaseManager.GamePhases getPrevPhase() {
        return this.prevPhase;
    }

    @Override
    public String getDebugText() {
        return "";
    }
}
