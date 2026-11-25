import 'dart:async';
import 'dart:io';

import '../models/location_model.dart';
import '../models/weather_model.dart';
import '../services/weather_service.dart';
import '../../core/errors/app_failure.dart';

class WeatherRepository {
  WeatherRepository(this._service);
  final WeatherService _service;

  Future<WeatherModel> getWeather(LocationModel loc) async {
    try {
      return await _service.fetch(loc.latitude, loc.longitude);
    } on SocketException {
      throw AppFailure('Tidak ada koneksi internet.');
    } on TimeoutException {
      throw AppFailure('Koneksi terlalu lama. Coba lagi.');
    } on FormatException {
      throw AppFailure('Format data dari server tidak sesuai.');
    } on AppFailure {
      rethrow;
    } catch (_) {
      throw AppFailure('Gagal memuat data cuaca.');
    }
  }
}
