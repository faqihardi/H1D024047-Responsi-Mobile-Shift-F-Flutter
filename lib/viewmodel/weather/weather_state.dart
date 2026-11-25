import '../../data/models/location_model.dart';
import '../../data/models/weather_model.dart';

enum WeatherStatus { initial, loading, success, error }

class WeatherState {
  final WeatherStatus status;
  final LocationModel? location;
  final WeatherModel? weather;
  final String? message;

  const WeatherState({
    this.status = WeatherStatus.initial,
    this.location,
    this.weather,
    this.message,
  });
}
