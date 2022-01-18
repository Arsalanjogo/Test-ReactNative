package com.render;

import android.view.View;

import com.activities.GameActivity;
import com.components.games.base.GameContext;
import com.utils.STimer;
import com.utils.sensors.callbackManager;

import java.util.TimerTask;

public abstract class BasicButton {

    protected boolean running = false;
    protected android.widget.Button button;
    protected final long BUTTON_DELAY = 800;
    protected final double SPEED_THRESHOLD = 0.5;
    protected TimerTask buttonTask;
    protected callbackManager buttonListener;
    STimer timer = new STimer(false);
    boolean displayButton = true;

    public BasicButton(android.widget.Button button) {
        this.button = button;
        this.initButtonListener();
        this.setupOnClickButton();
    }

    private void hideButton() {
        if (GameActivity.getActivity() == null) return;
        if (!running) return;
        GameActivity.getActivity().runOnUiThread(() -> button.setVisibility(View.GONE));
        buttonTask = null;
    }

    public void activateButton() {
        if (!running || GameActivity.getActivity() == null) return;
        if (buttonTask != null) buttonTask.cancel();
        buttonTask = timer.schedule(this::hideButton, BUTTON_DELAY);
        GameActivity.getActivity().runOnUiThread(() -> button.setVisibility(View.VISIBLE));
    }

    protected void initButtonListener() {
        running = true;
        buttonListener = GameContext.getContext().sensorManager.onMotion((v) ->
                { if (displayButton) activateButton(); },SPEED_THRESHOLD);
    }

    public void stop() {
        running = false;
        buttonListener.cancel();
    }

    public void concealButton() {
        displayButton = false;
    }

    public void showButton() {
        displayButton = true;
    }


    protected void setupOnClickButton() {
        if (!running) return;
        button.setOnClickListener(view -> {
            buttonListener.cancel();
            hideButton();
            execute();
        });
    }

    public abstract void execute();

}

