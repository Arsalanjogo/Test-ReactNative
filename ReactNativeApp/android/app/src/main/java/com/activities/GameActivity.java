package com.activities;

import static com.utils.Profiling.PROFILING_STATUS;

import android.content.pm.ActivityInfo;
import android.content.res.Configuration;
import android.os.Bundle;
import android.view.View;
import android.view.Window;
import android.view.WindowManager;

import com.components.games.base.GameContext;
import com.facebook.react.ReactActivity;
import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.WritableMap;
import com.google.gson.Gson;
import com.iostream.IOStream;
import com.football433.GameSettings;
import com.football433.NativeBridge;
import com.football433.R;
import com.football433.databinding.ExerciseViewBinding;
import com.logger.SLOG;
import com.phases.phasemanager.PhaseManager;
import com.render.RestartButton;
import com.render.StopButton;
import com.render.lottie.LottieFinish;
import com.utils.ExerciseCompleteHelper;
import com.utils.ExerciseStatsJsonManager;
import com.utils.ExtendedMLImage;
import com.utils.InfoBlob;
import com.utils.Profiling;
import com.views.AutoFitTextureView;
import com.views.OverlayView;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.sql.Timestamp;
import java.util.Collections;
import java.util.Objects;


abstract public class GameActivity extends ReactActivity implements IOStream {

    protected boolean running = false;

    // JSON
    protected static final String jsonDir = "dataExercises/";
    private static GameActivity activity;
    public String jsonName;
    public String jsonPath;
    private PhaseManager phaseManager;
    private GameContext gameContext;
    private OverlayView trackingOverlay;
    private StopButton stopButton;
    private RestartButton restartButton;

    private String gameSettingsJsonFileName = "exercise-data.json";
    public ExerciseViewBinding exerciseViewBinding;
    protected AutoFitTextureView autoFitTextureView;

    //the direction of the camera
    private int facing;


    static public GameActivity getActivity() {
        return activity;
    }

    protected void initViews() {
        trackingOverlay = findViewById(R.id.tracking_overlay);
        trackingOverlay.addCallback(canvas -> {
            trackingOverlay.postInvalidate();
            autoFitTextureView.setOverlayCanvas(canvas);
        });
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        activity = this;
        setupWindow();
        setUpGame();
    }


    public boolean isOrientationLandscape() {
        return getResources().getConfiguration().orientation == Configuration.ORIENTATION_LANDSCAPE;
    }


    private GameSettings gameSettings;


    private void setUpGameSettings() {
        final String exerciseJson = loadJSON();
        gameSettings = new Gson().fromJson(exerciseJson, GameSettings.class);
        setRequestedOrientation(gameSettings.getOrientation().equals("PORTRAIT") ? ActivityInfo.SCREEN_ORIENTATION_PORTRAIT : ActivityInfo.SCREEN_ORIENTATION_LANDSCAPE);
        facing = gameSettings.getCameraFacing();
    }

    private String loadJSON() {
        try {
            return loadJSONFromAsset();
        } catch (IOException e) {
            SLOG.e("fatal " + e.getMessage());
            return null;
        }
    }

    private String loadJSONFromAsset() throws IOException {
        String json;

        InputStream is = GameActivity.getActivity().getAssets().open(gameSettingsJsonFileName);
        int size = is.available();
        byte[] buffer = new byte[size];
        int res = is.read(buffer);
        is.close();
        json = new String(buffer, StandardCharsets.UTF_8);

        return json;
    }

    public void setUpGame() {
        setUpGameSettings();
        gameContext = new GameContext(gameSettings.getPayLoad());
        phaseManager = new PhaseManager();
    }

    protected void supplyImageToModelManager(ExtendedMLImage extendedMLImage) {
        gameContext.modelManager.supplyFrame(extendedMLImage);
    }

    @Override
    public void onImageProcessed(InfoBlob infoBlob) {
        GameContext.getContext().setInfoBlob(infoBlob);
    }


    private void initializeButtons() {
        stopButton = new StopButton(GameActivity.getActivity().getViewBinding().stopButton);
        restartButton = new RestartButton(GameActivity.getActivity().getViewBinding().restartButton);
    }

    // todo need to deal with edgecases too. so proper restart is a must!
    public void restart() {
        phaseManager.restart();
        GameContext.getContext().person.state.clearLocations();
        GameContext.getContext().ball.state.clearLocations();
        restartButton.reInitialize();
    }

    @Override
    protected void onStart() {
        super.onStart();
        initializeButtons();
        phaseManager.start();
        autoFitTextureView.start();
        prepareForJSON();
    }

    private void prepareForJSON() {
        if (!NativeBridge.isToJson()) return;

        jsonName = gameContext.getGame().toString() + new Timestamp(System.currentTimeMillis()) + ".json";
        jsonPath = GameActivity.getActivity().getExternalFilesDir(jsonDir).getAbsolutePath() + "/" + jsonName;

        File directory = GameActivity.getActivity().getExternalFilesDir(jsonDir);
        if (!directory.exists() && !directory.mkdirs()) {
            SLOG.e("EClient Exception MKDIR");
            throw new SecurityException("cannot create dir");
        }
    }

    public void hideButtons() {
        stopButton.concealButton();
        restartButton.concealButton();

    }

    public void hideRestartButton() {
        restartButton.concealButton();
    }

    public void hideStopButton() {
        stopButton.concealButton();
    }

    public void showButtons() {
        stopButton.showButton();
        restartButton.showButton();
    }

    public void exerciseCompleteHelper() {

        SLOG.d("Exercise Complete Helper !!!");
        WritableMap exerciseMap = Arguments.createMap();

        WritableMap map = Arguments.createMap();
        map.putString("json-path", jsonPath);
        map.putString("exercise-name", "Juggling");

        map.putString("score", gameContext.getRelevantGameInfo().get("score"));

        exerciseMap.putMap("Juggling", map); // juggling is for test only

        WritableMap returnMap = Arguments.createMap();
        returnMap.putMap("exercises", exerciseMap);
        SLOG.d("ai-complete", returnMap.toString());

        new ExerciseCompleteHelper().sendEvent(Objects.requireNonNull(activity.getReactInstanceManager().getCurrentReactContext()),
                "ai-complete", returnMap);
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
    }

    @Override
    protected void onStop() {
        super.onStop();
        gameContext.modelManager.stop();
        autoFitTextureView.cleanup();
        exerciseCompleteHelper();
        activity = null;
        Profiling.cleanUp();
    }

    private String getGameJSON() {
        Gson gson = new Gson();
        return gson.toJson(ExerciseStatsJsonManager.get());
    }

    public void stop() {
        running = false;
        phaseManager.stop();
        new LottieFinish().onEnd(this::stopGame).play();
        try {
            Files.write(Paths.get(jsonPath), Collections.singleton(getGameJSON()));
        } catch (IOException e) {
            SLOG.e("writeToJSON error! " + e.getMessage());
        }
        if (NativeBridge.PROFILING) {
            Profiling.profilingEnd(PROFILING_STATUS,"PhaseManager");
            Profiling.writeProfilingData();
        };
    }


    private void stopGame() {
        finish();
    }

    /****************************/


    /****************************/
    /******** WINDOW UI  ********/
    /****************************/

    private void setupWindow() {
        setWindowSettings();
        hideNavigationBar();
        //LayoutInflater layoutInflater = (LayoutInflater) getSystemService(Context.LAYOUT_INFLATER_SERVICE);
        exerciseViewBinding = com.football433.databinding.ExerciseViewBinding.inflate(getLayoutInflater());
        setContentView(exerciseViewBinding.getRoot());
        autoFitTextureView = findViewById(R.id.textureView);

    }


    private void setWindowSettings() {
        getWindow().addFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON);
        requestWindowFeature(Window.FEATURE_NO_TITLE);
        getWindow().addFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN);
        hideNavigationBar();
    }

    private void hideNavigationBar() {
        View decorView = getWindow().getDecorView();
        decorView.setSystemUiVisibility(
                View.SYSTEM_UI_FLAG_LAYOUT_STABLE
                        | View.SYSTEM_UI_FLAG_LAYOUT_HIDE_NAVIGATION
                        | View.SYSTEM_UI_FLAG_LAYOUT_FULLSCREEN
                        | View.SYSTEM_UI_FLAG_HIDE_NAVIGATION // hide nav bar
                        | View.SYSTEM_UI_FLAG_FULLSCREEN // hide status bar
                        | View.SYSTEM_UI_FLAG_IMMERSIVE);

    }

    public ExerciseViewBinding getViewBinding() {
        return exerciseViewBinding;
    }

    public static int getFacing(){
        return activity.facing;
    }

    public int getRelativeFrameRotation() {
        if (isOrientationLandscape()) return 0;
        return getFacing()==0?270:90;
    }

}
