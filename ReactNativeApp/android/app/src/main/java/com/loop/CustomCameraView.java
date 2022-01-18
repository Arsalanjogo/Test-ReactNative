package com.loop;

import android.content.Context;
import android.graphics.Canvas;
import android.util.AttributeSet;
import android.view.View;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import com.otaliastudios.cameraview.CameraView;
import com.ssvc.SV.DynamicSV;
import com.ssvc.SV.LayoutSV;

import java.util.ArrayList;
import java.util.concurrent.CopyOnWriteArrayList;

import static com.activities.CameraActivity.getCameraParentLayout;
import static com.activities.GameActivity.getActivity;

public class CustomCameraView extends CameraView {

    private static CustomCameraView customCameraView;
    public CopyOnWriteArrayList<LayoutSV<?>> layoutSVS = new CopyOnWriteArrayList<>();
    public ArrayList<DynamicSV<?>> dynamicSVS = new ArrayList<>();
    private Canvas overlayCanvas;

    public CustomCameraView(@NonNull Context context, @Nullable AttributeSet attrs) {
        super(context, attrs);

        if (customCameraView != null) throw new RuntimeException("can only be created once");
        customCameraView = this;

    }

    public static void removeLayoutSV(LayoutSV<?> layoutSV) {
        customCameraView.layoutSVS.remove(layoutSV);
        //as some views may not have any xml layout to show inside camera view
        if (layoutSV.getView() != null)
            customCameraView.removeChildView(layoutSV.getView());

    }

    public static void addLayoutSV(LayoutSV<?> layoutSV) {
        customCameraView.layoutSVS.add(layoutSV);
        //as some views may not have any xml layout to show inside camera view
        if (layoutSV.getView() != null)
            customCameraView.addChildView(layoutSV.getView());
    }

    //TODO whats the purpose of dynamic sv
    public static void removeDynamicSV(DynamicSV<?> dynamicSV) {
        customCameraView.dynamicSVS.remove(dynamicSV);
    }

    public static void addDynamicSV(DynamicSV<?> dynamicSV) {
        customCameraView.dynamicSVS.add(dynamicSV);
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
        customCameraView = null;
    }
}
