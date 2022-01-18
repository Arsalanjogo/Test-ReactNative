package com.render.sounds;

import android.media.MediaPlayer;

import com.activities.GameActivity;
import com.utils.interfaces.NoArgMethod;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

public class SoundBase<T extends SoundBase<T>> {
    private static final Set<MediaPlayer> activePlayers = new HashSet<>();

    private final MediaPlayer mMediaPlayer;
    private final List<NoArgMethod> onEnd = new ArrayList<>();
    private boolean running = false;

    protected SoundBase(int sound) {
        mMediaPlayer = MediaPlayer.create(GameActivity.getActivity().getApplicationContext(), sound);
        activePlayers.add(mMediaPlayer);

        setSoundListeners();
    }

    public static void stopActivePlayers() {
        activePlayers.forEach(MediaPlayer::stop);
    }

    public void runningCheck() {
        if (running)
            throw new IllegalStateException("Cannot set methods on ephemeral animation after running");
    }

    public T play() {
        runningCheck();
        running = true;
        this.mMediaPlayer.start();
        return (T) this;
    }

    public T onEnd(NoArgMethod onEnd) {
        runningCheck();
        this.onEnd.add(onEnd);
        return (T) this;
    }

    public T speed(float speed) {
        runningCheck();
        this.mMediaPlayer.setPlaybackParams(mMediaPlayer.getPlaybackParams().setSpeed(speed));
        return (T) this;
    }

    private void setSoundListeners() {
        mMediaPlayer.setOnCompletionListener(mp -> {
            mp.release();
            activePlayers.remove(mp);
            onEnd.forEach(NoArgMethod::run);
        });
    }

    public void stop() {
        if (mMediaPlayer != null) {
            mMediaPlayer.stop();
        }
    }

}
