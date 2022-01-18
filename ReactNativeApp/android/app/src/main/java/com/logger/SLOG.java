package com.logger;

import android.util.Log;

import java.util.Arrays;

import io.sentry.Sentry;


public class SLOG {

    private static final String TAG = "JOGO";

    public static int v(String extraTag, String msg) {
        return Log.v(TAG + "-" + extraTag, msg);
    }

    public static int v(String msg) {
        return SLOG.v("", msg);
    }

    public static int d(String extraTag, String msg) {
        return Log.d(TAG + "-" + extraTag, msg);
    }

    public static int d(String msg) {
        return SLOG.d("", msg);
    }

    public static int i(String extraTag, String msg) {
        return Log.i(TAG + "-" + extraTag, msg);
    }

    public static int i(String msg) {
        return SLOG.i("", msg);
    }

    public static int w(String extraTag, String msg) {
        return Log.w(TAG + "-" + extraTag, msg);
    }

    public static int w(String msg) {
        return SLOG.w("", msg);
    }

    public static int e(String extraTag, String msg) {
        return Log.e(TAG + "-" + extraTag, msg);
    }

    public static int e(String extraTag, Exception e) {
        Sentry.captureException(e);
        return Log.e(TAG + "-" + extraTag, Arrays.toString(e.getStackTrace()));
    }

    public static int e(String msg) {
        return SLOG.e("", msg);
    }

    public static int e(Exception e) {
        Sentry.captureException(e);
        Log.e(TAG, String.valueOf(e));
        return Log.e(TAG, Arrays.toString(e.getStackTrace()));
    }

    public static int wtf(String msg) {
        return Log.wtf(TAG, msg);
    }


}
