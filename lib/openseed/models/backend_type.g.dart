// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'backend_type.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BackendType _$BackendTypeFromJson(Map<String, dynamic> json) =>
    $checkedCreate('BackendType', json, ($checkedConvert) {
      final val = BackendType(
        name: $checkedConvert('name', (v) => v as String),
        id: $checkedConvert('id', (v) => (v as num).toInt()),
        description: $checkedConvert('description', (v) => v as String),
      );
      return val;
    });

Map<String, dynamic> _$BackendTypeToJson(BackendType instance) =>
    <String, dynamic>{
      'name': instance.name,
      'id': instance.id,
      'description': instance.description,
    };
