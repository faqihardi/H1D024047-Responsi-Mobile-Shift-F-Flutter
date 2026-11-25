import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/location_model.dart';
import '../../core/constants/api_constants.dart';
import '../../core/errors/app_failure.dart';

class GeocodingService {
  GeocodingService({http.Client? client}) : _client = client ?? http.Client();
  final http.Client _client;

  Future<List<LocationModel>> search(String query) async {
    final uri = Uri.parse('${ApiConstants.geocodingBase}/search').replace(
      queryParameters: {
        'name': query,
        'count': '10',
        'language': 'id',
        'format': 'json',
      },
    );

    final res = await _client.get(uri).timeout(ApiConstants.timeout);
    if (res.statusCode != 200) {
      throw AppFailure('Server pencarian bermasalah (${res.statusCode}).');
    }

    final body = jsonDecode(res.body) as Map<String, dynamic>;
    final results = (body['results'] as List?) ?? [];
    return results
        .map((e) => LocationModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
