import 'dart:typed_data';

import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:iplant_api/iplant_api.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:logger/web.dart';
import 'package:meta/meta.dart';
import 'package:mnn/mnn.dart' as mnn;
import 'package:open_seed/openseed/bloc/inference.dart';
import 'package:open_seed/openseed/models/models.dart';
import 'package:open_seed/openseed/models/weather_converter.dart';
import 'package:open_seed/repository/repository.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:weather/weather.dart';

part 'openseed_bloc.g.dart';
part 'openseed_event.dart';
part 'openseed_state.dart';

class OpenSeedBloc extends HydratedBloc<OpenSeedEvent, OpenSeedState> {
  final _logger = Logger();
  final IPlantApiClient iplantApiClient;
  final DatabaseRepository db;

  static const homeBackgroundImage = "assets/images/home_bg.jpg";

  WeatherFactory? _weather;

  mnn.Interpreter? _net;
  mnn.Session? _session;
  mnn.ScheduleConfig? _scheduleConfig;
  final LabelHelper _labelHelper = LabelHelper()..loadLabels();

  OpenSeedBloc({required this.iplantApiClient, required this.db}) : super(const OpenSeedState()) {
    on<OpenSeedInitEvent>(_onInitEvent);
    on<OpenSeedBottomNavChanged>(_onBottomNavChanged);
    on<OpenSeedSettingsChanged>(_onSettingsChanged);
    on<OpenSeedWeatherRefreshed>(_onWeatherRefreshed);
    on<OpenSeedInferenceImageBytesChanged>(_onInferenceImageBytesChanged);
    on<OpenSeedInferenceStarted>(_onInferenceStarted);
    on<OpenSeedInferenceReset>(_onInferenceReset);
    on<OpenSeedSpDetailLaunched>(_onSpDetailLaunched);
    on<OpenSeedExploreFetchMoreItems>(_onExploreFetchMoreItems);
    on<OpenSeedExploreSearchChanged>(_onExploreSearchChanged);
    on<OpenSeedExploreClearSearch>(_onExploreClearSearch);
  }

  // Global
  Future<void> _onInitEvent(OpenSeedInitEvent event, Emitter<OpenSeedState> emit) async {
    await _onModelChanged(state.settingsState, emit);
    await db.init();
    final indexInfo = await iplantApiClient.getIndexInfo();
    emit(state.copyWith(homeBgImageUrl: indexInfo.imgUrl));
    _weather = WeatherFactory(Env.weatherApiKey, language: state.settingsState.language.weatherLanguage);
  }

  void _onBottomNavChanged(OpenSeedBottomNavChanged event, Emitter<OpenSeedState> emit) {
    emit(state.copyWith(currentBottomNavIndex: event.index));
  }

  Future<void> _onSettingsChanged(OpenSeedSettingsChanged event, Emitter<OpenSeedState> emit) async {
    final settings = event.settings;

    if (settings.language != state.settingsState.language) {
      _weather = WeatherFactory(Env.weatherApiKey, language: settings.language.weatherLanguage);
      emit(state.copyWith(settingsState: settings));
    }

    if (settings.modelConfig != state.settingsState.modelConfig ||
        settings.backendType != state.settingsState.backendType ||
        settings.numThreads != state.settingsState.numThreads) {
      await _onModelChanged(settings, emit);
    } else {
      emit(state.copyWith(settingsState: settings));
    }
  }

  Future<void> _onWeatherRefreshed(OpenSeedWeatherRefreshed event, Emitter<OpenSeedState> emit) async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      _logger.e('Location services are disabled.');
      return;
    }
    final permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      final permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        _logger.e('Location permissions are permanently denied, we cannot request permissions.');
        return;
      }
    }
    try {
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.lowest,
          timeLimit: Duration(seconds: 5),
        ),
      );
      _logger.d("position: $position");

      final w = await _weather?.currentWeatherByLocation(position.latitude, position.longitude);
      _logger.d("weather: $w");
      emit(state.copyWith(weather: w));
    } catch (e) {
      _logger.e("get weather error: $e");
    }
  }

  // explore
  Future<void> _onExploreFetchMoreItems(
    OpenSeedExploreFetchMoreItems event,
    Emitter<OpenSeedState> emit,
  ) async {
    try {
      // 确定搜索状态
      final searchStatus = switch ((state.prevQuery.isEmpty, event.query.isEmpty)) {
        (true, true) => SearchStatus.initial, // 初始状态，无查询
        (true, false) => SearchStatus.started, // 开始新查询
        (false, true) => SearchStatus.ended, // 结束查询，返回初始列表
        (false, false) when event.query != state.prevQuery => SearchStatus.started, // 查询条件变化，视为新查询
        (false, false) => SearchStatus.searching, // 继续当前查询，加载更多
      };

      // 根据搜索状态更新UI状态
      switch (searchStatus) {
        case SearchStatus.initial:
          // 初始加载，显示加载状态
          emit(state.copyWith(exploreStatus: ExploreStatus.loading));
        case SearchStatus.started:
          // 新查询开始，重置页码和列表，显示加载状态
          emit(
            state.copyWith(
              exploreStatus: ExploreStatus.loading,
              exploreCurPage: 0,
              searchCurPage: 0,
              prevQuery: event.query,
              exploreItems: const [],
            ),
          );
        case SearchStatus.searching:
          // 继续当前查询，显示加载状态
          emit(state.copyWith(exploreStatus: ExploreStatus.loading));
        case SearchStatus.ended:
          // 结束查询，返回初始列表，重置页码和列表，显示加载状态
          emit(
            state.copyWith(
              exploreStatus: ExploreStatus.loading,
              searchCurPage: 0,
              exploreCurPage: 0,
              prevQuery: "", // 清空查询条件
              exploreItems: const [],
            ),
          );
      }

      // 获取当前页码 - 根据是否有查询条件选择不同的页码计数器
      final curPage = event.query.isEmpty ? state.exploreCurPage : state.searchCurPage;

      // 获取总数和当前页数据
      final maxItems = await db.getIPlantBkItemsCount(search: event.query);
      final moreItems = await db.getIPlantBkItems(page: curPage, search: event.query);

      // 如果没有更多数据但不是第一页，表示已加载全部数据
      if (moreItems.isEmpty && curPage > 0) {
        emit(state.copyWith(exploreStatus: ExploreStatus.loaded, maxItems: maxItems));
        return;
      }

      // 如果是第一页且没有数据，显示空结果状态
      if (moreItems.isEmpty && curPage == 0) {
        emit(state.copyWith(exploreStatus: ExploreStatus.loaded, maxItems: 0, exploreItems: const []));
        return;
      }

      // 合并数据
      final exploreItems = [...state.exploreItems, ...moreItems];

      // 更新状态 - 根据是否有查询条件更新不同的页码计数器
      if (event.query.isEmpty) {
        emit(
          state.copyWith(
            exploreStatus: ExploreStatus.loaded,
            exploreItems: exploreItems,
            exploreCurPage: curPage + 1,
            maxItems: maxItems,
          ),
        );
      } else {
        emit(
          state.copyWith(
            exploreStatus: ExploreStatus.loaded,
            exploreItems: exploreItems,
            searchCurPage: curPage + 1,
            prevQuery: event.query,
            maxItems: maxItems,
          ),
        );
      }
    } catch (e) {
      _logger.e("Error fetching explore items: $e");
      emit(state.copyWith(exploreStatus: ExploreStatus.error));
    }
  }

  // inference
  Future<void> _onModelChanged(SettingsState settings, Emitter<OpenSeedState> emit) async {
    await _loadModel(settings);
    if (_net == null || _session == null) {
      emit(state.copyWith(modelStatus: ModelStatus.error, settingsState: settings));
      return;
    }
    emit(
      state.copyWith(
        modelStatus: ModelStatus.loaded,
        inferenceInfo: InferenceInfo(
          memoryInfo: _session!.memoryInfo,
          flops: _session!.flopsInfo,
          backendType: _session!.backendsInfo,
          currentBackend: BackendType.fromId(_session!.backendsInfo.first),
        ),
        results: const [],
        settingsState: settings,
      ),
    );
  }

  // inference
  Future<void> _loadModel(SettingsState settings) async {
    _net?.dispose();
    _session = null;
    _net = null;

    final modelConfig = settings.modelConfig;
    final numThreads = settings.numThreads;
    final backend = settings.backendType;
    final uri = await modelConfig.modelLoadUri();

    _logger.d("Loading model: $uri");

    _net = switch (modelConfig.type) {
      ModelType.assets => await InferenceHelper.loadModelFromAssets(uri),
      ModelType.file => InferenceHelper.loadModel(uri),
      ModelType.api => throw UnimplementedError(),
    };

    _net?.setSessionMode(mnn.SessionMode.Session_Backend_Fix);
    _scheduleConfig =
        backend == BackendType.cpu
            ? mnn.ScheduleConfig.create(numThread: numThreads, type: mnn.ForwardType.fromValue(backend.id))
            : mnn.ScheduleConfig.create(type: mnn.ForwardType.fromValue(backend.id));
    _session = _net?.createSession(config: _scheduleConfig);

    _logger.d("_scheduleConfig: $_scheduleConfig");
    _logger.d("_session: $_session");
    _logger.d("_net: $_net");
  }

  Future<void> _onInferenceImageBytesChanged(
    OpenSeedInferenceImageBytesChanged event,
    Emitter<OpenSeedState> emit,
  ) async {
    emit(state.copyWith(results: const []));

    add(OpenSeedInferenceStarted(event.imageBytes));
  }

  Future<void> _onInferenceStarted(OpenSeedInferenceStarted event, Emitter<OpenSeedState> emit) async {
    final settings = state.settingsState;
    if (_net == null || _session == null) {
      _logger.e('No model Loaded');
      return;
    }

    if (event.imageBytes == null) {
      _logger.e('No image selected');
      return;
    }

    emit(state.copyWith(status: OpenSeedInferenceStatus.inferencing, results: const []));

    try {
      _logger.i('Start inference');
      final startTime = DateTime.now().millisecondsSinceEpoch;
      final results = await InferenceHelper.inference(
        _session!,
        [event.imageBytes!],
        topK: settings.topK,
        labelHelper: _labelHelper,
      );
      final endTime = DateTime.now().millisecondsSinceEpoch;
      _logger.i('Inference finished');

      emit(
        state.copyWith(
          results: results,
          inferenceInfo: state.inferenceInfo?.copyWith(
            inferenceTime: endTime - startTime,
            meanInferenceTime: results.first.first.inferenceTime,
          ),
          status: OpenSeedInferenceStatus.success,
        ),
      );
    } catch (e) {
      _logger.e('Failed to perform inference: $e');
      emit(state.copyWith(status: OpenSeedInferenceStatus.failure));
    }
  }

  void _onInferenceReset(OpenSeedInferenceReset event, Emitter<OpenSeedState> emit) {
    _net?.dispose();
    _session = null;
    _net = null;

    _logger.d("model reseted");

    emit(
      state.copyWith(
        results: const [],
        inferenceInfo: null,
        status: OpenSeedInferenceStatus.initial,
        modelStatus: ModelStatus.empty,
      ),
    );
  }

  Future<void> _onSpDetailLaunched(OpenSeedSpDetailLaunched event, Emitter<OpenSeedState> emit) async {
    final url = await formatBkItemUrl(oseedId: event.oseedId, bkid: event.bkid, latinName: event.latinName);

    if (url == null) {
      _logger.e("failed to format url");
      return;
    }

    if (!await launchUrl(url)) {
      _logger.e("failed to launch url: $url");
    }
  }

  Future<Uri?> formatBkItemUrl({int? oseedId, int? bkid, String? latinName}) async {
    final bk = await db.getIPlantBkItem(oseedId: oseedId, spid: bkid, latinName: latinName);
    if (bk.spmd5 == null) {
      _logger.e("bk: $bk");
      return null;
    }
    final url = Uri.parse("${IPlantApiClient.bkBaseUrl}/${bk.spmd5!}");
    return url;
  }

  Future<SpeciesInfo> getSpInfo({int? oseedId, String? latinName}) async {
    final bk = await db.getIPlantBkItem(oseedId: oseedId, latinName: latinName);
    if (bk.spmd5 == null) {
      _logger.e("bk: $bk");
      return const SpeciesInfo();
    }
    final spInfo = await iplantApiClient.getSpeciesInfoFromHtml(bk.spmd5!);
    return spInfo;
  }

  void _onExploreSearchChanged(OpenSeedExploreSearchChanged event, Emitter<OpenSeedState> emit) {
    emit(state.copyWith(searchQuery: event.query));
  }

  void _onExploreClearSearch(OpenSeedExploreClearSearch event, Emitter<OpenSeedState> emit) {
    emit(state.copyWith(searchQuery: ""));
    add(OpenSeedExploreFetchMoreItems());
  }

  @override
  OpenSeedState? fromJson(Map<String, dynamic> json) => OpenSeedState.fromJson(json);
  @override
  Map<String, dynamic>? toJson(OpenSeedState state) => state.toJson();
}
