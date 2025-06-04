import 'package:weather/weather.dart';

extension WeatherX on Weather {
  String? formatIconUrl({int scale = 4, String urlIconBase = "https://openweathermap.org/img/wn"}) {
    return weatherIcon == null ? null : "$urlIconBase/$weatherIcon@${scale}x.png";
  }
}
