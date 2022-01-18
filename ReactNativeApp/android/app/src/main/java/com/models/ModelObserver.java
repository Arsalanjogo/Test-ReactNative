package com.models;

import com.location.DetectionLocation;
import com.utils.InfoBlob;

import java.util.List;

public interface ModelObserver {
    void parse(List<DetectionLocation> locations, InfoBlob infoBlob);

    void setModel(ObservableModel model);

    ModelManager.MODELTYPE getModelType();


}
