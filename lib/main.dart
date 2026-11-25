import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'app.dart';
import 'core/constants/hive_boxes.dart';
import 'data/models/location_model.dart';
import 'data/repositories/location_repository.dart';
import 'data/repositories/weather_repository.dart';
import 'data/services/geocoding_service.dart';
import 'data/services/weather_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  Hive.registerAdapter(LocationModelAdapter());

  final favorites = await Hive.openBox<LocationModel>(HiveBoxes.favorites);
  final history = await Hive.openBox<LocationModel>(HiveBoxes.history);
  final lastLocation = await Hive.openBox<LocationModel>(
    HiveBoxes.lastLocation,
  );

  final locationRepository = LocationRepository(
    GeocodingService(),
    favorites: favorites,
    history: history,
    lastLocation: lastLocation,
  );
  final weatherRepository = WeatherRepository(WeatherService());

  runApp(
    WeatherApp(
      weatherRepository: weatherRepository,
      locationRepository: locationRepository,
    ),
  );
}
