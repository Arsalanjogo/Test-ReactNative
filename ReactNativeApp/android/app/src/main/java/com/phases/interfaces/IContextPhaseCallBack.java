package com.phases.interfaces;

import com.phases.games.GameSelector;

public interface IContextPhaseCallBack {

    void removeGamePhase();

    void insertGamePhase(GameSelector.Games value);

}
