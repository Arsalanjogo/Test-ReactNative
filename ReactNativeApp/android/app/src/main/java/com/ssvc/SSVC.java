package com.ssvc;

import com.render.DebugText;
import com.ssvc.SV.StateView;

public class SSVC<S extends State, SV extends StateView, C extends Controller> implements DebugText {

    final public S state;
    final public SV stateView;
    final public C controller;

    public SSVC(S state, SV stateView, C controller) {
        this.state = state;
        this.stateView = stateView;
        this.controller = controller;
    }

    public void cleanup() {

    }

    public String getDebugText() {
        return "state:" + state.getDebugText() + "stateview:" + stateView.getDebugText() + "controller" + controller.getDebugText();
    }
}
