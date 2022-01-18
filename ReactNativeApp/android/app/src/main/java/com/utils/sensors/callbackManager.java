package com.utils.sensors;

import android.hardware.SensorEvent;

import java.util.function.Consumer;

public class callbackManager {
    final Consumer<SensorEvent> callback;
    private final int sensorType;
    SSensorManager sensorManager;

    public callbackManager(Consumer<SensorEvent> callback, int sensorType, SSensorManager sensorManager) {
        this.callback = callback;
        this.sensorManager = sensorManager;
        this.sensorType = sensorType;
    }

    public void cancel() {
        sensorManager.unSubscribe(sensorType, this.callback);
    }

}
