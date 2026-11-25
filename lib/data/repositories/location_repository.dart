import 'dart:async';
import 'dart:io';

import 'package:hive/hive.dart';

import '../models/location_model.dart';
import '../services/geocoding_service.dart';
import '../../core/constants/hive_boxes.dart';
import '../../core/errors/app_failure.dart';

class LocationRepository {
  LocationRepository(
    this._service, {
    required Box<LocationModel> favorites,
    required Box<LocationModel> history,
    required Box<LocationModel> lastLocation,
  }) : _favorites = favorites,
       _history = history,
       _last = lastLocation;

  final GeocodingService _service;
  final Box<LocationModel> _favorites;
  final Box<LocationModel> _history;
  final Box<LocationModel> _last;

  // NETWORK
  Future<List<LocationModel>> search(String query) async {
    try {
      return await _service.search(query);
    } on SocketException {
      throw AppFailure('Tidak ada koneksi internet.');
    } on TimeoutException {
      throw AppFailure('Pencarian terlalu lama. Coba lagi.');
    } on FormatException {
      throw AppFailure('Format data dari server tidak sesuai.');
    } on AppFailure {
      rethrow;
    } catch (_) {
      throw AppFailure('Pencarian kota gagal.');
    }
  }

  // FAVORIT
  List<LocationModel> getFavorites() =>
      _favorites.values.toList().reversed.toList();

  bool isFavorite(int id) => _favorites.containsKey(id.toString());

  Future<void> toggleFavorite(LocationModel loc) async {
    final key = loc.id.toString();
    if (_favorites.containsKey(key)) {
      await _favorites.delete(key);
    } else {
      await _favorites.put(key, loc);
    }
  }

  Future<void> removeFavorite(int id) => _favorites.delete(id.toString());

  // ---------- RIWAYAT ----------
  List<LocationModel> getHistory() =>
      _history.values.toList().reversed.toList();

  Future<void> addHistory(LocationModel loc) async {
    final key = loc.id.toString();
    await _history.delete(key);
    await _history.put(key, loc);
    while (_history.length > HiveBoxes.maxHistory) {
      await _history.deleteAt(0);
    }
  }

  Future<void> clearHistory() => _history.clear();

  // LOKASI TERAKHIR
  LocationModel? getLastLocation() => _last.get(HiveBoxes.lastKey);

  Future<void> saveLastLocation(LocationModel loc) =>
      _last.put(HiveBoxes.lastKey, loc);
}
