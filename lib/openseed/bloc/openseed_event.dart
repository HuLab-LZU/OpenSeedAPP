part of 'openseed_bloc.dart';

@immutable
sealed class OpenSeedEvent {}

// global
final class OpenSeedInitEvent extends OpenSeedEvent {}

final class OpenSeedBottomNavChanged extends OpenSeedEvent {
  final int index;
  OpenSeedBottomNavChanged(this.index);
}

final class OpenSeedSettingsChanged extends OpenSeedEvent {
  final SettingsState settings;
  OpenSeedSettingsChanged(this.settings);
}

final class OpenSeedWeatherRefreshed extends OpenSeedEvent {}

// explore
final class OpenSeedExploreFetchMoreItems extends OpenSeedEvent {
  final String query;
  OpenSeedExploreFetchMoreItems({this.query = ""});
}

final class OpenSeedExploreSearchChanged extends OpenSeedEvent {
  final String query;
  OpenSeedExploreSearchChanged(this.query);
}

final class OpenSeedExploreClearSearch extends OpenSeedEvent {}

// inference
final class OpenSeedInferenceImageBytesChanged extends OpenSeedEvent {
  final Uint8List imageBytes;
  OpenSeedInferenceImageBytesChanged(this.imageBytes);
}

final class OpenSeedInferenceStarted extends OpenSeedEvent {
  final Uint8List? imageBytes;
  OpenSeedInferenceStarted(this.imageBytes);
}

final class OpenSeedInferenceStopped extends OpenSeedEvent {}

final class OpenSeedInferenceReset extends OpenSeedEvent {}

final class OpenSeedSpDetailLaunched extends OpenSeedEvent {
  final int? oseedId;
  final int? bkid;
  final String? latinName;
  OpenSeedSpDetailLaunched({this.oseedId, this.bkid, this.latinName});
}
