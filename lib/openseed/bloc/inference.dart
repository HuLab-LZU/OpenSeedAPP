import 'dart:ffi';
import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:mnn/mnn.dart' as mnn;
import 'package:open_seed/openseed/models/inference_state.dart';

class LabelHelper {
  List<String> _labels = [];

  Future<void> loadLabels() async {
    try {
      final String content = await rootBundle.loadString('assets/class_desc.txt');
      _labels = content.split('\n').where((label) => label.trim().isNotEmpty).toList();
    } catch (e) {
      debugPrint('Error loading ImageNet labels: $e');
      _labels = [];
    }
  }

  String getLabelForIndex(int index) {
    if (index >= 0 && index < _labels.length) {
      return _labels[index];
    }
    return 'Unknown (Class_$index)';
  }

  int get labelCount => _labels.length;
}

class InferenceHelper {
  static const mean = [0.34865115, 0.29936219, 0.25752143];
  static const std = [0.2302609, 0.19996711, 0.17874425];

  static mnn.Interpreter loadModel(String modelPath) {
    final net = mnn.Interpreter.fromFile(modelPath);
    return net;
  }

  static mnn.Interpreter loadModelFromBuffer(Uint8List modelBytes) {
    final net = mnn.Interpreter.fromBuffer(modelBytes);
    return net;
  }

  static Future<mnn.Interpreter> loadModelFromAssets(String assetsPath) async {
    final modelBytes = await rootBundle.load(assetsPath);
    final net = mnn.Interpreter.fromBuffer(modelBytes.buffer.asUint8List());
    return net;
  }

  static Future<List<List<InferenceResultState>>> inference(
    mnn.Session session,
    List<Uint8List> images, {
    int topK = 5,
    int batchSize = 1,
    int inferenceCount = 1,
    List<double> mean = mean,
    List<double> std = std,
    LabelHelper? labelHelper,
  }) async {
    final timer = Stopwatch()..start();
    final input = session.getInput();
    final output = session.getOutput();
    final (B, C, H, W) = (batchSize, 3, 224, 224);
    if (input == null || input.isEmpty) {
      debugPrint("Can't get input tensor");
      return [];
    }
    if (output == null || output.isEmpty || output.elementSize == 0) {
      debugPrint("Resize error, the model can't run batch: $B");
      return [];
    }

    session.interpreter.resizeTensor(input, [B, C, H, W]);
    session.resize();

    // final memoryUsage = session.memoryInfo;
    // final flops = session.flopsInfo;
    // final backendType = session.backendsInfo;
    // debugPrint(
    //   'Session Info:'
    //   '  Memory: ${memoryUsage.toStringAsFixed(2)} MB,'
    //   '  FLOPs: ${flops.toStringAsFixed(2)} M,'
    //   '  backendType: $backendType,'
    //   '  batch size: $B',
    // );

    final nchwTensor = mnn.Tensor.fromTensor(input, dimType: mnn.DimensionType.MNN_CAFFE);
    for (var i = 0; i < B; i++) {
      if (!mnn.Image.haveReaderFromMemory(images[i])) {
        throw Exception('have no reader for: ${i}th image');
      }
      var img = mnn.Image.fromMemory(images[i]);
      if (img.isEmpty) {
        throw Exception("Can't decode ${i}th image");
      }
      img = img.resize(
        W,
        H,
        pixelLayout: mnn.StbirPixelLayout.STBIR_RGB,
        dtype: mnn.StbirDataType.STBIR_TYPE_UINT8,
      );
      img = img.normalize(mean: mean, std: std, scale: 255.0).toPlanar();
      nchwTensor.setImageBytes(i, img.bytes);
    }

    final preprocessTime = timer.elapsedMilliseconds;
    debugPrint('Preprocess time: $preprocessTime ms');

    final allInferenceTime = <int>[];
    for (var i = 0; i < inferenceCount; i++) {
      timer.reset();
      input.copyFromHost(nchwTensor);
      await session.runAsync();
      final inferenceTime = timer.elapsedMilliseconds;
      allInferenceTime.add(inferenceTime);
    }
    final inferenceTime = allInferenceTime.reduce((a, b) => a + b) / inferenceCount;
    debugPrint('Inference time: ${inferenceTime.toStringAsFixed(3)} ms');

    final outputUser = mnn.Tensor.fromTensor(output, dimType: mnn.DimensionType.MNN_CAFFE);
    output.copyToHost(outputUser);

    debugPrint('Output shape: ${outputUser.shape}');

    timer.reset();
    final logits = <List<double>>[];
    for (var batch = 0; batch < B; batch++) {
      final numClasses = outputUser.getStride(0);
      final values = (outputUser.cast<mnn.f32>() + batch * numClasses).asTypedList(numClasses);
      logits.add(values);
    }

    final probs = softmax(logits);

    final results = <List<InferenceResultState>>[];
    final postprocessTime = timer.elapsedMilliseconds;
    debugPrint('Postprocess time: $postprocessTime ms');

    for (var batch = 0; batch < B; batch++) {
      final batchResults = <InferenceResultState>[];
      final sorted = List<(int, double)>.generate(
        probs[batch].length,
        (index) => (index, probs[batch][index]),
      )..sort((a, b) => b.$2.compareTo(a.$2));

      for (final (labelId, probability) in sorted.take(topK)) {
        // debugPrint(
        //   'Batch $batch Top ${batchResults.length + 1}: '
        //   'labelId = $labelId, '
        //   'label = ${labelHelper?.getLabelForIndex(labelId) ?? labelId.toString()}, '
        //   'probability = ${probability.toStringAsFixed(4)}',
        // );
        batchResults.add(
          InferenceResultState(
            labelId: labelId,
            label: labelHelper?.getLabelForIndex(labelId) ?? labelId.toString(),
            probability: probability,
            preprocessTime: preprocessTime,
            inferenceTime: inferenceTime,
            postprocessTime: postprocessTime,
          ),
        );
      }
      results.add(batchResults);
    }
    return results;
  }

  static List<List<double>> softmax(List<List<double>> logits) {
    final result = <List<double>>[];
    for (final batchLogits in logits) {
      final maxLogit = batchLogits.reduce(math.max);
      var sum = 0.0;
      final expValues = List<double>.filled(batchLogits.length, 0.0);

      for (var i = 0; i < batchLogits.length; i++) {
        expValues[i] = math.exp(batchLogits[i] - maxLogit);
        sum += expValues[i];
      }

      for (var i = 0; i < expValues.length; i++) {
        expValues[i] /= sum;
      }

      result.add(expValues);
    }
    return result;
  }
}
