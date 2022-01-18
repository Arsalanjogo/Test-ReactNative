package com.models;

import android.content.Context;
import android.content.res.AssetManager;
import android.graphics.RectF;
import android.os.SystemClock;
import android.util.Pair;

import com.activities.CameraActivity;
import com.activities.GameActivity;
import com.google.android.odml.image.BitmapExtractor;
import com.location.DetectionLocation;
import com.location.RectLocation;
import com.logger.SLOG;
import com.logger.TLOG;
import com.utils.ExtendedMLImage;
import com.utils.InfoBlob;

import org.tensorflow.lite.DataType;
import org.tensorflow.lite.Interpreter;
import org.tensorflow.lite.gpu.GpuDelegate;
import org.tensorflow.lite.nnapi.NnApiDelegate;
import org.tensorflow.lite.support.common.FileUtil;
import org.tensorflow.lite.support.image.ImageProcessor;
import org.tensorflow.lite.support.image.TensorImage;
import org.tensorflow.lite.support.image.ops.ResizeOp;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.nio.MappedByteBuffer;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.Vector;
import java.util.concurrent.ConcurrentHashMap;

import io.reactivex.rxjava3.core.BackpressureStrategy;
import io.reactivex.rxjava3.core.Flowable;
import io.reactivex.rxjava3.schedulers.Schedulers;


public class CenterNet extends TFLiteModel {

    private static final float IMAGE_MEAN = 128.0f;
    private static final float IMAGE_STD = 128.0f;
    final int labelOffset;
    final String labelFileName;
    final private int NUMTHREADS = 4;
    final private boolean USEXNNPACK = true;
    protected List<String> labels = new Vector<>();
    long waitingTime = 0;
    int frameID;
    int MAXDETECTIONS = 10;


    public CenterNet(String modelFileName, String labelFileName, int labelOffset) {
        super(0.45f, modelFileName);
        this.labelOffset = labelOffset;
        this.labelFileName = labelFileName;
        this.device = Device.GPU;
    }


    public void loadLabels(AssetManager assetManager) throws IOException {
        InputStream labelsInput = assetManager.open(labelFileName);
        BufferedReader br = new BufferedReader(new InputStreamReader(labelsInput));
        String line;
        while ((line = br.readLine()) != null) {
            SLOG.d(line);
            labels.add(line);
        }
        labelsInput.close();
        br.close();
    }


    @Override
    public void loadModel(Context context) throws IOException {
        MappedByteBuffer tfliteModel
                = FileUtil.loadMappedFile(context,
                modelFileName);

        Interpreter.Options options = (new Interpreter.Options());
        switch (device) {
            case CPU:
                options.setNumThreads(NUMTHREADS);
                options.setUseXNNPACK(USEXNNPACK);
                break;
            case GPU:
                GpuDelegate delegate = new GpuDelegate();
                options.addDelegate(delegate);
                break;
            case NNAPI:
                NnApiDelegate nnApiDelegate = new NnApiDelegate();
                options.addDelegate(nnApiDelegate);
                break;
            default:
                SLOG.e("Modelfile cannot be loaded");
                throw new IllegalStateException("Unexpected Device Value " + device);
        }

        detectionModel = new Interpreter(tfliteModel, options);

        int imageTensorIndex = 0;
        int[] imageShape = detectionModel.getInputTensor(imageTensorIndex).shape(); // {1, height, width, 3}

        imageDataType = detectionModel.getInputTensor(imageTensorIndex).dataType();
        imageSizeY = imageShape[1];
        imageSizeX = imageShape[2];

        imageProcessor = buildImageProcessor();

        loadLabels(context.getAssets());
    }


    protected Map<Integer, Object> buildOutputMap() {

        int[] shape = detectionModel.getOutputTensor(0).shape();

        float[][][] outputLocations = new float[shape[0]][shape[1]][shape[2]];

        shape = detectionModel.getOutputTensor(1).shape();

        float[][] outputClasses = new float[shape[0]][shape[1]];

        shape = detectionModel.getOutputTensor(2).shape();
        float[][] outputScores = new float[shape[0]][shape[1]];

        shape = detectionModel.getOutputTensor(3).shape();
        float[] numDetections = new float[shape[0]];

        Map<Integer, Object> outputMap = new ConcurrentHashMap<>();
        outputMap.put(0, outputLocations);
        outputMap.put(1, outputClasses);
        outputMap.put(2, outputScores);
        outputMap.put(3, numDetections);
        return outputMap;
    }

    @Override
    protected ImageProcessor buildImageProcessor() {
        return new ImageProcessor.Builder()
                .add(new ResizeOp(imageSizeX, imageSizeY, ResizeOp.ResizeMethod.BILINEAR))
                .build();
    }

    @Override
    protected Flowable<Pair<TensorImage, InfoBlob>> preProcessImage(Pair<ExtendedMLImage, InfoBlob> extendedMlImageInfoBlobPair) {

        TensorImage tensorImage = TensorImage.fromBitmap(BitmapExtractor.extract((extendedMlImageInfoBlobPair.first.getMlImage())));
        tensorImage = imageProcessor.process(tensorImage);
        TensorImage ntensorImage = TensorImage.createFrom(tensorImage, DataType.FLOAT32);

        return Flowable.just(new Pair<>(ntensorImage, extendedMlImageInfoBlobPair.second));
    }

    @Override
    protected void buildPipeline() {
        pipeline = Flowable.create(emitter -> sourceEmitter = emitter, BackpressureStrategy.LATEST);
        pipeline.observeOn(Schedulers.computation())
                .filter((blob) -> supplyFramePreProcessId == blob.second.getFrameID())
                .concatMapEager(this::preProcessImage)
                .doOnNext((blob) -> afterPreProcessFrameId = blob.second.getFrameID())
                .observeOn(Schedulers.computation())
                .filter((blob) -> afterPreProcessFrameId == blob.second.getFrameID())
                .concatMap(this::RunModel)
                .subscribe(this::distributeLocations);
    }

    @Override
    public Flowable<Pair<List<DetectionLocation>, InfoBlob>> RunModel(Pair<TensorImage, InfoBlob> blob) {
        // Run the inference call.
        Map<Integer, Object> outputMap = buildOutputMap();
        // detectionModel.run(inputArray, outputMap);

        String ONIMAGE = "runCenterNet";
        TLOG.start(ONIMAGE);

        detectionModel.runForMultipleInputsOutputs(new Object[]{blob.first.getBuffer()}, outputMap);
        //detectionModel.runForMultipleInputsOutputs(inputArray, outputMap);

        float[][][] outputLocations = (float[][][]) outputMap.get(0);
        float[][] outputClasses = (float[][]) outputMap.get(1);
        float[][] outputScores = (float[][]) outputMap.get(2);
        float[] numDetections = (float[]) outputMap.get(3);

        int numDetectionsOutput = Math.min(MAXDETECTIONS, (int) numDetections[0]); // cast from float to integer, use min for safety

        final List<DetectionLocation> recognitions = new ArrayList<>(numDetectionsOutput);

        for (int i = 0; i < numDetectionsOutput; ++i) {
            if (outputScores[0][i] < confidenceScore) continue;
            SLOG.d("before RectF init");

            //TODO if an object is square on camera, it will be projected as rectangular in cropped dimensions.
            float left = outputLocations[0][i][1];
            float top = outputLocations[0][i][0];
            float right = outputLocations[0][i][3];
            float bottom = outputLocations[0][i][2];

            // todo not sure about this!!!
            if (GameActivity.getFacing() == 1) {
                left = 1 - left;
                right = 1 - right;
            }

            RectF rectF = new RectF(
                    left,
                    top,
                    right,
                    bottom);

            DetectionLocation detection = new RectLocation(
                    rectF,
                    labels.get((int) outputClasses[0][i] + labelOffset),
                    frameID,
                    outputScores[0][i]
            );
            SLOG.d("detection confidence: " + detection.getConfidence());
            SLOG.d("detection label: " + detection.getLabel());

            recognitions.add(detection);
        }
        TLOG.addSplit(ONIMAGE, "Ran TFLite");
        waitingTime = SystemClock.elapsedRealtime();

        TLOG.end(ONIMAGE);

        return Flowable.just(new Pair<>(recognitions, blob.second));
    }

}
