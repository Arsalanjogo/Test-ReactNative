package com.components.basic.timer;


import android.os.SystemClock;
import android.speech.tts.TextToSpeech;

import com.activities.GameActivity;
import com.logger.SLOG;
import com.render.lottie.LottieTimerCountDown;
import com.ssvc.Controller;

import java.util.Locale;

public class TimerController extends Controller<TimerState> {

    final static int SCHEDULER_DELAY = 1000;
    final static int SCHEDULER_PERIOD = 1000;
    private static final int ONE_SEC = 1;
    private static final int FIVE_SEC = 5;
    TextToSpeech mTTS;
    int countDown = 5;
    boolean countDownAudioInitiated = false;

    public TimerController(TimerState state) {
        super(state);
        initTTS();
        initiateScheduler();
        state.running = true;
        state.startTime = SystemClock.elapsedRealtime();
    }


    private void initTTS() {
        mTTS = new TextToSpeech(GameActivity.getActivity().getApplicationContext(), status -> {
            if (status == TextToSpeech.SUCCESS) {
                int result = mTTS.setLanguage(Locale.CANADA);

                if (result == TextToSpeech.LANG_NOT_SUPPORTED || result == TextToSpeech.LANG_MISSING_DATA) {
                    SLOG.d("TTS", "Language not supported!");
                } else if (result == TextToSpeech.LANG_AVAILABLE) {
                    state.running = true;
                }
            } else {
                SLOG.d("TTS", "Initialization failed!");
            }
        });
        mTTS.setPitch(0.7f);
    }


    private void initiateScheduler() {
        state.sTimer.scheduleInfinite(this::process, 33);
    }

    private void initiateCountdownAudio() {
        // last 5 seconds countdown
        String timeText = getSpeechText();
        alertStatus(timeText);

        state.sTimer.scheduleAtFixedRate(() -> {
                    if (countDown > ONE_SEC)
                        alertStatus("" + (--countDown));
                }, SCHEDULER_DELAY, SCHEDULER_PERIOD
        );

        countDownAudioInitiated = true;
    }

    public void process() {
        if (state.running) {
            int remainingTime = Integer.parseInt(state.timeText.replace(":", ""));
            if (remainingTime == FIVE_SEC && !countDownAudioInitiated)
                initiateCountdownAudio();

        } else {
            if (mTTS != null) {
                mTTS.stop();
            }

            if (!state.running && state.finished) {
                state.sTimer.cancel();
            }
        }

    }

    private String getSpeechText() {
        return "" + FIVE_SEC;
    }

    private void alertStatus(String text) {
        if (state.running) {
            mTTS.speak(text, TextToSpeech.QUEUE_FLUSH, null, null);
        }
    }


    public void stopCountDownTimer() {
        mTTS.stop();
    }


    @Override
    public String getDebugText() {
        return "TimerController";
    }
}
