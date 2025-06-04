import 'package:json_annotation/json_annotation.dart';
import 'package:weather/weather.dart';

class WeatherJsonConverter implements JsonConverter<Weather?, Map<String, dynamic>?> {
  const WeatherJsonConverter();

  @override
  Weather? fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return null;
    }
    return Weather(json);
  }

  @override
  Map<String, dynamic>? toJson(Weather? weather) {
    if (weather == null) {
      return null;
    }
    return weather.toJson();
  }
}
