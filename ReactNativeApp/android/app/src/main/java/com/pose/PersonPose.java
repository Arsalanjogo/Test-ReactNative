//package com.pose;
//
//import com.components.detection.ObjectDetectionState;
//import com.components.detection.person.PersonState;
//import com.detection.ObjectDetection;
//import com.detection.person.PersonDetection;
//import com.location.DetectionLocation;
//import com.logger.SLOG;
//import com.utils.SMath;
//
//public class PersonPose extends Pose {
////    protected final PersonDetection person;
//
////    public PersonPose(PersonDetection person) {
////        this(person, null);
////    }
//
//    public PersonPose(PersonState person, String name) {
//        super(name);
//       // this.person = person;
//    }
//
//    public PersonPose person(PersonSubPose personSubPose, String tag) {
//        y(() -> personSubPose.match(person), tag);
//        return this;
//
//
//    }
//
//    public PersonPose minLegAngle(double angle) {
//        y(() -> person.leftLeg.getLegAngle() > angle && person.rightLeg.getLegAngle() > angle, "minLegAngle");
//        extraDraw(() -> "minLegAngle: L => " + person.leftLeg.getLegAngle() + " > " + angle + " R => " + person.rightLeg.getLegAngle() + " > " + angle);
//        return this;
//    }
//
//    public PersonPose maxLegAngle(double angle) {
//        y(() -> person.leftLeg.getLegAngle() < angle && person.rightLeg.getLegAngle() < angle, "maxLegAngle");
//        extraDraw(() -> "maxLegAngle: L => " + person.leftLeg.getLegAngle() + " < " + angle + " R => " + person.rightLeg.getLegAngle() + " < " + angle);
//        return this;
//    }
//
//    public PersonPose minShoulderAngle(double angle) {
//        y(() -> person.leftArm.getShoulderAngle() > angle && person.rightArm.getShoulderAngle() > angle, "minShoulderAngle");
//        extraDraw(() -> "minShoulderAngle: " + person.rightArm.getShoulderAngle());
//        return this;
//    }
//
//    public PersonPose maxShoulderAngle(double angle) {
//        y(() -> person.leftArm.getShoulderAngle() < angle && person.rightArm.getShoulderAngle() < angle, "maxShoulderAngle");
//        extraDraw(() -> "maxShoulderAngle: " + person.rightArm.getShoulderAngle());
//        return this;
//    }
//
//    public PersonPose maxArmAngle(double angle) {
//        y(() -> person.leftArm.getShoulderAngle() < angle && person.rightArm.getShoulderAngle() < angle, "maxShoulderAngle");
//        extraDraw(() -> "maxShoulderAngle: " + person.rightArm.getShoulderAngle());
//        return this;
//    }
//
//    public PersonPose hasBeenAbove(ObjectDetection o1, double val, int lookback) {
//        return hasBeenAbove(o1, () -> val, lookback);
//    }
//
//    public PersonPose hasBeenAbove(ObjectDetection o1, ObjectDetection o2, int lookback) {
//        y(() -> o1.getNDetectedLocations(lookback)
//                        .getMin(DetectionLocation::compareByY)
//                        .getY() < o2.getNDetectedLocations(lookback)
//                        .getMax(DetectionLocation::compareByY)
//                        .getY(),
//                () -> o1.getLabel() + "<" + o2.getLabel());
//        return this;
//    }
//
//    public PersonPose hasBeenAbove(ObjectDetection o1, NumberReference<? extends Number> nr, int lookback) {
//        y(() -> o1.getNDetectedLocations(lookback)
//                        .getMin(DetectionLocation::compareByY)
//                        .getY() < nr.get().doubleValue(),
//                () -> o1.getLabel() + "<" + String.format("%.2f", nr.get().doubleValue()));
//        return this;
//    }
//
//    private SubPose getSidewaysLeft() {
//        return () -> (person.leftArm.shoulder.getX() < person.leftLeg.hip.getX()
//                && person.rightArm.shoulder.getX() < person.leftLeg.getX()
//                && person.leftArm.shoulder.getX() < person.rightLeg.hip.getX()
//                && person.rightArm.shoulder.getX() < person.leftLeg.hip.getX());
//    }
//
//    private SubPose getSidewaysRight() {
//        return () -> (person.leftArm.shoulder.getX() > person.leftLeg.hip.getX()
//                && person.rightArm.shoulder.getX() > person.leftLeg.getX()
//                && person.leftArm.shoulder.getX() > person.rightLeg.hip.getX()
//                && person.rightArm.shoulder.getX() > person.leftLeg.hip.getX());
//    }
//
//    public PersonPose sideWaysLeft() {
//        y(getSidewaysLeft(), "sidewaysLeft");
//        return this;
//    }
//
//    public PersonPose sidewaysRight() {
//        y(getSidewaysLeft(), "sidewaysLeft");
//        return this;
//    }
//
//    public PersonPose upperBodySideWays() {
//        SubPose sidewaysLeft = getSidewaysLeft();
//        SubPose sidewaysRight = getSidewaysRight();
//        y(() -> (sidewaysLeft.match()
//                        || sidewaysRight.match()),
//                "sideways");
//        return this;
//    }
//
//    public PersonPose leftOf(ObjectDetection d1, NumberReference<? extends Number> valX) {
//        y(() -> d1.getX() < valX.get().doubleValue(), d1.getLabel() + "<" + valX.get().doubleValue());
//        return this;
//    }
//
//    public PersonPose rightOf(ObjectDetection d1, NumberReference<? extends Number> valX) {
//        y(() -> d1.getX() > valX.get().doubleValue(), d1.getLabel() + ">" + valX.get().doubleValue());
//        return this;
//    }
//
//    public PersonPose leftOf(ObjectDetection d1, double valX) {
//        y(() -> d1.getX() < valX, d1.getLabel() + "<" + valX);
//        return this;
//    }
//
//    public PersonPose rightOf(ObjectDetection d1, double valX) {
//        y(() -> d1.getX() > valX, d1.getLabel() + ">" + valX);
//        return this;
//    }
//
//    public PersonPose leftOf(ObjectDetection d1, ObjectDetection d2) {
//        y(() -> d1.getX() < d2.getX(), d1.getLabel() + "<" + d2.getLabel());
//        return this;
//    }
//
//    public PersonPose rightOf(ObjectDetection d1, ObjectDetection d2) {
//        y(() -> d1.getX() > d2.getX(), d1.getLabel() + ">" + d2.getLabel());
//        return this;
//    }
//
//    public PersonPose above(ObjectDetection d1, double valY) {
//        y(() -> d1.getY() < valY, d1.getLabel() + "<" + valY);
//        return this;
//    }
//
//    public PersonPose below(ObjectDetection d1, double valY) {
//        y(() -> d1.getY() > valY, d1.getLabel() + ">" + valY);
//        return this;
//    }
//
//    public PersonPose above(ObjectDetection d1, NumberReference<? extends Number> valY) {
//        y(() -> d1.getY() < valY.get().doubleValue(), d1.getLabel() + "<" + valY.get().doubleValue());
//        return this;
//    }
//
//    public PersonPose below(ObjectDetection d1, NumberReference<? extends Number> valY) {
//        y(() -> d1.getY() > valY.get().doubleValue(), d1.getLabel() + ">" + valY.get().doubleValue());
//        return this;
//    }
//
//    public PersonPose above(ObjectDetection d1, ObjectDetection d2) {
//        y(() -> d1.getY() < d2.getY(), d1.getLabel() + "<" + d2.getLabel());
//        return this;
//    }
//
//    public PersonPose below(ObjectDetection d1, ObjectDetection d2) {
//        y(() -> d1.getY() > d2.getY(), d1.getLabel() + ">" + d2.getLabel());
//        return this;
//    }
//
//    public PersonPose slopeXaxis(ObjectDetection o1, ObjectDetection o2, double min, double max) {
//        y(() -> {
//            double slope = SMath.calculateSlopeWithXAxis(o1, o2);
//            boolean a, b;
//            a = slope > min;
//            b = slope < max;
//            return a && b;
//
//        }, o1.getLabel() + "," + o2.getLabel());
//
//        extraDraw(() -> o1.getLabel() + "," + o2.getLabel() + ": " + SMath.calculateSlopeWithXAxis(o1, o2));
//        return this;
//    }
//
//    public PersonPose angle(ObjectDetectionState o1, ObjectDetectionState o2, ObjectDetectionState o3, Integer min, Integer max) {
//        y(() -> {
//            double ang = SMath.calculateAngle3Points(o1, o2, o3, false);
//            boolean a = true, b = true;
//            if (min != null) a = ang > min;
//            if (max != null) b = ang < max;
//            return a && b;
//
//        }, o1.getLabel() + "," + o2.getLabel() + "," + o3.getLabel());
//
//        extraDraw(() -> o1.getLabel() + "," + o2.getLabel() + "," + o3.getLabel() + ": " + SMath.calculateAngle3Points(o1, o2, o3, false));
//        return this;
//
//    }
//
//    public PersonPose angleXaxis(ObjectDetection o1, ObjectDetection o2, Integer min, Integer max) {
//        y(() -> {
//            double ang = SMath.calculateAngleWithXAxis(o1, o2);
//            boolean a = true, b = true;
//            if (min != null) a = ang > min;
//            if (max != null) b = ang < max;
//            return a && b;
//
//        }, o1.getLabel() + "," + o2.getLabel());
//
//        extraDraw(() -> o1.getLabel() + "," + o2.getLabel() + ": " + SMath.calculateAngleWithXAxis(o1, o2));
//        return this;
//
//    }
//
//    public PersonPose angleYaxis(ObjectDetection o1, ObjectDetection o2, Integer min, Integer max) {
//        y(() -> {
//            double ang = SMath.calculateAngleWithYAxis(o1, o2);
//            boolean a = true, b = true;
//            if (min != null) a = ang > min;
//            if (max != null) b = ang < max;
//            return a && b;
//
//        }, o1.getLabel() + "," + o2.getLabel());
//
//        extraDraw(() -> o1.getLabel() + "," + o2.getLabel() + ": " + SMath.calculateAngleWithYAxis(o1, o2));
//        return this;
//
//    }
//
//    public PersonPose isBodyUpright() {
//        /* doubt whether this is the correct approach
//         * TODO: This function is eligible for rewrite
//         *  */
//        y(() -> {
//
//            ObjectDetectionState shoulder = person.leftArm.shoulder.getY() < person.rightArm.shoulder.getY() ? person.leftArm.shoulder : person.rightArm.shoulder;
//            ObjectDetectionState hip = person.leftLeg.hip.getY() < person.rightLeg.hip.getY() ? person.leftLeg.hip : person.rightLeg.hip;
//
//            double xDifferenceSH = Math.abs(shoulder.getX() - hip.getX());
//            // get the difference of y axis of hip and shoulder
//            double yDifferenceSH = Math.abs(shoulder.getY() - hip.getY());
//            // if xDifference is higher then person is not standing
//            // if yDifference is higher then person is standing
//
//            return xDifferenceSH < yDifferenceSH;
//        }, "isPersonSit: ");
//        return this;
//    }
//
//    public PersonPose isBackFlat() {
//
//        y(() -> {
//                    double faceX = person.face.nose.getX();
//                    double shoulderX = person.leftArm.shoulder.getY() < person.rightArm.shoulder.getY() ? person.leftArm.shoulder.getX() : person.rightArm.shoulder.getX();
//                    double hipX = person.leftLeg.hip.getY() < person.rightLeg.hip.getY() ? person.leftLeg.hip.getX() : person.rightLeg.hip.getX();
//
//                    return (faceX < shoulderX && shoulderX < hipX) || (faceX > shoulderX && shoulderX > hipX);
//                },
//                "isPersonLayingDown: ");
//
//        return this;
//    }
//
//    public PersonPose isPersonLayingFlat() {
//        y(() -> {
//                    // highest hip
//                    DetectionLocation highestHip = person.leftLeg.hip.getY() < person.rightLeg.hip.getY() ? person.leftLeg.hip.getDetectedLocation() : person.rightLeg.hip.getDetectedLocation();
//                    // highest shoulder
//                    DetectionLocation highestShoulder = person.leftArm.shoulder.getY() < person.rightArm.shoulder.getY() ? person.leftArm.shoulder.getDetectedLocation() : person.rightArm.shoulder.getDetectedLocation();
//                    // lowest shoulder
//                    DetectionLocation lowestShoulder = person.leftArm.shoulder.getY() > person.rightArm.shoulder.getY() ? person.leftArm.shoulder.getDetectedLocation() : person.rightArm.shoulder.getDetectedLocation();
//
//                    // distance between shoulders
//                    double shoulderDistance = highestShoulder.getEuclideanDistance(lowestShoulder);
//                    // distance between hip and shoulder
//                    double hipShoulderDistance = highestHip.getEuclideanDistance(highestShoulder);
//                    // if shoulder distance is greater than the half of hipShoulderDistance then person is laying down flat.
//                    SLOG.d("distance of hip and shoulder: " + shoulderDistance + " , " + hipShoulderDistance / 2f);
//                    return (shoulderDistance >= (hipShoulderDistance / 2f));
//                },
//                "isPersonLayingFlat: ");
//
//        return this;
//    }
//
//    public PersonPose isStandingStraight() {
//        y(() -> {
//            double minAngle = 169;
//            double maxAngle = 182;
//            double leftSideAngle = SMath.calculateAngle3Points(person.leftArm.shoulder, person.leftLeg.hip, person.leftLeg.knee, false);
//            double rightSideAngle = SMath.calculateAngle3Points(person.rightArm.shoulder, person.rightLeg.hip, person.rightLeg.knee, false);
//            boolean a = leftSideAngle >= minAngle;
//            boolean b = leftSideAngle <= maxAngle;
//            boolean c = rightSideAngle >= minAngle;
//            boolean d = rightSideAngle <= maxAngle;
//            return a && b && c && d;
//        }, "isStandingStraight: ");
//        extraDraw(() -> "leftSideAngle: " + SMath.calculateAngle3Points(person.leftArm.shoulder, person.leftLeg.hip, person.leftLeg.knee, false) + " rightSideAngle: " + SMath.calculateAngle3Points(person.rightArm.shoulder, person.rightLeg.hip, person.rightLeg.knee, false));
//        return this;
//    }
//
//    public PersonPose leftLegCloserToHips() {
//        y(() -> {
//            double lAnkleHip = person.leftLeg.ankle
//                    .getDetectedLocation()
//                    .getEuclideanDistance(person.leftLeg.hip.getDetectedLocation());
//            double rAnkleHip = person.rightLeg.ankle
//                    .getDetectedLocation()
//                    .getEuclideanDistance(person.rightLeg.hip.getDetectedLocation());
//            return lAnkleHip < rAnkleHip;
//        }, "leftLegCloserToHips: ");
//        return this;
//    }
//
//    public PersonPose rightLegCloserToHips() {
//        y(() -> {
//            double lAnkleHip = person.leftLeg.ankle
//                    .getDetectedLocation()
//                    .getEuclideanDistance(person.leftLeg.hip.getDetectedLocation());
//            double rAnkleHip = person.rightLeg.ankle
//                    .getDetectedLocation()
//                    .getEuclideanDistance(person.rightLeg.hip.getDetectedLocation());
//            return rAnkleHip < lAnkleHip;
//        }, "rightLegCloserToHips: ");
//        return this;
//    }
//
//    public PersonPose minSingleLegAngle(double angle) {
//        y(() -> person.leftLeg.getLegAngle() > angle || person.rightLeg.getLegAngle() > angle, "minLegAngle");
//        extraDraw(() -> "minLegAngle: L => " + person.leftLeg.getLegAngle() + " > " + angle + " R => " + person.rightLeg.getLegAngle() + " > " + angle);
//        return this;
//    }
//
//    public PersonPose maxSingleLegAngle(double angle) {
//        y(() -> person.leftLeg.getLegAngle() < angle || person.rightLeg.getLegAngle() < angle, "maxLegAngle");
//        extraDraw(() -> "maxLegAngle: L => " + person.leftLeg.getLegAngle() + " < " + angle + " R => " + person.rightLeg.getLegAngle() + " < " + angle);
//        return this;
//    }
//
//    public PersonPose minSingleKneeAngle(double angle) {
//        y(() -> {
//                    double lKneeAngle = person.leftLeg.getKneeAngle();
//                    double rKneeAngle = person.rightLeg.getKneeAngle();
//                    return lKneeAngle > angle || rKneeAngle > angle;
//                },
//                "minKneeAngle");
//        extraDraw(() -> "minKneeAngle: L => " + person.leftLeg.getKneeAngle() + " > " + angle + " R => " + person.rightLeg.getKneeAngle() + " > " + angle);
//        return this;
//    }
//
//    public PersonPose maxSingleKneeAngle(double angle) {
//        y(() -> {
//                    double lKneeAngle = person.leftLeg.getKneeAngle();
//                    double rKneeAngle = person.rightLeg.getKneeAngle();
//                    return lKneeAngle < angle || rKneeAngle < angle;
//                },
//                "maxKneeAngle");
//        extraDraw(() -> "maxKneeAngle: L => " + person.leftLeg.getKneeAngle() + " < " + angle + " R => " + person.rightLeg.getKneeAngle() + " < " + angle);
//        return this;
//    }
//
//    public interface PersonSubPose {
//        boolean match(PersonDetection person);
//    }
//
//    public interface NumberReference<T extends Number> {
//        T get();
//    }
//
//
//}