package com.football433;

import android.content.Intent;

import com.activities.CameraActivity;
import com.exercises.base.exerciseLoaders.GameLoaderLandscape;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;


public class NativeBridge extends ReactContextBaseJavaModule {

    public final static boolean PROFILING = false;
    private final static boolean DEBUG = false;
    private final static boolean TO_JSON = true;

    public NativeBridge(ReactApplicationContext context) {
        super(context);
    }

    public static boolean isDebug() {
        return DEBUG;
    }

    public static boolean isToJson() {
        return TO_JSON;
    }

    @Override
    public String getName() {
        return "JugglingBridge";
    }

    @ReactMethod
    void startLandscapeActivity(String exerciseSetting, int index) {
        ReactApplicationContext context = getReactApplicationContext();
        Intent intent = new Intent(context, CameraActivity.class);
        intent.putExtra("gameSettings", exerciseSetting);
        intent.putExtra("index", index);
        intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
        context.startActivity(intent);

    }

}
