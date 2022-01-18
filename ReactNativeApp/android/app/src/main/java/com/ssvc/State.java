package com.ssvc;

import com.render.DebugText;
import com.utils.UtilArrayList;

import java.util.ArrayList;

abstract public class State implements DebugText {
    ArrayList<StateObserver> stateObservers = new UtilArrayList<>();

    public void addObserver(StateObserver stateObserver) {
        stateObservers.add(stateObserver);
    }

    public void notifyObservers() {
        //todo: better naming?
        stateObservers.forEach(StateObserver::onNotify);
    }


}
