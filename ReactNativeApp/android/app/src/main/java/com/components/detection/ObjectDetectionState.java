package com.components.detection;

import android.graphics.Canvas;

import com.location.DetectionLocation;
import com.location.InferLocation;
import com.location.InferLocationLinear;
import com.location.MissingLocation;
import com.location.SkippedLocation;
import com.logger.SLOG;
import com.models.ModelManager;
import com.models.ModelObserver;
import com.models.ObservableModel;
import com.ssvc.State;
import com.utils.InfoBlob;
import com.utils.UtilArrayList;

import org.json.JSONException;
import org.json.JSONObject;

import java.util.List;
import java.util.stream.Collectors;
import java.util.stream.IntStream;

public class ObjectDetectionState extends State implements ModelObserver {


    protected static final int INFER_LOOKBACK = 10;

    public final String label;
    protected final int BUFFERLENGTH = -1;
    //todo use max lenght queue
    protected final UtilArrayList<DetectionLocation> locations = new UtilArrayList<>(BUFFERLENGTH);
    private final UtilArrayList<InfoBlob> infoBlobArrayList = new UtilArrayList<>(BUFFERLENGTH);
    protected ModelManager.MODELTYPE modelType;
    protected InferLocation inferLocation = new InferLocationLinear();
    protected ObservableModel model;
    boolean exerciseLead;
    private double avgFrameDistance = 0;
    private int detectedCount = 0;
    private int frameInferenceCount = 0;
    private int skippedFrameCount = 0;
    //todo should we add a guard here>
    private float confidenceScore = 0;


    public ObjectDetectionState(String label, ModelManager.MODELTYPE modelType, boolean exerciseLead) {

        this.label = label;
        this.modelType = modelType;
        ModelManager manager = ModelManager.getInstance();
        //The object detection class determines which models it would need, and makes sure these models are started.
        //You don;t need to worry about the right models being run, as this class takes care of that.
        manager.subscribe(this);

        //the Exercise Lead the model that is responsible for calling the OnProcessed function of the Exercise.
        setExerciseLead(exerciseLead);
    }

    public void setConfidenceScore(float confidenceScore) {
        this.confidenceScore = confidenceScore;
        //todo this is not really a clean solution
        ModelManager.getInstance().removeConfidenceScore(this);
    }

    public void setExerciseLead(boolean exerciseLead) {
        ModelManager manager = ModelManager.getInstance();
        manager.setExerciseLead(modelType, exerciseLead);
        this.exerciseLead = exerciseLead;
    }


    public Double getY() {
        DetectionLocation d = getDetectedLocation();
        if (d == null) return null;
        return d.getY();
    }


    public Double getX() {
        DetectionLocation d = getDetectedLocation();
        if (d == null) return null;
        return d.getX();
    }


    public void clearLocations() {
        locations.clear();
    }


    public float canvX(Canvas canvas) {
        return (float) (getX() * canvas.getWidth());
    }

    public float canvY(Canvas canvas) {
        return (float) (getY() * canvas.getHeight());
    }

    public ModelManager.MODELTYPE getModelType() {
        return modelType;
    }


    public DetectionLocation getLocation() {
        //returns the last location object
        //can be an undetected location
        return locations.getLast();
    }

    public DetectionLocation getDetectedLocation() {
        //returns the last detected locations
        return getDetectedLocationNBack(0);
    }

    @Override
    public void setModel(ObservableModel model) {
        this.model = model;
    }

    public DetectionLocation getDetectedLocationNBack(int n) {
        //get the location N detections back.
        // if N=0, it gets the latest detected location
        int size = locations.size();
        if (size == 0 || size < n) return null;
        for (int i = size - 1; i >= 0; i--) {
            if (locations.get(i).locationKnown()) {
                if (n == 0) return locations.get(i);
                n--;
            }
        }
        return null;
    }


    public UtilArrayList<DetectionLocation> getNDetectedLocations(int n) {
        //returns the last N detected Locations
        // returns oldest first
        //no guarantee it will return n detections
        if (n > locations.size()) return null;
        UtilArrayList<DetectionLocation> temp = new UtilArrayList<>();

        for (int i = locations.size() - 1; i >= 0 && temp.size() < n; i--)
            if (locations.get(i).locationKnown())
                temp.add(0, locations.get(i));

        return temp;
    }


    public UtilArrayList<DetectionLocation> getNLocations(int n) {
        //get the last N locations
        n = Math.min(n, locations.size());
        UtilArrayList<DetectionLocation> temp = new UtilArrayList<>();
        IntStream.range(locations.size() - n, locations.size()).forEach(idx -> temp.add(locations.get(idx)));
        return temp;
    }

    public UtilArrayList<DetectionLocation> getDetectedLastN(int n) {
        //get the detected locations frmo the last N
        if (n > locations.size()) return null;
        return this.getNLocations(n).stream()
                .filter(DetectionLocation::locationKnown)
                .collect(Collectors.toCollection(UtilArrayList::new));
    }


    public List<DetectionLocation> getAllLocations() {
        //todo DeepCopy?
        return locations;
    }

    public double getAvgFrameDistance() {
        //returns the average Distance the object travels per frame
        return avgFrameDistance;
    }

    public void addDetectedLocation(DetectionLocation detectedLocation) {
        //Adds a new detected location to the list

        List<DetectionLocation> before = getNLocations(INFER_LOOKBACK);
        if (before == null) {
            locations.add(detectedLocation);
            return;
        }

        //infer the missing locations
        inferLocation.infer(before, detectedLocation);
        locations.add(detectedLocation);
    }


    protected void missingLocation(int FrameID) {
        //TODO we probably want to have more info, like RectLocation or point location
        locations.add(new MissingLocation(FrameID, getLabel()));
    }

    protected void skippedLocation(int FrameID) {
        //TODO we probably want to have more info, like RectLocation or point location
        locations.add(new SkippedLocation(FrameID, getLabel()));
    }


    @Override
    public void parse(List<DetectionLocation> detectedLocations, InfoBlob info) {
        //The function that is being called by the model with new Location info.
        frameInferenceCount++;
        DetectionLocation temp = getLocation();
        int lastProcessedFrameID = temp == null ? -1 : temp.getFrameID();


        infoBlobArrayList.add(info);
        DetectionLocation lastLocation = getDetectedLocation();

        DetectionLocation bestMatch = null;
        double minDistance = 0;

        int missingFrameDiff = info.getFrameID() - lastProcessedFrameID - 1;

        skippedFrameCount += missingFrameDiff;

        //check for a label match
        for (DetectionLocation l : detectedLocations) {
            if (l.getLabel().equals(getLabel()) && lastLocation != null) {
                SLOG.d("distance: " + l.getEuclideanDistance(lastLocation));
            }

            if (l.getLabel().equals(getLabel()) && !l.isProcessed() && l.getConfidence() >= confidenceScore && (bestMatch == null || lastLocation == null || l.getEuclideanDistance(lastLocation) < minDistance)) {

                bestMatch = l;
                minDistance = bestMatch.getEuclideanDistance(l);
            }
        }

        if (bestMatch == null) {
            //here we have not found a good match, and thus we apply the missing location logic.
            for (int i = 0; i < missingFrameDiff + 1; i++) {
                if (i == missingFrameDiff) missingLocation(lastProcessedFrameID + i + 1);
                else skippedLocation(lastProcessedFrameID + i + 1);
            }
            return;
        }


        if (lastLocation != null) {
            avgFrameDistance = (avgFrameDistance + bestMatch.getEuclideanDistance(lastLocation)) / (2.0);
        }

        detectedCount++;

        for (int i = 0; i < missingFrameDiff; i++) skippedLocation(lastProcessedFrameID + i + 1);

        bestMatch.process();
        addDetectedLocation(bestMatch);

    }

    public int getDetectedCount() {
        return detectedCount;
    }

    public int getFrameInferenceCount() {
        return frameInferenceCount;
    }

    public int getSkippedFrameCount() {
        return skippedFrameCount;
    }

    public UtilArrayList<InfoBlob> getInfoBlobArrayList() {
        return infoBlobArrayList;
    }

    public UtilArrayList<DetectionLocation> getLocations() {
        return locations;
    }

    public void setMaxFPS(int fps) {
        ModelManager.getInstance().setMaxFPS(fps, modelType);
    }


    public void writeToJSON(JSONObject dataJSONWriter) throws JSONException {
        dataJSONWriter.put("x", locations.getAsFlatJsonArray(DetectionLocation::getX2f));
        dataJSONWriter.put("y", locations.getAsFlatJsonArray(DetectionLocation::getY2f));
        dataJSONWriter.put("z", locations.getAsFlatJsonArray(DetectionLocation::getZ2f));
        dataJSONWriter.put("status", locations.getAsFlatJsonArray(DetectionLocation::getStatusChar));
    }

    public boolean inFrame() {
        return (getLocation().getStatus() == DetectionLocation.STATUS.DETECTED);
    }

    public String getLabel() {
        return label;
    }

    public void unSubscribe() {
        ModelManager manager = ModelManager.getInstance();
        if (manager != null) manager.unsubscribe(this);
        //otherwise we have had full close and the modelmanager is closed anyway
    }

    @Override
    public String getDebugText() {
        return "ObjectDetectionState";
    }
}
