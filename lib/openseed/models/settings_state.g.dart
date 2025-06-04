// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SettingsState _$SettingsStateFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'SettingsState',
      json,
      ($checkedConvert) {
        final val = SettingsState(
          language: $checkedConvert(
            'language',
            (v) =>
                $enumDecodeNullable(_$OseedLocaleEnumMap, v) ??
                OseedLocale.en_US,
          ),
          theme: $checkedConvert(
            'theme',
            (v) =>
                $enumDecodeNullable(_$ThemeSettingsEnumMap, v) ??
                ThemeSettings.light,
          ),
          modelConfig: $checkedConvert(
            'model_config',
            (v) =>
                v == null
                    ? ModelConfig.auto
                    : ModelConfig.fromJson(v as Map<String, dynamic>),
          ),
          backendType: $checkedConvert(
            'backend_type',
            (v) =>
                v == null
                    ? BackendType.auto
                    : BackendType.fromJson(v as Map<String, dynamic>),
          ),
          numThreads: $checkedConvert(
            'num_threads',
            (v) => (v as num?)?.toInt() ?? 4,
          ),
          topK: $checkedConvert('top_k', (v) => (v as num?)?.toInt() ?? 5),
          apiBaseUrl: $checkedConvert('api_base_url', (v) => v as String?),
        );
        return val;
      },
      fieldKeyMap: const {
        'modelConfig': 'model_config',
        'backendType': 'backend_type',
        'numThreads': 'num_threads',
        'topK': 'top_k',
        'apiBaseUrl': 'api_base_url',
      },
    );

Map<String, dynamic> _$SettingsStateToJson(SettingsState instance) =>
    <String, dynamic>{
      'language': _$OseedLocaleEnumMap[instance.language]!,
      'theme': _$ThemeSettingsEnumMap[instance.theme]!,
      'model_config': instance.modelConfig.toJson(),
      'backend_type': instance.backendType.toJson(),
      'num_threads': instance.numThreads,
      'top_k': instance.topK,
      'api_base_url': instance.apiBaseUrl,
    };

const _$OseedLocaleEnumMap = {
  OseedLocale.zh_CN: 'zh_CN',
  OseedLocale.en_US: 'en_US',
};

const _$ThemeSettingsEnumMap = {
  ThemeSettings.light: 'light',
  ThemeSettings.dark: 'dark',
};
