import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import '../../core/utils/formatters.dart';
import '../../core/utils/weather_code_mapper.dart';
import '../../data/models/location_model.dart';
import '../../data/models/weather_model.dart';
import 'common_widgets.dart';

class CurrentWeatherCard extends StatelessWidget {
  final LocationModel location;
  final WeatherModel weather;
  const CurrentWeatherCard({
    super.key,
    required this.location,
    required this.weather,
  });

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final c = weather.current;
    final info = WeatherCodeMapper.map(c.weatherCode);

    return AppCard(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.location_on_outlined,
                size: 16,
                color: AppColors.muted,
              ),
              const SizedBox(width: 6),
              Expanded(child: Text(location.name, style: t.headlineSmall)),
            ],
          ),
          if (location.subtitle.isNotEmpty) ...[
            const SizedBox(height: 2),
            Text(location.subtitle, style: t.bodySmall),
          ],
          const SizedBox(height: 24),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(Fmt.temp(c.temperature), style: t.displayMedium),
              const Spacer(),
              Icon(info.icon, size: 56, color: AppColors.accent),
            ],
          ),
          const SizedBox(height: 12),
          Text(info.label, style: t.titleMedium),
          const SizedBox(height: 4),
          Text(
            'Terasa seperti ${Fmt.tempUnit(c.apparentTemperature)}',
            style: t.bodySmall,
          ),
        ],
      ),
    );
  }
}
