package com.components.games.base;

import android.util.Pair;

import com.activities.GameActivity;
import com.components.detection.ObjectDetectionState;
import com.components.detection.ball.BallBuilder;
import com.components.detection.ball.BallDetectionController;
import com.components.detection.ball.BallDetectionState;
import com.components.detection.ball.BallDetectionView;
import com.components.detection.person.PersonBuilder;
import com.components.detection.person.PersonController;
import com.components.detection.person.PersonState;
import com.components.detection.person.PersonView;
import com.models.ModelManager;
import com.phases.games.GameSelector;
import com.ssvc.SSVC;
import com.utils.InfoBlob;
import com.utils.UtilArrayList;
import com.utils.sensors.SSensorManager;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;


public class GameContext {

    public static int currentGlobalFrameID = 0;
    private static GameContext gameContext;
    public final String fileName;
    public final ModelManager modelManager;
    public final SSensorManager sensorManager;
    public final List<ObjectDetectionState> detections = new ArrayList<>();
    public UtilArrayList<InfoBlob> infoBlobArrayList = new UtilArrayList<>();
    public SSVC<PersonState, PersonView, PersonController> person;
    public SSVC<BallDetectionState, BallDetectionView, BallDetectionController> ball;
    Map<String, String> relevantGameInfo = new HashMap<>(); // TEMPORARY!
    GameSelector.Games gamePhaseName;
    private int gameDuration;
    private int currentFrameNumber = 0;

    public GameContext(String fileName) {
        this.fileName = fileName;
        this.sensorManager = new SSensorManager(GameActivity.getActivity());
        this.modelManager = ModelManager.createInstance(GameActivity.getActivity(), GameActivity.getActivity().getApplicationContext());
        gameContext = this;
    }

    public static GameContext getContext() {
        return gameContext;
    }

    public Map<String, String> getRelevantGameInfo() {
        return relevantGameInfo;
    }

    public void setRelevantGameInfo(String info, String infoData) {
        this.relevantGameInfo.put(info, infoData);
    }

    public int getGameDuration() {
        return gameDuration;
    }

    public void setGameDuration(int gameDuration) {
        this.gameDuration = gameDuration;
    }

    public void initializeObjectsAndModels(ArrayList<Pair<GameType, ModelManager.MODELTYPE>> objectsToUse) {

        objectsToUse.forEach(obj -> {

            switch (obj.first) {

                case PERSON:
                    person = PersonBuilder.buildPersonDetection(obj.second);
                    detections.addAll(person.state.getDetectionSubClasses());
                    break;

                case BALL:
                    ball = BallBuilder.buildBallDetection(obj.second, true);
                    detections.add(ball.state);
                    break;
            }
        });

    }

    public void setInfoBlob(InfoBlob infoBlob) {
        infoBlobArrayList.add(infoBlob);
    }

    public int getCurrentFrameNumber() {
        return this.currentFrameNumber;
    }

    public void setCurrentFrameNumber(int value) {
        this.currentFrameNumber = value;
        currentGlobalFrameID = value;
    }

    public void setGameName(String name) {
        this.gamePhaseName = GameSelector.Games.valueOf(name);
    }

    public GameSelector.Games getGame() {
        return this.gamePhaseName;
    }

    public enum GameType {PERSON, BALL, BALL_PERSON}

}
