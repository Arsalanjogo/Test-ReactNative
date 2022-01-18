package com.models;

import android.util.Pair;

import com.google.android.odml.image.MlImage;
import com.utils.ExtendedMLImage;
import com.utils.InfoBlob;

public abstract class MLKitModel<T> extends Model {


    protected boolean processed = false;
    T detectionModel;
    Pair<MlImage, InfoBlob> preProcessed;

    public MLKitModel(float confscore) {
        super(confscore);
    }

    //Run Model
    @Override
    public void supplyFrameInternal(ExtendedMLImage mlImage) {
        InfoBlob infoBlob = new InfoBlob(mlImage);
        preProcessed = new Pair<>(mlImage.getMlImage(), infoBlob);
        processed = false;
        runModel();
    }

    public abstract Pair<MlImage, InfoBlob> preProcessImage(Pair<ExtendedMLImage, InfoBlob> extendedMlImageInfoBlobPair);

    public abstract void runModel();


}
