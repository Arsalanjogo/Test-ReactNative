package com.phases.instances;

import com.components.basic.points.PointsBuilder;
import com.components.basic.points.PointsController;
import com.components.basic.points.PointsState;
import com.components.basic.points.PointsView;
import com.components.basic.streak.StreakBuilder;
import com.components.basic.streak.StreakController;
import com.components.basic.streak.StreakState;
import com.components.basic.streak.StreakView;
import com.components.basic.timer.TimerBuilder;
import com.components.basic.timer.TimerController;
import com.components.basic.timer.TimerState;
import com.components.basic.timer.TimerView;
import com.phases.base.Phase;
import com.phases.phasemanager.PhaseManager;
import com.ssvc.SSVC;

public class GamePhase extends Phase {

    protected SSVC<PointsState, PointsView, PointsController> points;
    protected SSVC<TimerState, TimerView, TimerController> timer;
    protected SSVC<StreakState, StreakView, StreakController> streak;


    @Override
    public void initialize() {
        this.prevPhase = PhaseManager.GamePhases.CALIBRATION_PHASE;
        this.nextPhase = PhaseManager.GamePhases.END_OF_EXERCISE_PHASE;
        points = PointsBuilder.buildPoints();
        timer = TimerBuilder.buildTimer();
        streak = StreakBuilder.build();
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
        return !timer.state.running && timer.state.finished;
    }


    private void timerCleanUp() {
        timer.state.cleanUp();
        timer.controller.stopCountDownTimer();
        timer.stateView.cleanUp();
        timer.stateView.detachFromLayoutSV();
    }

    public void cleanup() {
        super.cleanup();
        timerCleanUp();
        points.stateView.cleanUp();
        streak.controller.cleanUp();
        streak.stateView.cleanUp();

    }

}
