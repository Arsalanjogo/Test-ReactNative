package com.phases.instances;

import android.app.Activity;
import android.net.Uri;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import android.widget.VideoView;

import com.football433.R;
import com.phases.base.Phase;
import com.phases.phasemanager.PhaseManager;

import static com.activities.GameActivity.getActivity;


public class VideoPhase extends Phase {

    private VideoView videoView;
    private RelativeLayout mainContainer;
    private Button skipBtn;
    private Boolean isVideoCompleted = false;


    @Override
    public void process() {

    }

    @Override
    public boolean isDone() {
        return isVideoCompleted;
    }

    @Override
    public void initialize() {
        isVideoCompleted = false;
        Activity activity = getActivity();

        mainContainer = activity.findViewById(R.id.mainContainer);
        videoView = new VideoView(activity);
        skipBtn = new Button(activity);
        int dimenValueTen = activity.getResources().getDimensionPixelOffset(R.dimen.dimen_10);

        // Video View Layout Params
        LinearLayout.LayoutParams videoParams = new LinearLayout.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.MATCH_PARENT);
        videoView.setLayoutParams(videoParams);

        // Skip Button Layout Params
        RelativeLayout.LayoutParams btnParams = new RelativeLayout.LayoutParams(ViewGroup.LayoutParams.WRAP_CONTENT, ViewGroup.LayoutParams.WRAP_CONTENT);
        btnParams.addRule(RelativeLayout.ALIGN_PARENT_END);
        btnParams.addRule(RelativeLayout.ALIGN_PARENT_TOP);
        btnParams.setMargins(0, dimenValueTen, dimenValueTen, 0);
        skipBtn.setLayoutParams(btnParams);
        skipBtn.setPadding(dimenValueTen, dimenValueTen, dimenValueTen, dimenValueTen);
        skipBtn.setText(activity.getString(R.string.text_skip));

        String path = "android.resource://" + activity.getPackageName() + "/" + R.raw.sample;
        videoView.setVideoURI(Uri.parse(path));

        mainContainer.addView(videoView);
        mainContainer.addView(skipBtn);
        videoView.start();

        videoView.setOnCompletionListener(mp -> {
            cleanup();
        });

        skipBtn.setOnClickListener(sb -> {
            cleanup();
        });
    }

    @Override
    public void cleanup() {
        super.cleanup();
        mainContainer.removeView(videoView);
        mainContainer.removeView(skipBtn);
        isVideoCompleted = true;
    }

    @Override
    public PhaseManager.GamePhases getNextPhase() {
        return null;
    }

    @Override
    public PhaseManager.GamePhases getPrevPhase() {
        return null;
    }
}
