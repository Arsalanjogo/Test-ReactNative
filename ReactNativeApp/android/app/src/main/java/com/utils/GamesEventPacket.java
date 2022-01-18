package com.utils;

import java.util.ArrayList;

public class GamesEventPacket {

    String eventName;
    int frameID;
    int lookBackFrames;
    int foreSeeFrames;
    ArrayList<String> objectNames;


    public GamesEventPacket(String eventName, int frameID, int lookBackFrames, int foreSeeFrames,
                            ArrayList<String> objectNames) {
        this.eventName = eventName;
        this.frameID = frameID;
        this.lookBackFrames = lookBackFrames;
        this.foreSeeFrames = foreSeeFrames;
        this.objectNames = objectNames;
    }

}
