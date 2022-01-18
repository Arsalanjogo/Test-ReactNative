package com.ssvc;

import com.render.DebugText;

abstract public class Controller<S extends State> implements StateObserver, DebugText {
    protected S state;

    public Controller(S state) {
        state.addObserver(this);
        this.state = state;
    }

    @Override
    public void onNotify() {

    }
}
