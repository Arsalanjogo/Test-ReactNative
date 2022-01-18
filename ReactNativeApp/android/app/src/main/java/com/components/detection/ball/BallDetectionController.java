package com.components.detection.ball;

import com.location.DetectionLocation;
import com.ssvc.Controller;
import com.utils.UtilArrayList;

import java.util.Comparator;
import java.util.stream.Collectors;

public class BallDetectionController extends Controller<BallDetectionState> {

    protected int DETERMINE_BOUNCE_RANGE = 20;

    public BallDetectionController(BallDetectionState state) {
        super(state);
    }

    private boolean determineBounceX(DetectionLocation high, DetectionLocation low1, DetectionLocation low2, double threshold) {
        // threshold is the size of ball
        return (Math.abs(high.getX() - low1.getX()) > threshold) && (Math.abs(high.getX() - low2.getX()) > threshold);
    }

    private boolean determineBounceY(DetectionLocation high, DetectionLocation low1, DetectionLocation low2, double threshold) {
        // threshold is the size of ball
        return (Math.abs(high.getY() - low1.getY()) > threshold) && (Math.abs(high.getY() - low2.getY()) > threshold);
    }

    public int didBounceX(BallDetectionState.ORIENTATION orientation, int frameID) {
        return didBounceX(orientation, frameID, Math.max(state.getHeight(), state.getWidth()));
    }


    public int didBounceX(BallDetectionState.ORIENTATION orientation, int frameID, double threshold) {
        // ALONG X AXIS
        return didBounce(true, frameID, threshold, orientation, DetectionLocation::compareByX);

    }

    public int getBounceRange() {
        return DETERMINE_BOUNCE_RANGE;
    }

    public int didBounceY(int frameID) {
        return didBounceY(frameID, Math.max(state.getHeight(), state.getWidth()));
    }

    public int didBounceY(final int frameID, double threshold) {
        return didBounce(false, frameID, threshold, BallDetectionState.ORIENTATION.ANY, DetectionLocation::compareByY);
    }


    public int didBounce(boolean alongXAxis, int frameID, double threshold, BallDetectionState.ORIENTATION orientation, Comparator<DetectionLocation> compare) {

        state.bounce = false;

        //  state.lastBounceID = frameID; todo is this required??? will see

        UtilArrayList<DetectionLocation> ballLocations = state.getNLocations(DETERMINE_BOUNCE_RANGE);
        if (ballLocations == null) return frameID;

        ballLocations = ballLocations.stream()
                .filter(DetectionLocation::locationKnown)
                .filter(bLoc -> bLoc.getFrameID() > frameID)
                .collect(Collectors.toCollection(UtilArrayList::new));

        if (ballLocations.isEmpty()) {
            return frameID;
        }
        DetectionLocation supportPoint1 = null, inflectionPoint = null, supportPoint2 = null;

        int highIndex;

        UtilArrayList<DetectionLocation> ballLow1Locations = new UtilArrayList<>();
        UtilArrayList<DetectionLocation> ballLow2Locations = new UtilArrayList<>();

        //find the highest point, this is the potential juggle
        inflectionPoint = orientation == BallDetectionState.ORIENTATION.RIGHT ? ballLocations.getMin(compare) : ballLocations.getMax(compare);
        highIndex = ballLocations.indexOf(inflectionPoint);

        // find supportPoint1:
        ballLow1Locations.addAll(ballLocations.subList(0, highIndex));
        supportPoint1 = orientation == BallDetectionState.ORIENTATION.RIGHT ? ballLow1Locations.getMax(compare) : ballLow1Locations.getMin(compare);

        // find supportPoint2:
        ballLow2Locations.addAll(ballLocations.subList(highIndex + 1, ballLocations.size()));
        supportPoint2 = orientation == BallDetectionState.ORIENTATION.RIGHT ? ballLow2Locations.getMax(compare) : ballLow2Locations.getMin(compare);

        if (supportPoint1 == null || supportPoint2 == null) return frameID;

        state.bounce = determineBounceY(inflectionPoint, supportPoint1, supportPoint2, threshold);

        if (state.bounce) {
            state.lastBounceID = inflectionPoint.getFrameID();
            // the followings are used for plotting the points to visualize the peaks
            state.low1pt = supportPoint1;
            state.low2pt = supportPoint2;
            state.highPt = inflectionPoint;
        }

        return state.lastBounceID;

    }

    public double getWidth() {
        return state.width;
    }

    public double getX() {
        return state.getX();
    }

    public double getY() {
        return state.getY();
    }

    public double getHeight() {
        return state.height;
    }

    @Override
    public String getDebugText() {
        return "BallDetectionController";
    }
}
