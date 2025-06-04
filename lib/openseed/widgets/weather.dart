import 'package:flutter/material.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:open_seed/openseed/models/weather_info.dart';
import 'package:weather/weather.dart';

class WeatherWidget extends StatelessWidget {
  const WeatherWidget({required this.weather, required this.onTap, super.key});

  final Weather? weather;
  final ValueGetter<Future<void>> onTap;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(5),
        // margin: const EdgeInsets.all(8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${weather?.temperature?.celsius?.round() ?? "-"} °C',
                  style: textTheme.displayMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                ),
                if (weather?.formatIconUrl() case final String url)
                  Image.network(url, width: 80, height: 80)
                else
                  const Icon(Symbols.cloud_off, color: Colors.white, size: 50),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Text(
                    weather?.weatherDescription ?? "",
                    style: textTheme.titleLarge?.copyWith(color: Colors.white),
                  ),
                ),
                Text(
                  "${weather?.tempMax?.celsius?.round() ?? ''} / ${weather?.tempMin?.celsius?.round() ?? ''} °C",
                  style: textTheme.titleLarge?.copyWith(color: Colors.white),
                ),
              ],
            ),
            Text(weather?.areaName ?? '-', style: textTheme.labelLarge?.copyWith(color: Colors.white)),
          ],
        ),
      ),
    );
  }
}

class WeatherBackground extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primaryContainer;
    return SizedBox.expand(
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: const [0.01, 0.75, 0.90, 1.0],
            colors: [color, color.brighten(), color.brighten(33), color.brighten(50)],
          ),
        ),
      ),
    );
  }
}

extension on Color {
  Color brighten([int percent = 10]) {
    assert(1 <= percent && percent <= 100, 'percentage must be between 1 and 100');
    final p = percent / 100;
    final alpha = a.round();
    final red = r.round();
    final green = g.round();
    final blue = b.round();
    return Color.fromARGB(
      alpha,
      red + ((255 - red) * p).round(),
      green + ((255 - green) * p).round(),
      blue + ((255 - blue) * p).round(),
    );
  }
}
