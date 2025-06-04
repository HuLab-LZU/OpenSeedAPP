import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'backend_type.g.dart';

@JsonSerializable()
class BackendType extends Equatable {
  factory BackendType.fromJson(Map<String, dynamic> json) => _$BackendTypeFromJson(json);
  Map<String, dynamic> toJson() => _$BackendTypeToJson(this);

  const BackendType({required this.name, required this.id, required this.description});

  factory BackendType.fromId(int id) {
    for (final backend in all) {
      if (backend.id == id) {
        return backend;
      }
    }
    return const BackendType(name: 'Unknown', id: -1, description: 'Unknown backend');
  }

  static const all = [cpu, metal, cuda, opencl, auto, nn, vulkan];

  static const cpu = BackendType(name: 'CPU', id: 0, description: 'CPU backend');
  static const metal = BackendType(name: 'METAL', id: 1, description: 'METAL backend for Apple devices');
  static const cuda = BackendType(name: 'CUDA', id: 2, description: 'CUDA backend for Nvidia devices');
  static const opencl = BackendType(name: 'OPENCL', id: 3, description: 'OPENCL backend');
  static const auto = BackendType(name: 'AUTO', id: 4, description: 'Automatic backend selection');
  static const nn = BackendType(name: 'NN', id: 5, description: 'NPU backend');
  static const vulkan = BackendType(name: 'VULKAN', id: 7, description: 'Vulkan backend');

  static const api = BackendType(name: "API", id: 8, description: "Remote API Inference");

  final String name;
  final int id;
  final String description;

  @override
  List<Object?> get props => [name, id, description];
}
