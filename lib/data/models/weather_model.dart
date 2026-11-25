class CurrentWeather {
  final DateTime time;
  final double temperature;
  final double apparentTemperature;
  final int humidity;
  final double precipitation;
  final int weatherCode;
  final double windSpeed;

  const CurrentWeather({
    required this.time,
    required this.temperature,
    required this.apparentTemperature,
    required this.humidity,
    required this.precipitation,
    required this.weatherCode,
    required this.windSpeed,
  });

  factory CurrentWeather.fromJson(Map<String, dynamic> j) => CurrentWeather(
    time: DateTime.tryParse(j['time'] as String? ?? '') ?? DateTime.now(),
    temperature: (j['temperature_2m'] as num?)?.toDouble() ?? 0,
    apparentTemperature: (j['apparent_temperature'] as num?)?.toDouble() ?? 0,
    humidity: (j['relative_humidity_2m'] as num?)?.toInt() ?? 0,
    precipitation: (j['precipitation'] as num?)?.toDouble() ?? 0,
    weatherCode: (j['weather_code'] as num?)?.toInt() ?? 0,
    windSpeed: (j['wind_speed_10m'] as num?)?.toDouble() ?? 0,
  );
}

class DailyForecast {
  final DateTime date;
  final double tempMax;
  final double tempMin;
  final int? rainChance;
  final int weatherCode;

  const DailyForecast({
    required this.date,
    required this.tempMax,
    required this.tempMin,
    required this.rainChance,
    required this.weatherCode,
  });
}

class WeatherModel {
  final CurrentWeather current;
  final List<DailyForecast> daily;
  final String timezone;

  const WeatherModel({
    required this.current,
    required this.daily,
    required this.timezone,
  });

  /// Peluang hujan hari ini (daily[0])
  int? get todayRainChance => daily.isEmpty ? null : daily.first.rainChance;

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    final d = (json['daily'] as Map<String, dynamic>?) ?? {};
    final times = (d['time'] as List?)?.cast<String>() ?? [];
    final maxT = (d['temperature_2m_max'] as List?) ?? [];
    final minT = (d['temperature_2m_min'] as List?) ?? [];
    final rain = (d['precipitation_probability_max'] as List?) ?? [];
    final codes = (d['weather_code'] as List?) ?? [];

    double numAt(List l, int i) =>
        i < l.length && l[i] is num ? (l[i] as num).toDouble() : 0;
    int? intAt(List l, int i) =>
        i < l.length && l[i] is num ? (l[i] as num).toInt() : null;

    return WeatherModel(
      current: CurrentWeather.fromJson(
        (json['current'] as Map<String, dynamic>?) ?? {},
      ),
      daily: List.generate(
        times.length,
        (i) => DailyForecast(
          date: DateTime.parse(times[i]),
          tempMax: numAt(maxT, i),
          tempMin: numAt(minT, i),
          rainChance: intAt(rain, i),
          weatherCode: intAt(codes, i) ?? 0,
        ),
      ),
      timezone: (json['timezone'] as String?) ?? 'auto',
    );
  }
}
