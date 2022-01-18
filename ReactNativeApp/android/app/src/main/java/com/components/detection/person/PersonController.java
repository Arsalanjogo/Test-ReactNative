package com.components.detection.person;

import com.components.detection.ObjectDetectionState;
import com.components.detection.person.bodyPartDetection.ArmState;
import com.location.DetectionLocation;
import com.logger.SLOG;
import com.ssvc.Controller;
import com.utils.SMath;
import com.utils.UtilArrayList;

public class PersonController extends Controller<PersonState> {

    protected static final float EXTENSION_THRESHOLD = 0.90f;
    final int GROUND_LOOKBACK = 6, HEAD_LOOKBACK = 6;
    public DetectionLocation highestLeftAnkle, highestRightAnkle, lowestLeftHeel, lowestRightHeel, lowestHighLeftHeel, lowestHighRightHeel;
    protected double MIN_JUMP = 0.04;
    int JUMP_LOOKBACK = 15;
    float scaler = 10;

    public PersonController(PersonState state) {
        super(state);
    }

    public int didJump(int lastJumpFrameID) {
        if (state.getInfoBlobArrayList().size() < JUMP_LOOKBACK) return 0;
        int lastFrameID = state.getInfoBlobArrayList().getLast().getFrameID();

        final int JUMP_FRAME_GAP = 2;

        UtilArrayList<DetectionLocation> leftHeels = state.leftLeg.heel.getNDetectedLocations(Math.min(JUMP_LOOKBACK, lastFrameID - lastJumpFrameID));
        UtilArrayList<DetectionLocation> rightHeels = state.rightLeg.heel.getNDetectedLocations(Math.min(JUMP_LOOKBACK, lastFrameID - lastJumpFrameID));
        lowestLeftHeel = leftHeels.getMin(DetectionLocation::compareByY);
        lowestRightHeel = rightHeels.getMin(DetectionLocation::compareByY);
        int leftHighIndex = leftHeels.indexOf(lowestLeftHeel);
        int rightHighIndex = rightHeels.indexOf(lowestRightHeel);

        // Lowest Ankle (by Position)
        UtilArrayList<DetectionLocation> leftAnkles = new UtilArrayList<>(leftHeels.size());
        leftAnkles.addAll(leftHeels.subList(0, leftHighIndex));
        UtilArrayList<DetectionLocation> rightAnkles = new UtilArrayList<>(rightHeels.size());
        rightAnkles.addAll(rightHeels.subList(0, rightHighIndex));
        highestLeftAnkle = leftAnkles.getMax(DetectionLocation::compareByY);
        highestRightAnkle = rightAnkles.getMax(DetectionLocation::compareByY);


        // Lowest Heel after Highest Heel (by Position)       => Downward Motion
        UtilArrayList<DetectionLocation> leftHighHeels = new UtilArrayList<>(leftHeels.size());
        leftHighHeels.addAll(leftHeels.subList(leftHighIndex + 1, leftHeels.size()));
        UtilArrayList<DetectionLocation> rightHighHeels = new UtilArrayList<>(rightHeels.size());
        rightHighHeels.addAll(rightHeels.subList(rightHighIndex + 1, rightHeels.size()));
        lowestHighLeftHeel = leftHighHeels.getMax(DetectionLocation::compareByY);
        lowestHighRightHeel = rightHighHeels.getMax(DetectionLocation::compareByY);
        //if the heel is lower(so actually higher...) than the ankle, we can consider this a jump


        if (
                (lowestLeftHeel != null && lowestRightHeel != null && lowestHighLeftHeel != null
                        && lowestHighRightHeel != null && highestLeftAnkle != null && highestRightAnkle != null)
                        && (
                        ((lowestLeftHeel.getY() + MIN_JUMP) < highestLeftAnkle.getY() && (lowestRightHeel.getY() + MIN_JUMP) < highestRightAnkle.getY()) &&
                                ((lowestHighLeftHeel.getY() - MIN_JUMP) > lowestLeftHeel.getY() && (lowestHighRightHeel.getY() - MIN_JUMP) > lowestRightHeel.getY())
                                && ((Math.max(lowestHighLeftHeel.getFrameID(), lowestHighRightHeel.getFrameID())) - lastJumpFrameID <= JUMP_FRAME_GAP)
                )
        ) {
            SLOG.d("DIDJUMP: " + lowestLeftHeel.getY() + " < " + highestLeftAnkle.getY() + " && " + lowestRightHeel.getY() + " < " + highestRightAnkle.getY() + " && " + lowestHighLeftHeel.getY() + " > " + lowestLeftHeel.getY() + " && " + lowestHighRightHeel.getY() + " > " + lowestRightHeel.getY());
            SLOG.d("DIDJUMP LastFrame: " + lastJumpFrameID + "  FrameID: " + Math.max(lowestHighLeftHeel.getFrameID(), lowestHighRightHeel.getFrameID()));

            return lastJumpFrameID;
        } else {
            return Math.max(lowestLeftHeel.getFrameID(), lowestRightHeel.getFrameID());
        }
    }

    public double getGroundLine() {

        UtilArrayList<DetectionLocation> leftAnkleLocations = state.leftLeg.ankle.getNDetectedLocations(GROUND_LOOKBACK);
        UtilArrayList<DetectionLocation> rightAnkleLocations = state.rightLeg.ankle.getNDetectedLocations(GROUND_LOOKBACK);

        return Math.max(leftAnkleLocations.getMax(DetectionLocation::compareByY).getY(), rightAnkleLocations.getMax(DetectionLocation::compareByY).getY());
    }

    public double getHeadLine() {

        UtilArrayList<DetectionLocation> leftEyeLocations = state.face.leftEye.getNDetectedLocations(HEAD_LOOKBACK);
        UtilArrayList<DetectionLocation> rightEyeLocations = state.face.rightEye.getNDetectedLocations(HEAD_LOOKBACK);

        return Math.min(leftEyeLocations.getMin(DetectionLocation::compareByY).getY(), rightEyeLocations.getMin(DetectionLocation::compareByY).getY());

    }

    public boolean inFrame() {
        return state.getDetectionSubClasses().stream().allMatch(ObjectDetectionState::inFrame);
    }

    public double getElbowFlexion(ArmState arm) {
        DetectionLocation shoulderLocation = arm.shoulder.getDetectedLocation();
        DetectionLocation elbowLocation = arm.elbow.getDetectedLocation();
        DetectionLocation wristLocation = arm.wrist.getLocation();
        return SMath.calculateAngle3Points(shoulderLocation, elbowLocation, wristLocation, false);
    }

    public double getLeftElbowFlexion() {
        return getElbowFlexion(state.leftArm);
    }

    public double getRighElbowFlexion() {
        return getElbowFlexion(state.rightArm);
    }

    public double getSideWaysExtendedCosine(ArmState arm) {
        //if the arm is extended, the cosine similarity between the shoulder-elbow and shoulder-wrist should be high
        DetectionLocation elbowD = arm.elbow.getDetectedLocation();
        DetectionLocation wristD = arm.wrist.getDetectedLocation();
        DetectionLocation shoulderD = arm.shoulder.getDetectedLocation();
        if (elbowD == null || wristD == null || shoulderD == null) return 0;
        //calculate the cosine similarity
        double shoulderX = shoulderD.getX();
        double shoulderY = shoulderD.getY();

        double scaledElbowX = (elbowD.getX() - shoulderX) * scaler;
        double scaledElbowY = (elbowD.getY() - shoulderY) * scaler;
        double scaledWristX = (wristD.getX() - shoulderX) * scaler;
        double scaledWristY = (wristD.getY() - shoulderY) * scaler;


        double xsim = (scaledElbowX) * (scaledWristX);
        double ysim = (scaledElbowY) * (scaledWristY);
        double enorm = Math.sqrt(Math.pow(scaledElbowX, 2) + Math.pow(scaledElbowY, 2));
        double wnorm = Math.sqrt(Math.pow(scaledWristX, 2) + Math.pow(scaledWristY, 2));

        double cosineSim = ((xsim + ysim) / (enorm * wnorm));
        SLOG.d("xsim: " + xsim + "ysim: " + ysim + "wnorm: " + wnorm + "enorm: " + enorm + "cosine: " + cosineSim);
        return cosineSim;

    }

    public boolean isleftArmSidewaysExtended() {
        return getSideWaysExtendedCosine(state.leftArm) > EXTENSION_THRESHOLD;
    }

    public boolean isrightArmSidewaysExtended() {
        return getSideWaysExtendedCosine(state.rightArm) > EXTENSION_THRESHOLD;
    }


    @Override
    public String getDebugText() {
        return "PersonController";
    }
}
