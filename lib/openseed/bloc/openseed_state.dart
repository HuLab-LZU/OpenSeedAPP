part of 'openseed_bloc.dart';

enum OpenSeedInferenceStatus { initial, inferencing, success, failure }

enum OpenSeedPhotoEditStatus { initial, loading, editing, success, failure }

enum ModelStatus { empty, loading, loaded, error }

enum ExploreStatus { initial, loading, loaded, error }

enum SearchStatus { initial, started, searching, ended }

enum SpDetailStatus { initial, loading, loaded, error }

@JsonSerializable()
class OpenSeedState extends Equatable {
  const OpenSeedState({
    // global
    this.homeBgImageUrl,
    this.settingsState = const SettingsState(),
    this.currentBottomNavIndex = 0,
    this.weather,
    // inference
    this.photoEditStatus = OpenSeedPhotoEditStatus.initial,
    this.status = OpenSeedInferenceStatus.initial,
    this.inferenceInfo,
    this.modelStatus = ModelStatus.empty,
    this.results,
    this.spDetailStatus = SpDetailStatus.initial,
    // explore
    this.exploreStatus = ExploreStatus.initial,
    this.maxItems,
    this.exploreItems = const [],
    this.exploreCurPage = 0,
    this.searchCurPage = 0,
    this.prevQuery = "",
    this.searchQuery = "",
  });

  factory OpenSeedState.fromJson(Map<String, dynamic> json) => _$OpenSeedStateFromJson(json);
  Map<String, dynamic> toJson() => _$OpenSeedStateToJson(this);

  // Global State
  @JsonKey(includeFromJson: false, includeToJson: false)
  final int currentBottomNavIndex;

  final String? homeBgImageUrl;

  final SettingsState settingsState;

  @JsonKey(name: 'weather')
  @WeatherJsonConverter()
  final Weather? weather;
  // End Global State

  @JsonKey(includeFromJson: false, includeToJson: false)
  final OpenSeedPhotoEditStatus photoEditStatus;

  // Inference State
  @JsonKey(includeFromJson: false, includeToJson: false)
  final OpenSeedInferenceStatus status;

  @JsonKey(includeFromJson: false, includeToJson: false)
  final InferenceInfo? inferenceInfo;

  final ModelStatus modelStatus;

  @JsonKey(includeFromJson: false, includeToJson: false)
  final SpDetailStatus spDetailStatus;

  @JsonKey(includeFromJson: false, includeToJson: false)
  final List<List<InferenceResultState>>? results;
  // End Inference State

  // Explore State
  @JsonKey(includeFromJson: false, includeToJson: false)
  final ExploreStatus exploreStatus;

  final int? maxItems;

  @JsonKey(includeFromJson: false, includeToJson: false)
  final int exploreCurPage;

  @JsonKey(includeFromJson: false, includeToJson: false)
  final int searchCurPage;

  @JsonKey(includeFromJson: false, includeToJson: false)
  final String prevQuery;

  @JsonKey(includeFromJson: false, includeToJson: false)
  final String searchQuery;

  @JsonKey(includeFromJson: false, includeToJson: false)
  final List<BotanicalKnowledgeItem> exploreItems;
  // End Explore State

  OpenSeedState copyWith({
    // global
    String? homeBgImageUrl,
    OpenSeedInferenceStatus? status,
    int? currentBottomNavIndex,
    Weather? weather,
    SettingsState? settingsState,
    // inference
    OpenSeedPhotoEditStatus? photoEditStatus,
    InferenceInfo? inferenceInfo,
    ModelStatus? modelStatus,
    List<List<InferenceResultState>>? results,
    SpDetailStatus? spDetailStatus,
    // explore
    ExploreStatus? exploreStatus,
    int? maxItems,
    int? exploreCurPage,
    int? searchCurPage,
    String? prevQuery,
    String? searchQuery,
    List<BotanicalKnowledgeItem>? exploreItems,
  }) {
    return OpenSeedState(
      homeBgImageUrl: homeBgImageUrl ?? this.homeBgImageUrl,
      status: status ?? this.status,
      currentBottomNavIndex: currentBottomNavIndex ?? this.currentBottomNavIndex,
      settingsState: settingsState ?? this.settingsState,
      weather: weather ?? this.weather,
      photoEditStatus: photoEditStatus ?? this.photoEditStatus,
      inferenceInfo: inferenceInfo ?? this.inferenceInfo,
      modelStatus: modelStatus ?? this.modelStatus,
      results: results ?? this.results,
      spDetailStatus: spDetailStatus ?? this.spDetailStatus,
      exploreStatus: exploreStatus ?? this.exploreStatus,
      maxItems: maxItems ?? this.maxItems,
      exploreCurPage: exploreCurPage ?? this.exploreCurPage,
      searchCurPage: searchCurPage ?? this.searchCurPage,
      prevQuery: prevQuery ?? this.prevQuery,
      searchQuery: searchQuery ?? this.searchQuery,
      exploreItems: exploreItems ?? this.exploreItems,
    );
  }

  String get modelName => settingsState.modelConfig.name;
  String get backendName => inferenceInfo?.currentBackend.name ?? "Unknown";
  String get memoryInfo => "${inferenceInfo?.memoryInfo.toStringAsFixed(2) ?? 'Unknown'} Mb";
  String get flopsInfo => "${inferenceInfo?.flops.toStringAsFixed(2) ?? 'Unknown'} M";
  String get inferTime => '${inferenceInfo?.inferenceTime} ms';

  @override
  List<Object?> get props => [
    // global
    homeBgImageUrl,
    status,
    currentBottomNavIndex,
    settingsState,
    weather,
    // inference
    photoEditStatus,
    inferenceInfo,
    modelStatus,
    results,
    // explore
    exploreStatus,
    maxItems,
    exploreCurPage,
    searchCurPage,
    prevQuery,
    searchQuery,
  ];
}
