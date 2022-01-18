package com.utils;

import android.app.ActivityManager;
import android.content.Context;
import android.os.PowerManager;
import android.util.Log;

import com.activities.GameActivity;
import com.components.games.base.GameContext;
import com.football433.NativeBridge;
import com.logger.SLOG;
import com.logger.TLOG;
import com.logger.Timer;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.io.IOException;
import java.io.RandomAccessFile;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.sql.Timestamp;
import java.util.Collections;
import java.util.Map;
import java.util.Objects;
import java.util.concurrent.ConcurrentHashMap;

public class Profiling extends TLOG {

    private static final ConcurrentHashMap<String, JSONObject> methodTimeMap = new ConcurrentHashMap<>();
    private static final Map<String, String> thermalStatusLogs = new ConcurrentHashMap<>();
    private static final Map<String, String> ramLogs = new ConcurrentHashMap<>();
    private static final Map<String, JSONArray> heapMemoryLogs = new ConcurrentHashMap<>();
    public static final String PROFILING_STATUS = "ExecutionTime";
    private static final String THERMAL_STATUS_TAG = "ThermalStatus";
    private static final String HEAP_MEM_STATUS_TAG = "HeapMemAvailability";
    private static final String RAM_AVAILABILITY = "RamAvailable";
    private static final PowerManager.OnThermalStatusChangedListener temperatureListener = status -> thermalStatusLogs.put(String.valueOf(GameContext.currentGlobalFrameID), THERMAL_STATUS.values()[status].name());
    private static final PowerManager powerManager = (PowerManager) GameActivity.getActivity().getSystemService(Context.POWER_SERVICE);

    public static void clear() {
        methodTimeMap.clear();
        thermalStatusLogs.clear();
        heapMemoryLogs.clear();
        ramLogs.clear();
    }


    /**
     * Calculates and stores the execution time for the code enfolded within start and end profiling calls.
     *
     * @param METHOD_NAME_TAG Any name for the tag by which the profiling data will be identified.
     * @param frameID         The frameID at the time of invoking this method.
     */
    public static void profilingStart(String METHOD_NAME_TAG, int frameID) {

        if (!NativeBridge.PROFILING) return;

        METHOD_NAME_TAG = build_tag(METHOD_NAME_TAG);

        if (!methodTimeMap.containsKey(METHOD_NAME_TAG)) {
            methodTimeMap.put(METHOD_NAME_TAG, new JSONObject());
        }
        timings.put(METHOD_NAME_TAG, new Timer(frameID));
    }

    /**
     * Calculates and stores the execution time for the code enfolded within start and end profiling calls.
     *
     * @param METHOD_NAME_TAG The corresponding tag name that was passed in the profilingStart.
     */
    public static void profilingEnd(String METHOD_NAME_TAG,String FUNCTION_NAME) {

        if (!NativeBridge.PROFILING) return;

        METHOD_NAME_TAG = build_tag(METHOD_NAME_TAG);
        Timer timer = Objects.requireNonNull(timings.get(METHOD_NAME_TAG));
        //FUNCTION_NAME = build_tag(FUNCTION_NAME);

        JSONArray jsonoBJ = new JSONArray();

        jsonoBJ.put(timer.getFrameID());
        jsonoBJ.put(timer.getTime());

        JSONObject jsonArray = methodTimeMap.get(METHOD_NAME_TAG);
        try {
            jsonArray.put(FUNCTION_NAME,jsonoBJ);
        } catch (JSONException e) {
            e.printStackTrace();
        }

        methodTimeMap.put(METHOD_NAME_TAG, jsonArray);
    }

    /**
     * Logs current thermal status. Only gets logged when there's a status change. Also, logs the respective frameID at which the thermal status was updated.
     */
    public static void monitorTemperature() {
        thermalStatusLogs.put(String.valueOf(GameContext.currentGlobalFrameID), THERMAL_STATUS.values()[powerManager.getCurrentThermalStatus()].name());
        powerManager.addThermalStatusListener(temperatureListener);
    }

    public static void cleanUp() {
        powerManager.removeThermalStatusListener(temperatureListener);
    }

    /**
     * Logs the status of the heap memory (in percentage), since if it uses too much memory, you get OOM and it crashes the app.
     * The higher the percentage, the closer you get OOM. (Due to memory fragmentation, you may get OOM BEFORE this reaches zero.)
     *
     * @param frameID The frameID at the time of invoking this method, so that we can know heapMem availability per each frame.
     */
    public static void monitorHeapMemory(int frameID) {

        if (!NativeBridge.PROFILING) return;
        final Runtime runtime = Runtime.getRuntime();
        final long usedMemInMB = (runtime.totalMemory() - runtime.freeMemory()) / 1048576L;
        final long maxHeapSizeInMB = runtime.maxMemory() / 1048576L;
        final double availHeapSizeInMB = (double) usedMemInMB / (double) maxHeapSizeInMB;
        final double availHeapSizePercentage = availHeapSizeInMB * 100.0;

        if (heapMemoryLogs.isEmpty()) {
            heapMemoryLogs.put(HEAP_MEM_STATUS_TAG, new JSONArray());
        }

        JSONArray jsonArray = heapMemoryLogs.get(HEAP_MEM_STATUS_TAG);

        try {
            jsonArray.put(frameID);
            jsonArray.put(availHeapSizePercentage);
        } catch (JSONException e) {
            SLOG.e(e);
        }
        heapMemoryLogs.put(HEAP_MEM_STATUS_TAG, jsonArray);
    }

    public static void writeProfilingData() {
        try {
            JSONObject json = new JSONObject(methodTimeMap);

            JSONObject thermalStatusJson = new JSONObject(thermalStatusLogs);
            json.put(THERMAL_STATUS_TAG, thermalStatusJson);

            JSONObject heapMemJson = new JSONObject(heapMemoryLogs);
            json.put(HEAP_MEM_STATUS_TAG, heapMemJson);
            json.put(RAM_AVAILABILITY,ramLogs);

            String jsonName = GameContext.getContext().getGame().toString() + " " + new Timestamp(System.currentTimeMillis()) + "-profiling.json";
            String jsonPath = GameActivity.getActivity().getExternalFilesDir(jsonDir).getAbsolutePath() + "/" + jsonName;
            Files.write(Paths.get(jsonPath), Collections.singleton(json.toString()));
        } catch (JSONException | IOException e) {
            SLOG.e(e);
        }
    }

    /**
     * This function is for getting CPU usage for all cores.
     * */

    public static float readCPUUsage() {
        try {
            RandomAccessFile reader = new RandomAccessFile("/proc/stat", "r");
            String load = reader.readLine();

            String[] toks = load.split(" +");  // Split on one or more spaces

            long idle1 = Long.parseLong(toks[4]);
            long cpu1 = Long.parseLong(toks[2]) + Long.parseLong(toks[3]) + Long.parseLong(toks[5])
                    + Long.parseLong(toks[6]) + Long.parseLong(toks[7]) + Long.parseLong(toks[8]);

            try {
                Thread.sleep(360);
            } catch (Exception e) {}

            reader.seek(0);
            load = reader.readLine();
            reader.close();

            toks = load.split(" +");

            long idle2 = Long.parseLong(toks[4]);
            long cpu2 = Long.parseLong(toks[2]) + Long.parseLong(toks[3]) + Long.parseLong(toks[5])
                    + Long.parseLong(toks[6]) + Long.parseLong(toks[7]) + Long.parseLong(toks[8]);

            return (float)(cpu2 - cpu1) / ((cpu2 + idle2) - (cpu1 + idle1));

        } catch (IOException ex) {
            ex.printStackTrace();
        }

        return 0;
    }

    /**
     * This function is to get current ram status and available ram in percentage, this can be used to check the available
     * ram before starting a big processing task
     * */

    public static String getCurrentRamStatus(int currentGlobalFrameID, Context context){
        ActivityManager.MemoryInfo mi = new ActivityManager.MemoryInfo();
        ActivityManager activityManager = (ActivityManager) context.getSystemService(context.ACTIVITY_SERVICE);
        activityManager.getMemoryInfo(mi);
        double availableMegs = mi.availMem / 0x100000L;

        //Percentage can be calculated for API 16+
        double percentAvail = mi.availMem / (double)mi.totalMem * 100.0;
        Log.d(RAM_AVAILABILITY,Double.toString(percentAvail));
        ramLogs.put(Integer.toString(currentGlobalFrameID),Double.toString(percentAvail));
        return String.valueOf(percentAvail);

    }

    enum THERMAL_STATUS {
        NONE, LIGHT, MODERATE, SEVERE, CRITICAL, EMERGENCY, SHUTDOWN
    }

}
