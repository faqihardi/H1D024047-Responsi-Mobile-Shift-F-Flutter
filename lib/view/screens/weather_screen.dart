import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/theme/app_theme.dart';
import '../../viewmodel/favorites/favorites_cubit.dart';
import '../../viewmodel/favorites/favorites_state.dart';
import '../../viewmodel/weather/weather_cubit.dart';
import '../../viewmodel/weather/weather_state.dart';
import '../widgets/common_widgets.dart';
import '../widgets/current_weather_card.dart';
import '../widgets/daily_forecast_list.dart';
import '../widgets/weather_detail_grid.dart';
import 'search_screen.dart';

class WeatherScreen extends StatelessWidget {
  const WeatherScreen({super.key});

  void _openSearch(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => const SearchScreen()));
  }

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cuaca'),
        actions: [
          BlocBuilder<WeatherCubit, WeatherState>(
            builder: (context, state) => IconButton(
              tooltip: 'Muat ulang',
              onPressed: state.location == null
                  ? null
                  : () => context.read<WeatherCubit>().refresh(),
              icon: const Icon(Icons.refresh_rounded, size: 22),
            ),
          ),
          IconButton(
            tooltip: 'Cari kota',
            onPressed: () => _openSearch(context),
            icon: const Icon(Icons.search_rounded, size: 22),
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: SafeArea(
        child: BlocBuilder<WeatherCubit, WeatherState>(
          builder: (context, state) {
            if (state.status == WeatherStatus.loading) {
              return const LoadingView(
                label: 'Mengambil data dari Open-Meteo...',
              );
            }

            if (state.status == WeatherStatus.error) {
              return ErrorView(
                message: state.message ?? 'Terjadi kesalahan.',
                onRetry: () => context.read<WeatherCubit>().refresh(),
              );
            }

            if (state.status == WeatherStatus.initial ||
                state.weather == null) {
              return EmptyView(
                icon: Icons.location_searching_rounded,
                title: 'Belum Ada Lokasi',
                subtitle: 'Cari nama kota untuk melihat cuaca terkini.',
                action: FilledButton.icon(
                  onPressed: () => _openSearch(context),
                  icon: const Icon(Icons.search_rounded, size: 18),
                  label: const Text('Cari Kota'),
                ),
              );
            }

            final weather = state.weather!;
            return RefreshIndicator(
              onRefresh: () => context.read<WeatherCubit>().refresh(),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 640),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        BlocBuilder<FavoritesCubit, FavoritesState>(
                          builder: (context, fav) {
                            if (fav.items.isEmpty) {
                              return const SizedBox.shrink();
                            }
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SectionTitle('Lokasi Favorit'),
                                  const SizedBox(height: 12),
                                  Wrap(
                                    spacing: 8,
                                    runSpacing: 8,
                                    children: fav.items
                                        .map(
                                          (loc) => ActionChip(
                                            backgroundColor: AppColors.surface,
                                            side: const BorderSide(
                                              color: AppColors.border,
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            label: Text(
                                              loc.name,
                                              style: t.titleSmall,
                                            ),
                                            onPressed: () => context
                                                .read<WeatherCubit>()
                                                .load(loc),
                                          ),
                                        )
                                        .toList(),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                        BlocBuilder<FavoritesCubit, FavoritesState>(
                          builder: (context, fav) => CurrentWeatherCard(
                            location: state.location!,
                            weather: weather,
                            isFavorite: fav.contains(state.location!.id),
                            onFavorite: () => context
                                .read<FavoritesCubit>()
                                .toggle(state.location!),
                          ),
                        ),
                        const SizedBox(height: 12),
                        WeatherDetailGrid(weather: weather),
                        const SizedBox(height: 28),
                        const SectionTitle('Perkiraan 7 Hari'),
                        const SizedBox(height: 12),
                        DailyForecastList(items: weather.daily),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
