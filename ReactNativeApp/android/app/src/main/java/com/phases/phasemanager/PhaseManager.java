package com.phases.phasemanager;

import static com.utils.Profiling.PROFILING_STATUS;

import android.util.Log;

import com.activities.GameActivity;
import com.components.games.base.GameContext;
import com.football433.NativeBridge;
import com.logger.SLOG;
import com.loop.GameLoop;
import com.phases.base.Phase;
import com.phases.games.GameSelector;
import com.phases.instances.CalibrationPhase;
import com.phases.instances.CleanUpPhase;
import com.phases.instances.ContextInitializationPhase;
import com.phases.instances.CountDownPhase;
import com.phases.instances.EndOfGamePhase;
import com.phases.instances.GamePhase;
import com.phases.instances.PromoPhase;
import com.phases.interfaces.IContextPhaseCallBack;
import com.utils.Profiling;
import com.utils.STimer;

import java.util.HashMap;

public class PhaseManager implements IContextPhaseCallBack {

    public static STimer timer;
    private final GamePhases initialPhase = GamePhases.CONTEXT_INITIALIZATION_PHASE;
    public Phase currentPhase;
    HashMap<GamePhases, Phase> phases = new HashMap<>();
    private boolean isStarted = false;
    private GameLoop gameLoop;

    public PhaseManager() {
        setupEnvironment();
        setupPhases();
    }

    protected void setupEnvironment() {
        timer = new STimer(false);
        gameLoop = new GameLoop();
        gameLoop.addTarget(this::process);
        if (NativeBridge.isDebug()) gameLoop.addTarget(this::debugLog);
        //TODO: we should attach a render target somewhere
    }

    private void startLoggingStatistics() {
        Profiling.profilingStart(PROFILING_STATUS, GameContext.currentGlobalFrameID);
        Profiling.monitorTemperature();
        Profiling.monitorHeapMemory(GameContext.currentGlobalFrameID);
        Profiling.getCurrentRamStatus( GameContext.currentGlobalFrameID,GameActivity.getActivity().getApplicationContext());
    }

    public void setupPhases() {
        phases.put(GamePhases.CONTEXT_INITIALIZATION_PHASE, new ContextInitializationPhase(this));
        phases.put(GamePhases.PROMO_PHASE, new PromoPhase());
        phases.put(GamePhases.CALIBRATION_PHASE, new CalibrationPhase());
        phases.put(GamePhases.COUNTDOWN_PHASE, new CountDownPhase());
        phases.put(GamePhases.END_OF_EXERCISE_PHASE, new EndOfGamePhase());
        phases.put(GamePhases.CLEANUP_PHASE, new CleanUpPhase());
    }

    public void isDone() {
        this.currentPhase.isDone();
    }

    private void initiate() {
        if (currentPhase == null)
            incorrectPhase(initialPhase);
        currentPhase.initialize();
        gameLoop.start();
        isStarted = true;
    }

    public void restart() {
        stop();
        currentPhase = phases.get(GamePhases.CALIBRATION_PHASE);
        initiate();
    }

    public void start() {
        currentPhase = phases.get(initialPhase);
        initiate();
        startLoggingStatistics();

    }

    private void incorrectPhase(GamePhases phase) {
        throw new IllegalStateException(phase.toString() + " No such Phase Exists!");
    }

    public void process() {
        if (isStarted) currentPhase.process();
        if (currentPhase.isDone())
            changePhase(currentPhase.getNextPhase());

    }


    public void changePhase(GamePhases phase) {
        if (currentPhase != null) {
            currentPhase.cleanup();
        }
        if (phase == null)
            return;
        //throw new IllegalStateException("This is the last phase!");

        currentPhase = phases.get(phase);
        if (currentPhase == null)
            incorrectPhase(phase);

        currentPhase.initialize();

    }


    public void debugLog() {
        //TODO should this e.g. be stored in a file?
        SLOG.d(currentPhase.getDebugText());
        //TODO: also log performance stats

    }


    public void removeGamePhase() {
        if (phases.isEmpty()) return;
        Phase gamePhase = phases.get(GamePhases.GAME_PHASE);
        if (gamePhase == null) {
            return;
        }
        gamePhase.cleanup();
        phases.remove(GamePhases.GAME_PHASE);
    }


    // dynamically add a game to phases.
    public void insertGamePhase(GameSelector.Games value) {
        GamePhase game = GameSelector.select(value.toString());
        if (game == null)
            throw new IllegalStateException("Incorrect Game Name");
        phases.put(GamePhases.GAME_PHASE, game);
    }


    public void stop() {
        // todo remove gamephase (subGame) from phases dictionary only when phasemanager has to stop? keeping netflix module into account.
        currentPhase.cleanup();
        gameLoop.stop();
        isStarted = false;
    }

    public enum GamePhases {
        CONTEXT_INITIALIZATION_PHASE,
        PROMO_PHASE,
        CALIBRATION_PHASE,
        COUNTDOWN_PHASE,
        GAME_PHASE,
        END_OF_EXERCISE_PHASE,
        CLEANUP_PHASE
    }


}
