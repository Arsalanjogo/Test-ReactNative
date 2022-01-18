package com.football433;

public class GameSettings {

    String description;
    String title;
    String payLoad;
    boolean isCamera ;
    int cameraFacing;
    String orientation;

    public String getDescription() {
        return description;
    }

    public String getTitle() {
        return title;
    }

    public String getPayLoad() {
        return payLoad + ".json";
    }

    public boolean isCamera() {
        return isCamera;
    }

    public int getCameraFacing() {
        return cameraFacing;
    }

    public String getOrientation() {
        return orientation;
    }


}
