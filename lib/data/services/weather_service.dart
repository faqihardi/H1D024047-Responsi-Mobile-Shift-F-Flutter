import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/weather_model.dart';
import '../../core/constants/api_constants.dart';
import '../../core/errors/app_failure.dart';

class WeatherService {
  WeatherService({http.Client? client}) : _client = client ?? http.Client();
  final http.Client _client;

  Future<WeatherModel> fetch(double latitude, double longitude) async {
    final uri = Uri.parse('${ApiConstants.forecastBase}/forecast').replace(
      queryParameters: {
        'latitude': latitude.toString(),
        'longitude': longitude.toString(),
        'current': ApiConstants.currentFields.join(','),
        'daily': ApiConstants.dailyFields.join(','),
        'timezone': 'auto',
        'forecast_days': ApiConstants.forecastDays.toString(),
      },
    );

    final res = await _client.get(uri).timeout(ApiConstants.timeout);
    if (res.statusCode != 200) {
      throw AppFailure('Gagal memuat cuaca (${res.statusCode}).');
    }

    return WeatherModel.fromJson(jsonDecode(res.body) as Map<String, dynamic>);
  }
}
