package com.models;

public class FootBallv17CenterNet extends CenterNet {

    public FootBallv17CenterNet() {
        super("centernet-aug-v12-3-fp16.tflite",
                "football_labels.txt",
                0);
    }
}
