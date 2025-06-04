// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'openseed_bloc.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OpenSeedState _$OpenSeedStateFromJson(
  Map<String, dynamic> json,
) => $checkedCreate(
  'OpenSeedState',
  json,
  ($checkedConvert) {
    final val = OpenSeedState(
      homeBgImageUrl: $checkedConvert('home_bg_image_url', (v) => v as String?),
      settingsState: $checkedConvert(
        'settings_state',
        (v) =>
            v == null
                ? const SettingsState()
                : SettingsState.fromJson(v as Map<String, dynamic>),
      ),
      weather: $checkedConvert(
        'weather',
        (v) =>
            const WeatherJsonConverter().fromJson(v as Map<String, dynamic>?),
      ),
      modelStatus: $checkedConvert(
        'model_status',
        (v) =>
            $enumDecodeNullable(_$ModelStatusEnumMap, v) ?? ModelStatus.empty,
      ),
      maxItems: $checkedConvert('max_items', (v) => (v as num?)?.toInt()),
    );
    return val;
  },
  fieldKeyMap: const {
    'homeBgImageUrl': 'home_bg_image_url',
    'settingsState': 'settings_state',
    'modelStatus': 'model_status',
    'maxItems': 'max_items',
  },
);

Map<String, dynamic> _$OpenSeedStateToJson(OpenSeedState instance) =>
    <String, dynamic>{
      'home_bg_image_url': instance.homeBgImageUrl,
      'settings_state': instance.settingsState.toJson(),
      'weather': const WeatherJsonConverter().toJson(instance.weather),
      'model_status': _$ModelStatusEnumMap[instance.modelStatus]!,
      'max_items': instance.maxItems,
    };

const _$ModelStatusEnumMap = {
  ModelStatus.empty: 'empty',
  ModelStatus.loading: 'loading',
  ModelStatus.loaded: 'loaded',
  ModelStatus.error: 'error',
};
