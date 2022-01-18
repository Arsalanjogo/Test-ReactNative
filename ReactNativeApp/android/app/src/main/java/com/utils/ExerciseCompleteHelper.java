package com.utils;

import com.facebook.react.bridge.ReactContext;
import com.facebook.react.bridge.WritableMap;
import com.facebook.react.modules.core.DeviceEventManagerModule;

public class ExerciseCompleteHelper {


    public void sendEvent(ReactContext reactContext,
                          String eventName,
                          WritableMap params) {
        reactContext
                .getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class)
                .emit(eventName, params);
//        context.finish();
    }
}
