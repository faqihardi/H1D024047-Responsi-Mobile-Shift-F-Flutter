import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import '../../core/utils/formatters.dart';
import '../../data/models/weather_model.dart';
import 'common_widgets.dart';

class WeatherDetailGrid extends StatelessWidget {
  final WeatherModel weather;
  const WeatherDetailGrid({super.key, required this.weather});

  @override
  Widget build(BuildContext context) {
    final c = weather.current;
    final items = [
      _Item('Kelembapan', Fmt.percent(c.humidity), Icons.opacity_rounded),
      _Item('Angin', Fmt.wind(c.windSpeed), Icons.air_rounded),
      _Item(
        'Peluang Hujan',
        Fmt.percent(weather.todayRainChance),
        Icons.grain_rounded,
      ),
      _Item('Curah Hujan', Fmt.mm(c.precipitation), Icons.water_drop_outlined),
    ];

    // Responsif: 2 kolom di layar sempit, 4 kolom di layar lebar.
    return LayoutBuilder(
      builder: (context, constraints) {
        final cols = constraints.maxWidth > 520 ? 4 : 2;
        const gap = 12.0;
        final width = (constraints.maxWidth - gap * (cols - 1)) / cols;

        return Wrap(
          spacing: gap,
          runSpacing: gap,
          children: items
              .map(
                (e) => SizedBox(
                  width: width,
                  child: _Tile(item: e),
                ),
              )
              .toList(),
        );
      },
    );
  }
}

class _Item {
  final String label;
  final String value;
  final IconData icon;
  _Item(this.label, this.value, this.icon);
}

class _Tile extends StatelessWidget {
  final _Item item;
  const _Tile({required this.item});

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return AppCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(item.icon, size: 18, color: AppColors.muted),
          const SizedBox(height: 12),
          Text(item.label.toUpperCase(), style: t.labelSmall),
          const SizedBox(height: 4),
          Text(item.value, style: t.titleMedium),
        ],
      ),
    );
  }
}
