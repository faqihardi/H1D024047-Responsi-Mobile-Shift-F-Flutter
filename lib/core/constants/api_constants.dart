class ApiConstants {
  static const geocodingBase = 'https://geocoding-api.open-meteo.com/v1';
  static const forecastBase = 'https://api.open-meteo.com/v1';

  static const currentFields = [
    'temperature_2m',
    'relative_humidity_2m',
    'apparent_temperature',
    'precipitation',
    'weather_code',
    'wind_speed_10m',
  ];

  static const dailyFields = [
    'temperature_2m_max',
    'temperature_2m_min',
    'precipitation_probability_max',
    'weather_code',
  ];

  static const forecastDays = 7;
  static const timeout = Duration(seconds: 15);
}
