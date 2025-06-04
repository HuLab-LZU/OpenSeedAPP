// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'model_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ModelConfig _$ModelConfigFromJson(Map<String, dynamic> json) => $checkedCreate(
  'ModelConfig',
  json,
  ($checkedConvert) {
    final val = ModelConfig(
      name: $checkedConvert('name', (v) => v as String),
      fileName: $checkedConvert('file_name', (v) => v as String),
      type: $checkedConvert('type', (v) => $enumDecode(_$ModelTypeEnumMap, v)),
      uri: $checkedConvert('uri', (v) => v as String),
      description: $checkedConvert('description', (v) => v as String? ?? ""),
    );
    return val;
  },
  fieldKeyMap: const {'fileName': 'file_name'},
);

Map<String, dynamic> _$ModelConfigToJson(ModelConfig instance) =>
    <String, dynamic>{
      'name': instance.name,
      'file_name': instance.fileName,
      'uri': instance.uri,
      'type': _$ModelTypeEnumMap[instance.type]!,
      'description': instance.description,
    };

const _$ModelTypeEnumMap = {
  ModelType.assets: 'assets',
  ModelType.file: 'file',
  ModelType.api: 'api',
};
