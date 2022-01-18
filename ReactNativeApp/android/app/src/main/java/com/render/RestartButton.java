package com.render;

import com.activities.GameActivity;

public class RestartButton extends BasicButton {

    public RestartButton(android.widget.Button button) {
        super(button);
    }

    @Override
    public void execute() {
        GameActivity.getActivity().restart();
    }

    public void reInitialize() {
        this.initButtonListener();
        this.setupOnClickButton();
    }

}
