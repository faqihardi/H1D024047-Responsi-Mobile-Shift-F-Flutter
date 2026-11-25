import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import '../../core/utils/formatters.dart';
import '../../core/utils/weather_code_mapper.dart';
import '../../data/models/weather_model.dart';
import 'common_widgets.dart';

class DailyForecastList extends StatelessWidget {
  final List<DailyForecast> items;
  const DailyForecastList({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;

    return AppCard(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Column(
        children: List.generate(items.length, (i) {
          final d = items[i];
          final info = WeatherCodeMapper.map(d.weatherCode);
          final today = Fmt.isToday(d.date);

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 14),
                child: Row(
                  children: [
                    SizedBox(
                      width: 52,
                      child: Text(
                        today ? 'Hari ini' : Fmt.dayShort(d.date),
                        style: today ? t.titleSmall : t.bodyMedium,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Icon(info.icon, size: 20, color: AppColors.muted),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        info.label,
                        style: t.bodySmall,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(
                      width: 44,
                      child: Text(
                        Fmt.percent(d.rainChance),
                        style: t.bodySmall,
                        textAlign: TextAlign.right,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      Fmt.temp(d.tempMin),
                      style: t.bodyMedium?.copyWith(color: AppColors.faint),
                    ),
                    const SizedBox(width: 8),
                    SizedBox(
                      width: 34,
                      child: Text(
                        Fmt.temp(d.tempMax),
                        style: t.titleSmall,
                        textAlign: TextAlign.right,
                      ),
                    ),
                  ],
                ),
              ),
              if (i != items.length - 1)
                const Divider(height: 1, thickness: 1, color: AppColors.border),
            ],
          );
        }),
      ),
    );
  }
}
