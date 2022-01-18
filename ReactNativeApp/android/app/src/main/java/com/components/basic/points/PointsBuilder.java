package com.components.basic.points;

import com.ssvc.SSVC;
import com.ssvc.SSVCBuilder;

public class PointsBuilder extends SSVCBuilder {

    static private PointsState buildState() {
        return new PointsState();
    }

    public static SSVC<PointsState, PointsView, PointsController> buildPoints() {
        PointsState state = buildState();
        PointsView pointsView = new PointsView(state);
        PointsController pointsController = new PointsController(state);
        return new SSVC<>(state, pointsView, pointsController);
    }

}
