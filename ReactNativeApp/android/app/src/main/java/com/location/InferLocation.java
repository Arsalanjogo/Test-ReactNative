package com.location;

import java.util.List;

public abstract class InferLocation {
    public abstract void infer(List<DetectionLocation> before, DetectionLocation known);

}
