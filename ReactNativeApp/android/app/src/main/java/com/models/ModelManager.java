package com.models;

import android.content.Context;

import com.iostream.IOStream;
import com.logger.SLOG;
import com.utils.ExtendedMLImage;

import java.io.IOException;
import java.util.Collection;
import java.util.Map;
import java.util.Objects;
import java.util.concurrent.ConcurrentHashMap;

public final class ModelManager {

    private static ModelManager modelManager = null;

    private final IOStream ioStream;
    private final Map<MODELTYPE, Model> modelHashMap = new ConcurrentHashMap<>();
    private final Context context;

    private ModelManager(IOStream ioStream, Context context) {
        this.ioStream = ioStream;
        this.context = context;
    }

    public static ModelManager getInstance() {
        return modelManager;
    }

    public static ModelManager createInstance(IOStream ioStream, Context context) {
        synchronized (ModelManager.class) {
            if (modelManager == null)
                modelManager = new ModelManager(ioStream, context);
            return modelManager;
        }
    }

    public Model instantiateModel(MODELTYPE modelManagerType) {
        Model model;
        switch (modelManagerType) {
            case FOOTBALLv16:
                model = new Footballv16SSD();
                break;
            case CENTERNET:
                model = new FootBallv17CenterNet();
                break;
            case POSENET:
                model = new PoseNet();
                break;
            case POSENET_FASTMODE:
                model = new PoseNetFastMode();
                break;
            case OLD_POSENET:
                model = new OldPoseNet();
                break;
            case SKIP:
                model = null;
                break;
            default:
                throw new IllegalStateException("Unexpected value: " + modelManagerType);
        }
        return model;
    }

    public void stop() {
        synchronized (this) {
            modelHashMap.values().forEach(Model::stop);
        }
        modelManager = null;
    }

    public Collection<Model> getModels() {
        return modelHashMap.values();
    }

    public void setExerciseLead(ModelManager.MODELTYPE modeltype, boolean exerciseLead) {
        //todo output synchronization is probably better than an exercise lead...
        if (modeltype == MODELTYPE.SKIP) return;
        Objects.requireNonNull(modelHashMap.get(modeltype)).setExerciseLead(exerciseLead);
    }

    public void subscribe(ModelObserver observer) {

        SLOG.d("subscribe:" + observer);
        //subscribe an observer to the correct model
        MODELTYPE modeltype = observer.getModelType();
        if (modeltype == MODELTYPE.SKIP) return;


        Model model = modelHashMap.get(modeltype);
        if (model == null) {
            try {
                model = instantiateModel(modeltype);
                model.loadModel(context);
                model.setIoStream(ioStream);
                model.start();
                modelHashMap.put(modeltype, model);
            } catch (IOException e) {
                SLOG.e(e);
            }
        }
        model.addObserver(observer);
    }

    public void unsubscribe(ModelObserver observer) {
        MODELTYPE modeltype = observer.getModelType();
        if (modeltype == MODELTYPE.SKIP) return;

        Model model = modelHashMap.get(modeltype);
        if (model == null) return; // weird
        SLOG.d("observers size:" + model.observers.size());
        model.removeObserver(observer);
    }

    public void supplyFrame(ExtendedMLImage extendedMLImage) {
        final int exerciseLeadCountLimit = 1;
        long cnt = modelHashMap.values().stream().filter(model -> model.observers.size() > 0).filter(Model::isExerciseLead).count();
        if (cnt != exerciseLeadCountLimit) {
            SLOG.e("exerciseLeadCount:" + cnt);
        }
        modelHashMap.values().stream().filter(model -> model.observers.size() > 0).forEach(model -> model.supplyFrame(extendedMLImage));
    }

    public void setConfidenceScore(ModelObserver observer, float confidence) {
        MODELTYPE modeltype = observer.getModelType();
        if (modeltype == MODELTYPE.SKIP) return;
        Model model = modelHashMap.get(modeltype);
        Objects.requireNonNull(model).setConfidenceScore(confidence);
    }

    public void removeConfidenceScore(ModelObserver observer) {
        MODELTYPE modeltype = observer.getModelType();
        if (modeltype == MODELTYPE.SKIP) return;
        Model model = modelHashMap.get(modeltype);
        Objects.requireNonNull(model).setConfidenceScore(0);
    }

    public void setMaxFPS(int fps, ModelManager.MODELTYPE modeltype) {
        modelHashMap.get(modeltype).setMaxfps(fps);
    }

    public enum MODELTYPE {
        FOOTBALLv16,
        POSENET,
        CENTERNET,
        SKIP,
        POSENET_FASTMODE,
        OLD_POSENET
    }

}
