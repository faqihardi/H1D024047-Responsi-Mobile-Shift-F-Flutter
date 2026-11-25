import 'package:flutter/material.dart';

class WeatherInfo {
  final String label;
  final IconData icon;
  const WeatherInfo(this.label, this.icon);
}

/// WMO weather interpretation code -> label Indonesia + ikon.
class WeatherCodeMapper {
  static WeatherInfo map(int code) {
    switch (code) {
      case 0:
        return const WeatherInfo('Cerah', Icons.wb_sunny_outlined);
      case 1:
        return const WeatherInfo('Cerah Berawan', Icons.cloud_outlined);
      case 2:
        return const WeatherInfo('Berawan Sebagian', Icons.cloud_outlined);
      case 3:
        return const WeatherInfo('Berawan', Icons.cloud_queue);
      case 45:
      case 48:
        return const WeatherInfo('Berkabut', Icons.dehaze_rounded);
      case 51:
      case 53:
      case 55:
        return const WeatherInfo('Gerimis', Icons.grain_rounded);
      case 56:
      case 57:
        return const WeatherInfo('Gerimis Beku', Icons.ac_unit_outlined);
      case 61:
        return const WeatherInfo('Hujan Ringan', Icons.grain_rounded);
      case 63:
        return const WeatherInfo('Hujan', Icons.grain_rounded);
      case 65:
        return const WeatherInfo('Hujan Lebat', Icons.grain_rounded);
      case 66:
      case 67:
        return const WeatherInfo('Hujan Beku', Icons.ac_unit_outlined);
      case 71:
      case 73:
      case 75:
      case 77:
        return const WeatherInfo('Salju', Icons.ac_unit_outlined);
      case 80:
      case 81:
      case 82:
        return const WeatherInfo('Hujan Lokal', Icons.grain_rounded);
      case 85:
      case 86:
        return const WeatherInfo('Hujan Salju', Icons.ac_unit_outlined);
      case 95:
        return const WeatherInfo('Badai Petir', Icons.flash_on_rounded);
      case 96:
      case 99:
        return const WeatherInfo('Badai & Hujan Es', Icons.flash_on_rounded);
      default:
        return const WeatherInfo('Tidak Diketahui', Icons.help_outline_rounded);
    }
  }
}
