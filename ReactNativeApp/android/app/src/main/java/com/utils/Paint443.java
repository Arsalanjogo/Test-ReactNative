package com.utils;

import android.content.res.AssetManager;
import android.graphics.Canvas;
import android.graphics.Color;
import android.graphics.Paint;
import android.graphics.Rect;
import android.graphics.Typeface;

import com.activities.GameActivity;


public class Paint443 extends Paint {
    //given that at most 1 excercise can exists, we could refactor this into a singleton
    public static final int xValue = 20;
    protected final static int drawDebugTextHeight = (int) new Paint443().red().fillStroke().small().monospace().getTextSize();
    protected final static int drawDebugLargeTextHeight = (int) new Paint443().red().fillStroke().large().getTextSize();
    public static Paint443 debugPaint = new Paint443().red().fillStroke().small().monospace();
    public static Paint443 debugLargePaint = new Paint443().red().fillStroke().large();
    protected static int drawDebugYHeight = 0;
    protected static int drawDebugStart = 300;

    /********** draw functions **********/
    //add some debug information to the screen
    public static int getNewDrawDebugHeight() {
        return (drawDebugYHeight += drawDebugTextHeight) + drawDebugStart;
    }

    public static int getNewDrawDebugLargeHeight() {
        return (drawDebugYHeight += drawDebugLargeTextHeight) + drawDebugStart;
    }

    public static void resetDrawDebugHeight() {
        Paint443.drawDebugYHeight = 0;
    }


    public static void drawDebugText(String text, Canvas canvas) {
        canvas.drawText(text, 20, Paint443.getNewDrawDebugHeight(), Paint443.debugPaint);

    }

    public Paint443 transparancy(double transparancy) {
        setAlpha((int) ((1 - transparancy) * 255));
        return this;
    }

    public Paint443 fillStroke() {
        this.setStyle(Paint.Style.FILL_AND_STROKE);
        return (this);
    }

    public Paint443 fill() {
        this.setStyle(Paint.Style.FILL);
        return (this);
    }

    public Paint443 stroke() {
        this.setStyle(Style.STROKE);
        return (this);
    }

    public Paint443 monospace() {
        this.setTypeface(Typeface.MONOSPACE);
        return (this);
    }

    public Paint443 bioSansBold(AssetManager assets) {
        Typeface face;
        face = Typeface.createFromAsset(assets, "biosans-bold.otf");
        setTypeface(face);
        return (this);
    }

    public Paint443 monoSpecMedium(AssetManager assets) {
        Typeface face;
        face = Typeface.createFromAsset(assets, "monospec_medium.otf");
        setTypeface(face);
        return (this);
    }

    public Paint443 bioSansBold() {
        /***
         * Can only be used if the exercise is running, and abstract exercise is initialized
         */
        AssetManager assets = GameActivity.getActivity().getAssets();


        Typeface face;
        face = Typeface.createFromAsset(assets, "biosans-bold.otf");
        setTypeface(face);
        return (this);
    }

    public Paint443 yellow() {
        this.setColor(Color.YELLOW);
        return (this);
    }

    public Paint443 largeStroke() {
        this.setStyle(Paint.Style.STROKE);
        this.setStrokeWidth(10);
        return (this);
    }

    public Paint443 mediumStroke() {
        this.setStyle(Paint.Style.STROKE);
        this.setStrokeWidth(5);
        return (this);
    }

    public Paint443 narrowStroke() {
        this.setStyle(Paint.Style.STROKE);
        this.setStrokeWidth(3);
        return (this);
    }

    public Paint443 small() {
        this.setTextSize(25);
        setStrokeWidth(3);
        return (this);
    }

    public Paint443 medium() {
        this.setTextSize(50);
        setStrokeWidth(5);
        return (this);
    }

    public Paint443 large() {
        this.setTextSize(150);
        setStrokeWidth(8);
        return (this);
    }

    public Paint443 xl() {
        this.setTextSize(250);
        setStrokeWidth(10);
        return (this);
    }

    public Paint443 textSize(int size) {
        this.setTextSize(size);
        return this;
    }

    public Paint443 strokeWidth(int size) {
        this.setStrokeWidth(size);
        return this;
    }

    public Paint443 white() {
        this.setColor(Color.WHITE);
        return this;
    }

    public Paint443 blue() {
        this.setColor(Color.BLUE);
        return (this);
    }

    public Paint443 green() {
        this.setColor(Color.GREEN);
        return (this);
    }

    public Paint443 cyan() {
        this.setColor(Color.CYAN);
        return (this);
    }

    public Paint443 magenta() {
        this.setColor(Color.MAGENTA);
        return (this);
    }

    public Paint443 gray() {
        this.setColor(Color.GRAY);
        return (this);
    }

    public Paint443 purple() {
        this.setColor(Color.parseColor("#8657c5"));
        return (this);
    }

    public Paint443 setColorWithHex(String colorCode) {
        this.setColor(Color.parseColor(colorCode));
        return (this);
    }

    public Paint443 setColorWithRGB(int red, int green, int blue) {
        this.setColor(Color.rgb(red, green, blue));
        return (this);
    }

    public Paint443 yellow433() {
        this.setColorWithRGB(255,255,0);
        return (this);
    }

    public Paint443 black() {
        this.setColor(Color.BLACK);
        return (this);
    }

    public Paint443 red() {
        this.setColor(Color.RED);
        return (this);
    }

    public Paint443 align(Align align) {
        this.setTextAlign(align);
        return this;
    }

    public Paint443 center() {
        this.setTextAlign(Align.CENTER);
        return this;
    }

    public float getTextHeight() {
        FontMetrics fm = getFontMetrics();
        return fm.descent - fm.ascent;
    }

    public float centerY() {
        Rect bounds = new Rect();
        getTextBounds("THISISALARGETEXT", 0, 16, bounds);
        return bounds.exactCenterY();

    }

}
