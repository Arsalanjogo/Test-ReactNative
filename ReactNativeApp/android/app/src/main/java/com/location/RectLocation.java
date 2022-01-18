package com.location;

import android.graphics.Canvas;
import android.graphics.Paint;
import android.graphics.RectF;

import com.utils.Paint443;

import java.text.DecimalFormat;

public class RectLocation extends DetectionLocation {
    private final RectF rectF;

    //todo aspect ratio

    public RectLocation(RectF rectF, String classLabel, int frameID, float confidence) {
        super(classLabel, rectF.centerX(), rectF.centerY(), frameID, confidence, STATUS.DETECTED);
        this.rectF = rectF;
    }


    public RectF getRect() {
        return rectF;
    }

    public float getWidth() {
        return rectF.width();
    }

    public float getWidth(DecimalFormat df) {
        return Float.parseFloat(df.format(rectF.width()));
    }

    public float getHeight() {
        return Float.parseFloat(df.format(rectF.height()));
    }

    public RectF getScaledRectF(Canvas canvas) {
        //scaling rectangle bounding box location for displaying on the screen
        float left = rectF.left * canvas.getWidth();
        float right = rectF.right * canvas.getWidth();
        float top = rectF.top * canvas.getHeight();
        float bottom = rectF.bottom * canvas.getHeight();
        return new RectF(left, top, right, bottom);
    }


    public void updateLocation(double centerX, double centerY, STATUS status) {
        // update the location as the detection changes
        this.x = centerX;
        this.y = centerY;
        this.status = status;

    }

    public float getRectArea() {
        return rectF.width() * rectF.height();
    }


    public void drawDebug(Canvas canvas) {
        this.drawDebug(canvas, new Paint443().red().narrowStroke().medium());

    }


    public void draw(Canvas canvas) {
        if (!locationKnown()) return;
        //RectF rect = getScaledRectF(canvas);
        //canvas.drawRect(rect, new JOGOPaint().red().narrowStroke().medium());
    }

    public void drawDebug(Canvas canvas, Paint paint) {
        if (!locationKnown()) return;

        RectF rect = getScaledRectF(canvas);
        canvas.drawRect(rect, paint);
        canvas.drawText(label + " " + String.format("%.2f", confidence), rect.left, rect.top, new Paint443().red().fillStroke().small().monospace());
        canvas.drawCircle((float) (x * canvas.getWidth()), (float) y * canvas.getHeight(), 3, paint);


    }


    @Override
    public double getRadius() {
        //return the radius of the bounding box

        //todo might undershoot a bit, but is probably not a big problem
        //for now it's a rule that we just return the smallest
        return Math.min(rectF.width() / 2f, rectF.height() / 2f);
    }

    @Override
    public String toString() {
        return "RectLocation{" +
                "label='" + label + '\'' +
                ", frameID=" + frameID +
                ", confidence=" + confidence +
                ", status=" + status +
                ", x=" + x +
                ", y=" + y +
                ", width=" + rectF.width() +
                ", height=" + rectF.height() +

                '}';
    }
}


