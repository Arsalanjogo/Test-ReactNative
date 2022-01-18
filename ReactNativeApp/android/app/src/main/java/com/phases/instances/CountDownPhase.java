package com.phases.instances;

import com.activities.GameActivity;
import com.football433.R;
import com.phases.base.Phase;
import com.phases.phasemanager.PhaseManager;
import com.render.lottie.LottieRender;
import com.render.sounds.SoundRender;


public class CountDownPhase extends Phase {

    @Override
    public void initialize() {
        completed = false;
        this.prevPhase = PhaseManager.GamePhases.CALIBRATION_PHASE;
        this.nextPhase = PhaseManager.GamePhases.GAME_PHASE;
        GameActivity.getActivity().hideButtons();
        new LottieRender(R.raw.count_down_vsix).onEnd(() -> completed = true).onStart(this::startSound).setScaleXY(2.0).play();
    }


    @Override
    public void process() {

    }

    private void startSound() {
        new SoundRender(R.raw.count_down_433).play();
    }

    @Override
    public boolean isDone() {
        return completed;
    }

    @Override
    public void cleanup() {
        super.cleanup();
        GameActivity.getActivity().showButtons();
    }

    @Override
    public PhaseManager.GamePhases getNextPhase() {
        return this.nextPhase;
    }

    @Override
    public PhaseManager.GamePhases getPrevPhase() {
        return this.prevPhase;
    }
}
