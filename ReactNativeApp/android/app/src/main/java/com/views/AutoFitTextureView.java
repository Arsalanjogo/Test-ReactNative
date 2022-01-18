/*
 * Copyright 2019 The TensorFlow Authors. All Rights Reserved.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *       http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package com.views;

import static com.activities.CameraActivity.getCameraParentLayout;
import static com.activities.GameActivity.getActivity;

import android.content.Context;
import android.graphics.Canvas;
import android.util.AttributeSet;
import android.view.TextureView;
import android.view.View;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import com.ssvc.SV.DynamicSV;
import com.ssvc.SV.LayoutSV;

import java.util.ArrayList;
import java.util.concurrent.CopyOnWriteArrayList;

/**
 * A {@link TextureView} that can be adjusted to a specified aspect ratio.
 */
public class AutoFitTextureView extends TextureView {

    private static AutoFitTextureView autoFitTextureView;
    public CopyOnWriteArrayList<LayoutSV<?>> layoutSVS = new CopyOnWriteArrayList<>();
    public ArrayList<DynamicSV<?>> dynamicSVS = new ArrayList<>();
    private Canvas overlayCanvas;

    private int ratioWidth = 0;
    private int ratioHeight = 0;

    public AutoFitTextureView(@NonNull Context context, @Nullable AttributeSet attrs) {
        super(context, attrs);

        if (autoFitTextureView!=null) throw new RuntimeException("can only be created once");
        autoFitTextureView=this;

    }

    /**
     * Sets the aspect ratio for this view. The size of the view will be measured based on the ratio
     * calculated from the parameters. Note that the actual sizes of parameters don't matter, that is,
     * calling setAspectRatio(2, 3) and setAspectRatio(4, 6) make the same result.
     *
     * @param width  Relative horizontal size
     * @param height Relative vertical size
     */
    public void setAspectRatio(final int width, final int height) {
        if (width < 0 || height < 0) {
            throw new IllegalArgumentException("Size cannot be negative.");
        }
        ratioWidth = width;
        ratioHeight = height;
        requestLayout();
    }

    @Override
    protected void onMeasure(final int widthMeasureSpec, final int heightMeasureSpec) {
        super.onMeasure(widthMeasureSpec, heightMeasureSpec);
        final int width = MeasureSpec.getSize(widthMeasureSpec);
        final int height = MeasureSpec.getSize(heightMeasureSpec);
        if (0 == ratioWidth || 0 == ratioHeight) {
            setMeasuredDimension(width, height);
        } else {
            if (width > height * ratioWidth / ratioHeight) {
                setMeasuredDimension(width, width * ratioHeight / ratioWidth);
            } else {
                setMeasuredDimension(height * ratioWidth / ratioHeight, height);
            }
        }
    }

    public static AutoFitTextureView getAutoFitTextureView(){
        return autoFitTextureView;
    }

    public static void removeLayoutSV(LayoutSV<?> layoutSV) {
        autoFitTextureView.layoutSVS.remove(layoutSV);
        //as some views may not have any xml layout to show inside camera view
        if (layoutSV.getView() != null)
            autoFitTextureView.removeChildView(layoutSV.getView());

    }

    public static void addLayoutSV(LayoutSV<?> layoutSV) {
        autoFitTextureView.layoutSVS.add(layoutSV);
        //as some views may not have any xml layout to show inside camera view
        if (layoutSV.getView() != null)
            autoFitTextureView.addChildView(layoutSV.getView());
    }

    //TODO whats the purpose of dynamic sv
    public static void removeDynamicSV(DynamicSV<?> dynamicSV) {
        autoFitTextureView.dynamicSVS.remove(dynamicSV);
    }

    public static void addDynamicSV(DynamicSV<?> dynamicSV) {
        autoFitTextureView.dynamicSVS.add(dynamicSV);
    }

    public void setOverlayCanvas(Canvas overlayCanvas) {
        this.overlayCanvas = overlayCanvas;
        layoutSVS.forEach(layoutSV -> layoutSV.draw(overlayCanvas));
    }

    public void start() {
    }

    private void addChildView(View view) {
        getActivity().runOnUiThread(() -> {
            getCameraParentLayout().addView(view);
        });
    }

    private void removeChildView(View view) {
        getActivity().runOnUiThread(() -> {
            getCameraParentLayout().removeView(view);
        });
    }

    public void cleanup() {
        autoFitTextureView = null;
    }

}
