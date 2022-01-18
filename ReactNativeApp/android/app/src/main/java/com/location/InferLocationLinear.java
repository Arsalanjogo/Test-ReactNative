package com.location;

import java.util.ArrayList;
import java.util.List;
import java.util.stream.IntStream;

public class InferLocationLinear extends InferLocation {


    @Override
    public void infer(List<DetectionLocation> beforeList, DetectionLocation after) {
        DetectionLocation knownBefore = null;
        List<DetectionLocation> unknown = new ArrayList<>();


        //because we are going backwards, we should prepend
        for (int idx = beforeList.size() - 1; idx >= 0; idx--) {
            if (beforeList.get(idx).locationKnown()) {
                knownBefore = beforeList.get(idx);
                break;
            } else unknown.add(0, beforeList.get(idx));
        }

        if (knownBefore == null || unknown.isEmpty()) return;

        double centerXStep = (after.getX() - knownBefore.getX()) / ((double) unknown.size() + 1);
        double centerYStep = (after.getY() - knownBefore.getY()) / ((double) unknown.size() + 1);

//        for (int i = 0; i < unknown.size(); i++) {
//            unknown.get(i).updateLocation(
//                    knownBefore.getX() + centerXstep * (i + 1),
//                    knownBefore.getY() + centerYstep * (i + 1),
//                    DetectionLocation.STATUS.INFERRED
//            );
//        }

        double knownBeforeX = knownBefore.getX();
        double knownBeforeY = knownBefore.getY();

        IntStream.range(0, unknown.size()).forEach(idx -> unknown.get(idx).updateLocation(
                knownBeforeX + centerXStep * (idx + 1),
                knownBeforeY + centerYStep * (idx + 1),
                DetectionLocation.STATUS.INFERRED
        ));
    }

}

