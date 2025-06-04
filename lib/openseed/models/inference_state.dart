import 'package:equatable/equatable.dart';

import 'backend_type.dart';


class InferenceInfo extends Equatable {
  final int inferenceTime;
  final double meanInferenceTime;
  final double memoryInfo;
  final double flops;
  final List<int> backendType;
  final BackendType currentBackend;

  const InferenceInfo({
    this.inferenceTime = 0,
    this.meanInferenceTime = 0.0,
    this.memoryInfo = 0.0,
    this.flops = 0.0,
    this.backendType = const [],
    this.currentBackend = BackendType.auto,
  });

  InferenceInfo copyWith({
    int? inferenceTime,
    double? meanInferenceTime,
    int? topK,
    double? memoryInfo,
    double? flops,
    List<int>? backendType,
    BackendType? currentBackend,
  }) {
    return InferenceInfo(
      inferenceTime: inferenceTime ?? this.inferenceTime,
      meanInferenceTime: meanInferenceTime ?? this.meanInferenceTime,
      memoryInfo: memoryInfo ?? this.memoryInfo,
      flops: flops ?? this.flops,
      backendType: backendType ?? this.backendType,
      currentBackend: currentBackend ?? this.currentBackend,
    );
  }

  @override
  List<Object?> get props => [inferenceTime, memoryInfo, flops, backendType];
}

class InferenceResultState extends Equatable {
  final int labelId;
  final String label;
  final double probability;
  final int preprocessTime;
  final double inferenceTime;
  final int postprocessTime;

  const InferenceResultState({
    required this.labelId,
    required this.label,
    required this.probability,
    required this.preprocessTime,
    required this.inferenceTime,
    required this.postprocessTime,
  });

  @override
  List<Object> get props => [labelId, label, probability, preprocessTime, inferenceTime, postprocessTime];

  @override
  String toString() {
    return 'InferenceResultState(labelId: $labelId, label: $label, probability: ${probability.toStringAsFixed(2)}, preprocessTime: $preprocessTime, inferenceTime: $inferenceTime, postprocessTime: $postprocessTime)';
  }
}
