import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied(path: '.env')
abstract class Env {
  @EnviedField(varName: 'WEATHER_API_KEY', obfuscate: true)
  static final String weatherApiKey = _Env.weatherApiKey;

  @EnviedField(varName: 'OPENSEED_DB_KEY', obfuscate: true)
  static final String openSeedDbKey = _Env.openSeedDbKey;
}
