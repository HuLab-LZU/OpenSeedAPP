import 'dart:ui';

import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:weather/weather.dart';

import 'backend_type.dart';
import 'model_config.dart';

part 'settings_state.g.dart';

enum OseedLocale { zh_CN, en_US }

enum ThemeSettings { light, dark }

@JsonSerializable()
class SettingsState extends Equatable {
  const SettingsState({
    this.language = OseedLocale.en_US,
    this.theme = ThemeSettings.light,
    this.modelConfig = ModelConfig.auto,
    this.backendType = BackendType.auto,
    this.numThreads = 4,
    this.topK = 5,
    this.apiBaseUrl,
  });

  factory SettingsState.fromJson(Map<String, dynamic> json) => _$SettingsStateFromJson(json);
  Map<String, dynamic> toJson() => _$SettingsStateToJson(this);

  final OseedLocale language;
  final ThemeSettings theme;
  final ModelConfig modelConfig;
  final BackendType backendType;
  final int numThreads;
  final int topK;

  final String? apiBaseUrl;

  SettingsState copyWith({
    OseedLocale? language,
    ThemeSettings? theme,
    ModelConfig? modelConfig,
    BackendType? backendType,
    int? numThreads,
    int? topK,
    String? apiBaseUrl,
  }) {
    return SettingsState(
      language: language ?? this.language,
      theme: theme ?? this.theme,
      modelConfig: modelConfig ?? this.modelConfig,
      backendType: backendType ?? this.backendType,
      numThreads: numThreads ?? this.numThreads,
      topK: topK ?? this.topK,
      apiBaseUrl: apiBaseUrl ?? this.apiBaseUrl,
    );
  }

  @override
  List<Object?> get props => [language, theme, modelConfig, backendType, numThreads, topK, apiBaseUrl];
}

extension OseedLocaleExtension on OseedLocale {
  Locale get locale {
    switch (this) {
      case OseedLocale.zh_CN:
        return const Locale('zh');
      case OseedLocale.en_US:
        return const Locale('en');
    }
  }

  String get name {
    switch (this) {
      case OseedLocale.zh_CN:
        return 'zh_CN';
      case OseedLocale.en_US:
        return 'en_US';
    }
  }

  Language get weatherLanguage {
    switch (this) {
      case OseedLocale.zh_CN:
        return Language.CHINESE_SIMPLIFIED;
      case OseedLocale.en_US:
        return Language.ENGLISH;
    }
  }
}
