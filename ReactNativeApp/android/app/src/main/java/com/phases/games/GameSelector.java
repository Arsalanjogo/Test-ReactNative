package com.phases.games;

import com.phases.games.instances.JugglingPhase;
import com.phases.instances.GamePhase;

public class GameSelector {

    public static GamePhase select(String gameName) {

        switch (gameName) {
            case "Juggling":
                return new JugglingPhase();
        }
        return null;
    }

    public enum Games {
        Juggling
    }

}
