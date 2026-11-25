import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/theme/app_theme.dart';
import 'data/repositories/location_repository.dart';
import 'data/repositories/weather_repository.dart';
import 'view/screens/weather_screen.dart';
import 'viewmodel/favorites/favorites_cubit.dart';
import 'viewmodel/weather/weather_cubit.dart';

class WeatherApp extends StatelessWidget {
  const WeatherApp({
    super.key,
    required this.weatherRepository,
    required this.locationRepository,
  });

  final WeatherRepository weatherRepository;
  final LocationRepository locationRepository;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: weatherRepository),
        RepositoryProvider.value(value: locationRepository),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (c) => FavoritesCubit(c.read<LocationRepository>())..load(),
          ),
          BlocProvider(
            create: (c) => WeatherCubit(
              c.read<WeatherRepository>(),
              c.read<LocationRepository>(),
            )..start(),
          ),
        ],
        child: MaterialApp(
          title: 'Cuaca',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light(),
          home: const WeatherScreen(),
        ),
      ),
    );
  }
}
