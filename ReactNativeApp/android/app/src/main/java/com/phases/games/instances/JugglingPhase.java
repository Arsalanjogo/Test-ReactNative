package com.phases.games.instances;

import com.components.games.base.GameContext;
import com.components.games.instances.juggling.JugglingBuilder;
import com.components.games.instances.juggling.JugglingController;
import com.components.games.instances.juggling.JugglingState;
import com.components.games.instances.juggling.JugglingView;
import com.phases.instances.GamePhase;
import com.ssvc.SSVC;

public class JugglingPhase extends GamePhase {

    SSVC<JugglingState, JugglingView, JugglingController> jugglingGame;


    @Override
    public void initialize() {
        super.initialize();
        this.jugglingGame = JugglingBuilder.buildJugglingGame(points.controller,streak.controller);

    }

    @Override
    public void process() {
        super.process();
        if (jugglingGame == null) return;
        jugglingGame.controller.process();
    }

    @Override
    public void cleanup() {
        jugglingGame.stateView.detachFromLayoutSV();
        GameContext.getContext().setRelevantGameInfo("score", String.valueOf(points.state.currentPoints));
        jugglingGame = null;
        super.cleanup();
    }
}
