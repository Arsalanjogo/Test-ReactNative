package com.components.games.instances.juggling;

import com.components.basic.points.PointsController;
import com.components.basic.streak.StreakController;
import com.components.detection.ball.BallDetectionController;
import com.components.detection.person.PersonController;
import com.components.games.base.GameContext;
import com.football433.R;
import com.location.DetectionLocation;
import com.logger.SLOG;
import com.render.sounds.SoundRender;
import com.ssvc.Controller;
import com.utils.ExerciseStatsJsonManager;
import com.utils.GamesEventPacket;
import com.utils.UtilArrayList;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

public class JugglingController extends Controller<JugglingState> {

    BallDetectionController ballController;
    PersonController personController;
    PointsController pointsController;
    StreakController streakController;

    String JUGGLE_DETECTED = "juggleDetected";
    String GROUND_TOUCHED = "groundTouched";

    public JugglingController(JugglingState state, BallDetectionController ballController, PersonController personController, PointsController pointsController,StreakController streakController) {
        super(state);
        this.ballController = ballController;
        this.personController = personController;
        this.pointsController = pointsController;
        this.streakController = streakController;
    }

    protected boolean determineJuggle() {
        /* the Idea is as follows:
         * A juggle is a low between two peaks / highs.
         *
         * This means that we can detect a juggle by selecting the two highest peaks, and the lowest valley.
         * If the distance between these peaks is high enough, we can see this as a juggle.
         *
         * However, because we are working in frame coordinates, everything is flipped,
         * hence we are looking for peaks instead of juggles.
         */
        state.bounce = false;
        double threshold = Math.min(ballController.getHeight(), ballController.getWidth())/1.8;

        boolean bounceCondition = didFootTouch();

        int newBounceId = ballController.didBounceY(state.determineBounceStartID, threshold);

        //we set the minframeid to low2, this ensures we an only process after the current bounce
        if (newBounceId > state.lastBounceID && bounceCondition) {
            state.lastBounceID = newBounceId;
            state.determineBounceStartID = state.lastBounceID + state.BALL_COOL_DOWN;
            state.bounce = true;
        }

        return state.bounce;
    }

    protected void validJuggle() {
        state.lastBounceID = GameContext.getContext().infoBlobArrayList.getLast().getFrameID();
        Integer score = this.streakController.getStreakPoint( 1,  true);
        this.pointsController.addPoints(score, ballController.getX(), ballController.getY());
        new Runnable() {
            public void run() {
                ExerciseStatsJsonManager.get().insertEvent(
                        new GamesEventPacket(JUGGLE_DETECTED, state.lastBounceID,
                                ballController.getBounceRange() / 2, ballController.getBounceRange() / 2, new ArrayList<>(Arrays.asList("BALL", "LEFT_ANKLE", "RIGHT_ANKLE"))));

            }
        };
    }


    protected boolean isGroundTouched() {
        List<DetectionLocation> ballLocations = GameContext.getContext().ball.state.getNDetectedLocations(state.BALL_ON_GROUND_COUNTER);
        if (ballLocations == null) return false;
        return ballLocations.stream().noneMatch(location -> location.getY() + (GameContext.getContext().ball.state.getHeight() / 2f) < state.groundLine);
    }

    protected void groundLineTouched() {
        state.determineBounceStartID = GameContext.getContext().infoBlobArrayList.getLast().getFrameID() + state.GROUND_LINE_TOUCHED_COOL_DOWN;

        if (streakController.getCurrentStreakLevel() == 1)
            streakController.resetEventsInCurrentStreak();
        else if (streakController.getCurrentStreakLevel() > 1) streakController.resetStreak();

        new Runnable() {
            public void run() {
                ExerciseStatsJsonManager.get().insertEvent(
                        new GamesEventPacket(GROUND_TOUCHED, GameContext.getContext().infoBlobArrayList.getLast().getFrameID(),
                                1, 1, new ArrayList<>(Arrays.asList("BALL", "LEFT_ANKLE", "RIGHT_ANKLE"))));
            }
        };

    }


    private boolean didFootTouch() {
        // return true if ball is below the knee once to prevent hand use.
        UtilArrayList<DetectionLocation> ballLocations = GameContext.getContext().ball.state.getDetectedLastN(state.FOOT_DETECT_RANGE);
        boolean res = ballLocations.stream().anyMatch(bLoc -> bLoc.getY() >= Math.min(state.leftKneeLoc, state.rightKneeLoc));
        SLOG.d("below the knee:" + res);
        return res;
    }


    public void process() {

        // get highest knee location of ankles
        state.leftAnkleY = GameContext.getContext().person.state.leftLeg.ankle.getDetectedLocation().getY();
        state.rightAnkleY = GameContext.getContext().person.state.rightLeg.ankle.getDetectedLocation().getY();

        state.groundLine = GameContext.getContext().person.controller.getGroundLine();

        UtilArrayList<DetectionLocation> leftKneeLocations = GameContext.getContext().person.state.leftLeg.knee.getNDetectedLocations(3);
        UtilArrayList<DetectionLocation> rightKneeLocations = GameContext.getContext().person.state.rightLeg.knee.getNDetectedLocations(3);

        state.leftKneeLoc = leftKneeLocations.getMin(DetectionLocation::compareByY).getY();
        state.rightKneeLoc = rightKneeLocations.getMin(DetectionLocation::compareByY).getY();

        if (GameContext.getContext().infoBlobArrayList.getLast() == null) {
            return;
        }

        state.determineBounceRange = Math.max(GameContext.getContext().infoBlobArrayList.getLast().getFrameID() -
                Math.max(state.determineBounceStartID, state.lastBounceID), 0);

        SLOG.d("bounce range: " + state.determineBounceRange);

        // if determineBounceRange is 0 then don't proceed.
        if (state.determineBounceRange == 0) return;

        if (isGroundTouched()) {
            groundLineTouched();
            return;
        }
        processRandomFoot();
    }

    private void processRandomFoot() {
        if (determineJuggle()) {
            validJuggle();
        }
    }


    @Override
    public String getDebugText() {
        return "JugglingController";
    }
}
