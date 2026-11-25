import 'package:hive/hive.dart';

class LocationModel {
  final int id;
  final String name;
  final String? admin1;
  final String? country;
  final String? countryCode;
  final double latitude;
  final double longitude;
  final String? timezone;

  const LocationModel({
    required this.id,
    required this.name,
    this.admin1,
    this.country,
    this.countryCode,
    required this.latitude,
    required this.longitude,
    this.timezone,
  });

  String get subtitle => [
    admin1,
    country,
  ].where((e) => e != null && e.trim().isNotEmpty).join(', ');

  factory LocationModel.fromJson(Map<String, dynamic> json) => LocationModel(
    id: (json['id'] as num).toInt(),
    name: (json['name'] as String?) ?? '-',
    admin1: json['admin1'] as String?,
    country: json['country'] as String?,
    countryCode: json['country_code'] as String?,
    latitude: (json['latitude'] as num).toDouble(),
    longitude: (json['longitude'] as num).toDouble(),
    timezone: json['timezone'] as String?,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'admin1': admin1,
    'country': country,
    'country_code': countryCode,
    'latitude': latitude,
    'longitude': longitude,
    'timezone': timezone,
  };
}

/// TypeAdapter
class LocationModelAdapter extends TypeAdapter<LocationModel> {
  @override
  final int typeId = 0;

  @override
  LocationModel read(BinaryReader reader) =>
      LocationModel.fromJson(Map<String, dynamic>.from(reader.readMap()));

  @override
  void write(BinaryWriter writer, LocationModel obj) =>
      writer.writeMap(obj.toJson());
}
