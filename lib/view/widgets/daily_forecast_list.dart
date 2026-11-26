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
    final headerStyle = t.labelSmall?.copyWith(fontSize: 10);

    return AppCard(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 8, bottom: 10),
            child: Row(
              children: [
                SizedBox(width: 52, child: Text('HARI', style: headerStyle)),
                const SizedBox(width: 20), // ruang ikon cuaca
                const SizedBox(width: 12),
                Expanded(child: Text('KONDISI', style: headerStyle)),
                SizedBox(
                  width: 44,
                  child: Text(
                    'HUJAN',
                    style: headerStyle,
                    textAlign: TextAlign.right,
                  ),
                ),
                const SizedBox(width: 12),
                SizedBox(
                  width: 30,
                  child: Text(
                    'MIN',
                    style: headerStyle,
                    textAlign: TextAlign.right,
                  ),
                ),
                const SizedBox(width: 8),
                SizedBox(
                  width: 34,
                  child: Text(
                    'MAKS',
                    style: headerStyle,
                    textAlign: TextAlign.right,
                    maxLines: 1,
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, thickness: 1, color: AppColors.border),
          ...List.generate(items.length, (i) {
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
                      SizedBox(
                        width: 30,
                        child: Text(
                          Fmt.temp(d.tempMin),
                          style: t.bodyMedium?.copyWith(color: AppColors.faint),
                          textAlign: TextAlign.right,
                          maxLines: 1,
                        ),
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
                  const Divider(
                    height: 1,
                    thickness: 1,
                    color: AppColors.border,
                  ),
              ],
            );
          }),
        ],
      ),
    );
  }
}
