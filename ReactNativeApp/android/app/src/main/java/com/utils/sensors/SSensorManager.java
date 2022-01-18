package com.utils.sensors;

import android.app.Activity;
import android.content.Context;
import android.hardware.Sensor;
import android.hardware.SensorEvent;
import android.hardware.SensorEventListener;
import android.hardware.SensorManager;

import com.logger.SLOG;
import com.utils.UtilArrayList;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;
import java.util.function.Consumer;

public class SSensorManager {
    private final SensorManager sensorManager;
    private final Map<Integer, UtilArrayList<Consumer<SensorEvent>>> sensorCallbacks = new ConcurrentHashMap<>();
    private final UtilArrayList<SensorEventListener> sensorEventListeners = new UtilArrayList<>();
    String TAG = "SENSOR";

    public SSensorManager(Activity activity) {
        sensorManager = (SensorManager) activity.getSystemService(Context.SENSOR_SERVICE);
    }

    //helper methods
    public float[] remapCoordinates(SensorEvent event) {
        float[] rotationMatrix = new float[16];
        SensorManager.getRotationMatrixFromVector(
                rotationMatrix, event.values);

        // Remap coordinate system
        float[] remappedRotationMatrix = new float[16];
        SensorManager.remapCoordinateSystem(rotationMatrix,
                SensorManager.AXIS_X,
                SensorManager.AXIS_Z,
                remappedRotationMatrix);

        // Convert to orientations
        float[] orientations = new float[3];
        SensorManager.getOrientation(remappedRotationMatrix, orientations);

        // convert radian into degrees
        for (int i = 0; i < 3; i++) {
            orientations[i] = (float) (Math.toDegrees(orientations[i]));
        }
        return orientations;
    }

    public void addSensor(int type) {
        if (sensorCallbacks.containsKey(type)) return;
        sensorCallbacks.put(type, new UtilArrayList<>());

        SensorEventListener listener = new SensorEventListener() {
            @Override
            public void onSensorChanged(SensorEvent sensorEvent) {
                sensorCallbacks.get(type).forEach(c -> c.accept(sensorEvent));
            }

            @Override
            public void onAccuracyChanged(Sensor sensor, int i) {
//can be overridden if required
            }
        };

        sensorEventListeners.add(listener);
        sensorManager.registerListener(listener, sensorManager.getDefaultSensor(type), 1_000_00);
    }

    public callbackManager sampleSensor(int type, Consumer<SensorEvent> callback) {
        addSensor(type);
        sensorCallbacks.get(type).add(callback);
        return new callbackManager(callback, type, this);
    }

    public callbackManager getXYZOrientation(Consumer<float[]> callback) {
        return sampleSensor(Sensor.TYPE_GAME_ROTATION_VECTOR, (event) -> {
            float[] orientations = remapCoordinates(event);
            SLOG.d(TAG, "orientations" + Arrays.toString(orientations));
            callback.accept(orientations);
        });
    }


    public callbackManager onMotion(Consumer<float[]> callback, double speedThreshold) {
        return sampleSensor(Sensor.TYPE_LINEAR_ACCELERATION, (event) -> {
            double speed = Math.abs(event.values[0]) + Math.abs(event.values[1]) + Math.abs(event.values[2]);
            SLOG.d(TAG, "speed" + speed);
            if (speed > speedThreshold) {
                callback.accept(event.values);
            }
        });
    }

    void unSubscribe(int sensorType, Consumer<SensorEvent> callback) {
        sensorCallbacks.get(sensorType).remove(callback);
    }


    public void stop() {
        sensorEventListeners.forEach(sensorManager::unregisterListener);
    }

}
