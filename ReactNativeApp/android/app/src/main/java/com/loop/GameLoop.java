package com.loop;

import com.utils.STimer;
import com.utils.UtilArrayList;
import com.utils.interfaces.NoArgMethod;

import java.util.TimerTask;

public class GameLoop {

    STimer timer = new STimer(false);
    UtilArrayList<NoArgMethod> targets = new UtilArrayList<>();
    TimerTask runner;

    public void start() {
        //TODO: add more consistent way to do this
        runner = timer.scheduleInfinite(() -> targets.forEach(NoArgMethod::run), 66);
    }

    public void addTarget(NoArgMethod target) {
        this.targets.add(target);
    }

    public void stop() {
        runner.cancel();
    }


}
