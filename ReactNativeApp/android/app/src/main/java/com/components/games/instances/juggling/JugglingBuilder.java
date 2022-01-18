package com.components.games.instances.juggling;

import com.components.basic.points.PointsController;
import com.components.basic.streak.StreakController;
import com.components.games.base.GameContext;
import com.ssvc.SSVC;

public class JugglingBuilder {

    static private JugglingState buildState() {
        return new JugglingState();
    }

    public static SSVC<JugglingState, JugglingView, JugglingController> buildJugglingGame(PointsController pointsController, StreakController streakController) {
        JugglingState state = buildState();
        JugglingView jugglingView = new JugglingView(state, GameContext.getContext().ball.state);
        JugglingController jugglingController = new JugglingController(state, GameContext.getContext().ball.controller,
                GameContext.getContext().person.controller, pointsController,streakController);

        return new SSVC<>(state, jugglingView, jugglingController);
    }

}
