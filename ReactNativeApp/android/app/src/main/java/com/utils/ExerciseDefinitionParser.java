package com.utils;

import android.util.Pair;

import com.activities.GameActivity;
import com.components.games.base.GameContext;
import com.logger.SLOG;
import com.models.ModelManager;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.io.IOException;
import java.io.InputStream;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;

public class ExerciseDefinitionParser {

    private final String exerciseFileName;
    private final JSONObject exerciseJson;
    public String gameName = "";
    public int gameDuration = 90000; // in milliseconds

    ArrayList<Pair<GameContext.GameType, ModelManager.MODELTYPE>> modelObjectRelation = new ArrayList<>();

    public ExerciseDefinitionParser(String fileName) {
        this.exerciseFileName = fileName;
        this.exerciseJson = loadJSON();
        unPackJSON();
    }


    private JSONObject loadJSON() {
        try {
            return new JSONObject(loadJSONFromAsset());
        } catch (JSONException | IOException e) {
            SLOG.e("fatal " + e.getMessage());
            return null;
        }
    }

    private void unPackJSON() {
        try {
            JSONObject metaData = (JSONObject) exerciseJson.get("metadata");
            this.gameName = (String) metaData.get("gameName");
            this.gameDuration = ((int) metaData.get("exerciseDuration")) * 1000; // to convert to milliseconds.
        } catch (JSONException e) {
            SLOG.e("fatal unPacking JSON " + e.getMessage());
        }
    }

    private String loadJSONFromAsset() throws IOException {
        String json;

        InputStream is = GameActivity.getActivity().getAssets().open(exerciseFileName);
        int size = is.available();
        byte[] buffer = new byte[size];
        int res = is.read(buffer);
        is.close();
        json = new String(buffer, StandardCharsets.UTF_8);

        return json;
    }

    // todo implement sanity, null, validations etc etc checks.

    public ArrayList<Pair<GameContext.GameType, ModelManager.MODELTYPE>> getObjectsToUse() throws JSONException {

        JSONObject metaData = (JSONObject) exerciseJson.get("metadata");
        JSONArray objectsNeeded = metaData.getJSONArray("objectsNeeded");

        for (int i = 0; i < objectsNeeded.length(); i++) {
            JSONObject obj = objectsNeeded.getJSONObject(i);
            modelObjectRelation.add(getObjectDetection(obj.getString("type"), obj.getString("variation")));
        }

        return modelObjectRelation;

    }


    private Pair<GameContext.GameType, ModelManager.MODELTYPE> getObjectDetection(String modelType, String variation) {

        switch (modelType) {
            case "person":
                switch (variation) {
                    case "normal":
                        return new Pair<>(GameContext.GameType.PERSON, ModelManager.MODELTYPE.POSENET);

                    case "fast":
                        return new Pair<>(GameContext.GameType.PERSON, ModelManager.MODELTYPE.POSENET_FASTMODE);
                }

            case "ball":
                return new Pair<>(GameContext.GameType.BALL, ModelManager.MODELTYPE.FOOTBALLv16);
        }

        return null;

    }

}

