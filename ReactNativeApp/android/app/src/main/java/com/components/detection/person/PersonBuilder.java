package com.components.detection.person;

import com.models.ModelManager;
import com.ssvc.SSVC;
import com.ssvc.SSVCBuilder;

public class PersonBuilder extends SSVCBuilder {
    static PersonState buildState(ModelManager.MODELTYPE modelType) {
        return new PersonState(modelType);
    }

    public static SSVC<PersonState, PersonView, PersonController> buildPersonDetection(ModelManager.MODELTYPE modelType) {
        PersonState state = buildState(modelType);
        PersonView personView = new PersonView(state);
        PersonController personController = new PersonController(state);
        return new SSVC<>(state, personView, personController);
    }
}