package com.phases.instances;

import com.components.games.base.GameContext;
import com.logger.SLOG;
import com.phases.base.Phase;
import com.phases.phasemanager.PhaseManager;
import com.utils.ExerciseDefinitionParser;

import org.json.JSONException;

public class ContextInitializationPhase extends Phase {

    public ContextInitializationPhase(PhaseManager phaseManager) {
        contextPhaseCallBack = phaseManager;
    }

    @Override
    public void process() {

    }

    @Override
    public void initialize() {
        completed = false;
        this.nextPhase = PhaseManager.GamePhases.PROMO_PHASE;
        ExerciseDefinitionParser exerciseDefinitionParser = new ExerciseDefinitionParser(GameContext.getContext().fileName);
        GameContext.getContext().setGameName(exerciseDefinitionParser.gameName);
        GameContext.getContext().setGameDuration(exerciseDefinitionParser.gameDuration);
        // todo iOS guys remove as well here. lets see why we would need it.
        contextPhaseCallBack.insertGamePhase(GameContext.getContext().getGame());
        try {
            GameContext.getContext().initializeObjectsAndModels(exerciseDefinitionParser.getObjectsToUse());
        } catch (JSONException e) {
            SLOG.e(e.getMessage());
        }

        // TODO:  Do all of the other initialization in here.
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
    public boolean isDone() {
        return completed;
    }
}
