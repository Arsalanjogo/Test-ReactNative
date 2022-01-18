package com.models;

import android.content.Context;

import com.location.DetectionLocation;
import com.utils.ExtendedMLImage;
import com.utils.InfoBlob;

import java.io.IOException;
import java.util.List;

public interface ObservableModel {

    void addObservers(List<ModelObserver> observers);

    void addObserver(ModelObserver observer);

    void removeObserver(ModelObserver observer);

    void notifyListeners(List<DetectionLocation> locations, InfoBlob infoBlob);

    void loadModel(Context context) throws IOException;

    void supplyFrame(ExtendedMLImage mlImage);

    void start();

    void stop();

}
