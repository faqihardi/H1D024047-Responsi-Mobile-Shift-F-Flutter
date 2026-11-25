import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/errors/app_failure.dart';
import '../../data/models/location_model.dart';
import '../../data/repositories/location_repository.dart';
import '../../data/repositories/weather_repository.dart';
import 'weather_state.dart';

class WeatherCubit extends Cubit<WeatherState> {
  WeatherCubit(this._weatherRepo, this._locationRepo)
    : super(const WeatherState());

  final WeatherRepository _weatherRepo;
  final LocationRepository _locationRepo;

  Future<void> start() async {
    final last = _locationRepo.getLastLocation();
    if (last == null) {
      emit(const WeatherState());
      return;
    }
    await load(last);
  }

  Future<void> load(LocationModel loc) async {
    emit(WeatherState(status: WeatherStatus.loading, location: loc));
    try {
      final data = await _weatherRepo.getWeather(loc);
      await _locationRepo.saveLastLocation(loc);
      await _locationRepo.addHistory(loc);
      emit(
        WeatherState(
          status: WeatherStatus.success,
          location: loc,
          weather: data,
        ),
      );
    } on AppFailure catch (e) {
      emit(
        WeatherState(
          status: WeatherStatus.error,
          location: loc,
          message: e.message,
        ),
      );
    }
  }

  Future<void> refresh() async {
    final loc = state.location;
    if (loc != null) await load(loc);
  }
}
