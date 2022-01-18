package com.phases.base;

import com.phases.interfaces.IContextPhaseCallBack;
import com.phases.phasemanager.PhaseManager;
import com.render.DebugText;
import com.render.sounds.SoundBase;

abstract public class Phase implements DebugText {

    protected PhaseManager.GamePhases nextPhase;
    protected PhaseManager.GamePhases prevPhase;
    protected boolean completed = false;
    protected IContextPhaseCallBack contextPhaseCallBack;

    //private Phase currentPhase;

    abstract public void process();


    abstract public boolean isDone();

    public void initialize() {

    }

    public void cleanup() {
        SoundBase.stopActivePlayers();
    }

    public void moveToPhase(PhaseManager.GamePhases phase) {

    }

    public abstract PhaseManager.GamePhases getNextPhase();

    public abstract PhaseManager.GamePhases getPrevPhase();


    @Override
    public String getDebugText() {
        return "";
    }
}
