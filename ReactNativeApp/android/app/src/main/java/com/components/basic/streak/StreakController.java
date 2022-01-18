package com.components.basic.streak;

import static java.lang.Math.max;
import static java.lang.Math.min;

import com.football433.R;
import com.render.lottie.LottieRender;
import com.render.sounds.SoundRender;
import com.ssvc.Controller;

public class StreakController extends Controller<StreakState> {

    LottieRender powerBarFlash;

    public StreakController(StreakState state) {
        super(state);
        powerBarFlash = new LottieRender(R.raw.power_bar_energy_v02).ephemeral(false).setNormalizedPosition(0.5f, 0.88f).speed(0.7f).play();
        powerBarFlash.goToFrame(0);
    }

    @Override
    public String getDebugText() {
        return null;
    }

    private void nextStreak() {
        StreakState state = this.state ;
        state.streak += 1;
        state.eventsInCurrrentStreak = 0;
        state.triggerStreakFlash = true;
        new SoundRender(R.raw.streak_activate).play();
    }

    public int getCurrentStreakLevel(){
        return state.streak;
    }

    private void prevStreak() {
        StreakState state = this.state ;
        state.streak = max(state.BASE_MULTIPLIER, state.streak - 1);
        state.eventsInCurrrentStreak = state.eventsPerStreak() - 3;
    }

    public void resetEventsInCurrentStreak(){
        state.eventsInCurrrentStreak = 0;
    }

    public void resetStreak() {
        new SoundRender(R.raw.jogo_cone_error).play();
        StreakState state = this.state;
        state.streak = state.BASE_MULTIPLIER;
        state.eventsInCurrrentStreak = 0;
    }

    private Integer getStreak()  {
        StreakState state = this.state ;
        return state.streak;
    }

    private void incrementEvent() {
        StreakState state = this.state ;
        state.eventsInCurrrentStreak += state.eventIncrementValue;
    }

    private void decrementEvent() {
        StreakState state = this.state ;
        state.eventsInCurrrentStreak -= state.eventDecrementValue;
    }


    void streakLadder() {
        StreakState state = this.state;
        if (state.eventsInCurrrentStreak >= state.eventsPerStreak()) { this.nextStreak(); }
        if (state.eventsInCurrrentStreak < 0) { this.prevStreak(); }
    }

    private void updatePowerBar(){
        powerBarFlash.goToFrame((int) ( state.eventsInCurrrentStreak));
    }

    public Integer getStreakPoint(Integer value, Boolean increment)  {

        if(increment) {
            this.incrementEvent() ;
        }
        else {
            this.decrementEvent();
        }
        this.streakLadder();
        updatePowerBar();
        return this.getStreak() * value;
    }

    public void cleanUp(){
        powerBarFlash.delete();
    }

}
