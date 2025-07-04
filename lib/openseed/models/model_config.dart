import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:path_provider/path_provider.dart';

part 'model_config.g.dart';

enum ModelType { assets, file, api }

@JsonSerializable()
class ModelConfig extends Equatable {
  const ModelConfig({
    required this.name,
    required this.fileName,
    required this.type,
    required this.uri,
    this.description = "",
  });

  factory ModelConfig.fromJson(Map<String, dynamic> json) => _$ModelConfigFromJson(json);
  Map<String, dynamic> toJson() => _$ModelConfigToJson(this);

  static const modelMirrorUrl = "https://huggingface.co/openseed/OpenSeed-models/resolve/main/mnn";

  static const auto = ModelConfig(
    name: 'MobileNetV4-Conv-Small',
    fileName: 'mobilenet_conv_small_42.mnn',
    uri: 'assets/models/mobilenet_conv_small_42.mnn',
    type: ModelType.assets,
    description: 'MobileNet Conv Small',
  );

  final String name;
  final String fileName;
  final String uri;
  final ModelType type;
  final String description;

  Future<Directory> getModelDir() async {
    final docDir = await getApplicationCacheDirectory();
    final modelsDir = Directory('${docDir.path}/models');
    if (!await modelsDir.exists()) {
      await modelsDir.create(recursive: true);
    }
    return modelsDir;
  }

  Future<File> getModelFile() async {
    final modelsDir = await getModelDir();
    return File('${modelsDir.path}/$fileName');
  }

  Future<String> modelLoadUri() async {
    return switch (type) {
      ModelType.assets => uri,
      ModelType.file => (await getModelFile()).path,
      ModelType.api => throw UnimplementedError(),
    };
  }

  static const all = [
    ModelConfig(
      name: 'ConvNeXt-Tiny',
      fileName: 'convnext_tiny_42.mnn',
      uri: 'models/convnext_tiny_42.mnn',
      type: ModelType.file,
      description: 'ConvNeXt-Tiny',
    ),
    ModelConfig(
      name: 'MobileNetV4-Conv-Large',
      fileName: 'mobilenet_conv_large_42.mnn',
      uri: 'models/mobilenet_conv_large_42.mnn',
      type: ModelType.file,
      description: 'MobileNet Conv Large',
    ),
    ModelConfig(
      name: 'MobileNetV4-Conv-Medium',
      fileName: 'mobilenet_conv_medium_42.mnn',
      uri: 'models/mobilenet_conv_medium_42.mnn',
      type: ModelType.file,
      description: 'MobileNet Conv Medium',
    ),
    ModelConfig(
      name: 'MobileNetV4-Conv-Small',
      fileName: 'mobilenet_conv_small_42.mnn',
      uri: 'assets/models/mobilenet_conv_small_42.mnn',
      type: ModelType.assets,
      description: 'MobileNet Conv Small',
    ),
    ModelConfig(
      name: 'MobileNetV4-Hybrid-Large',
      fileName: 'mobilenet_hybrid_large_42.mnn',
      uri: 'models/mobilenet_hybrid_large_42.mnn',
      description: 'MobileNet Hybrid Large',
      type: ModelType.file,
    ),
    ModelConfig(
      name: 'MobileNetV4-Hybrid-Medium',
      fileName: 'mobilenet_hybrid_medium_42.mnn',
      uri: 'models/mobilenet_hybrid_medium_42.mnn',
      description: 'MobileNet Hybrid Medium',
      type: ModelType.file,
    ),
    ModelConfig(
      name: 'MobileViTv2-0.5',
      fileName: 'mobilevit_050_42.mnn',
      uri: 'models/mobilevit_050_42.mnn',
      description: 'MobileViT-050',
      type: ModelType.file,
    ),
    ModelConfig(
      name: 'MobileViTv2-1.0',
      fileName: 'mobilevit_100_42.mnn',
      uri: 'models/mobilevit_100_42.mnn',
      description: 'MobileViT-100',
      type: ModelType.file,
    ),
    ModelConfig(
      name: 'MobileViTv2-1.5',
      fileName: 'mobilevit_150_42.mnn',
      uri: 'models/mobilevit_150_42.mnn',
      description: 'MobileViT-150',
      type: ModelType.file,
    ),
    ModelConfig(
      name: 'ResNet-18',
      fileName: 'resnet_18_42.mnn',
      uri: 'models/resnet_18_42.mnn',
      type: ModelType.file,
      description: 'ResNet-18',
    ),
    ModelConfig(
      name: 'ResNet-34',
      fileName: 'resnet_34_42.mnn',
      uri: 'models/resnet_34_42.mnn',
      type: ModelType.file,
      description: 'ResNet-34',
    ),
    ModelConfig(
      name: 'ResNet-50',
      fileName: 'resnet_50_672.mnn',
      uri: 'models/resnet_50_672.mnn',
      type: ModelType.file,
      description: 'ResNet-50',
    ),
    ModelConfig(
      name: 'Swin-Tiny',
      fileName: 'swin_tiny_42.mnn',
      uri: 'models/swin_tiny_42.mnn',
      type: ModelType.file,
      description: 'Swin-Tiny',
    ),
    ModelConfig(
      name: 'ViT-B',
      fileName: 'vit_b_42.mnn',
      uri: 'models/vit_b_42.mnn',
      type: ModelType.file,
      description: 'ViT-B',
    ),
  ];

  @override
  List<Object> get props => [name, type, description, uri];

  @override
  String toString() {
    return 'ModelConfig{name: $name, uri: $uri, description: $description, isAsset: $type}';
  }
}
