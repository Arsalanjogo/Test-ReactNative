package com.render;

import com.activities.GameActivity;

public class StopButton extends BasicButton {

    public StopButton(android.widget.Button button) {
        super(button);
    }

    @Override
    public void execute() {
        GameActivity.getActivity().hideRestartButton();
        GameActivity.getActivity().stop();
    }

}
