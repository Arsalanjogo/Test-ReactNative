package com.phases.instances;

import android.graphics.Color;
import android.view.View;
import android.widget.Button;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.activities.GameActivity;
import com.components.games.base.GameContext;
import com.football433.R;
import com.logger.SLOG;
import com.phases.base.Phase;
import com.phases.phasemanager.PhaseManager;
import com.render.lottie.LottieRender;
import com.render.sounds.SoundRender;

import java.util.Objects;

public class EndOfGamePhase extends Phase {

    RelativeLayout container;
    Button restartButton;
    TextView scoreTv;
    int gameScore = 0;
    LottieRender wellDoneLottie;
    boolean successMode = false;
    private String btnTextToDisplay = "";
    Button shareBtn;

    @Override
    public void process() {

    }

    @Override
    public void initialize() {
        this.prevPhase = PhaseManager.GamePhases.GAME_PHASE;
        this.nextPhase = PhaseManager.GamePhases.CLEANUP_PHASE;

        GameActivity.getActivity().hideButtons(); // todo need discussion

        SLOG.d("gameContextscore " + GameContext.getContext().getRelevantGameInfo());

        if (GameContext.getContext() != null && GameContext.getContext().getRelevantGameInfo().containsKey("score")) {
            gameScore = Integer.parseInt(Objects.requireNonNull(GameContext.getContext().getRelevantGameInfo().getOrDefault("score", "2")));
        } else {
            gameScore = 6;
        }
        initializeViews();
        determineSuccessOrFailure();
        initializeListeners();
        new SoundRender(R.raw.game_end_posiive).play();
    }

    private void determineSuccessOrFailure() {

            successMode = true;
            btnTextToDisplay = "Try Again";
            wellDoneLottie = new LottieRender(R.raw.well_done_screen).background(Color.BLACK).ephemeral(false)
                    .onStart(()-> {GameActivity.getActivity().runOnUiThread(()->restartButton.setVisibility(View.VISIBLE));
                        GameActivity.getActivity().runOnUiThread(()-> shareBtn.setVisibility(View.VISIBLE));
                    })
                    .onEnd(()-> { GameActivity.getActivity().runOnUiThread(()->restartButton.setVisibility(View.INVISIBLE));
                        GameActivity.getActivity().runOnUiThread(()-> shareBtn.setVisibility(View.INVISIBLE));
                                 completed = true;
                    })
                    .setScale(2.0, 2.0)
                    .background(Color.BLACK)
                    .play();

        GameActivity.getActivity().runOnUiThread(() -> scoreTv.setText(Integer.toString(gameScore)));
        GameActivity.getActivity().runOnUiThread(() -> restartButton.setText(btnTextToDisplay));
    }


    private void initializeListeners() {
        restartButton.setOnClickListener(v -> GameActivity.getActivity().restart());
    }

    private void initializeViews() {

        container = GameActivity.getActivity().findViewById(R.id.endOfExerciseContainer);
        restartButton = GameActivity.getActivity().findViewById(R.id.tryAgain);
        scoreTv = GameActivity.getActivity().findViewById(R.id.scoreTv);
        shareBtn = GameActivity.getActivity().findViewById(R.id.share);
        GameActivity.getActivity().runOnUiThread(() -> container.setVisibility(View.VISIBLE));
    }

    @Override
    public boolean isDone() {
        return completed;
    }

    @Override
    public void cleanup() {
        super.cleanup();
        if (successMode) {
            wellDoneLottie.delete();
        }

        GameActivity.getActivity().runOnUiThread(() -> container.setVisibility(View.GONE));
        GameActivity.getActivity().runOnUiThread(() -> container.setBackgroundResource(0));
    }

    @Override
    public PhaseManager.GamePhases getNextPhase() {
        return this.nextPhase;
    }

    @Override
    public PhaseManager.GamePhases getPrevPhase() {
        return this.prevPhase;
    }
}

