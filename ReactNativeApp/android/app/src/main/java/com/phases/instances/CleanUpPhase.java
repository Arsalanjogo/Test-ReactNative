package com.phases.instances;

import com.activities.GameActivity;
import com.phases.base.Phase;
import com.phases.phasemanager.PhaseManager;

public class CleanUpPhase extends Phase {

    @Override
    public void initialize() {
        completed = false;

        this.prevPhase = PhaseManager.GamePhases.GAME_PHASE;
        this.nextPhase = null;

        //contextPhaseCallBack.removeGamePhase();
        GameActivity.getActivity().stop();
        completed = true;

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
    public void process() {

    }

    @Override
    public boolean isDone() {
        return completed;
    }
}