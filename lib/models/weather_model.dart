class Weather {
  double lat;
  double lon;
  String timezone;
  int timezoneOffset;
  Current current;
  List<Current> hourly;
  List<Daily> daily;

  Weather({
    required this.lat,
    required this.lon,
    required this.timezone,
    required this.timezoneOffset,
    required this.current,
    required this.hourly,
    required this.daily,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      lat: json['lat'].toDouble(),
      lon: json['lon'].toDouble(),
      timezone: json['timezone'],
      timezoneOffset: json['timezone_offset'],
      current: Current.fromJson(json['current']),
      hourly:
          List<Current>.from(json['hourly'].map((x) => Current.fromJson(x))),
      daily: List<Daily>.from(json['daily'].map((x) => Daily.fromJson(x))),
    );
  }
}

class Current {
  int dt;
  int? sunrise;
  int? sunset;
  double temp;
  double feelsLike;
  int pressure;
  int humidity;
  double dewPoint;
  double uvi;
  int clouds;
  int visibility;
  double windSpeed;
  int windDeg;
  double windGust;
  List<WeatherElement> weather;
  double? pop;
  Rain? rain;

  Current({
    required this.dt,
    this.sunrise,
    this.sunset,
    required this.temp,
    required this.feelsLike,
    required this.pressure,
    required this.humidity,
    required this.dewPoint,
    required this.uvi,
    required this.clouds,
    required this.visibility,
    required this.windSpeed,
    required this.windDeg,
    required this.windGust,
    required this.weather,
    this.pop,
    this.rain,
  });

  factory Current.fromJson(Map<String, dynamic> json) {
    return Current(
      dt: json['dt'],
      sunrise: json['sunrise'],
      sunset: json['sunset'],
      temp: json['temp'].toDouble(),
      feelsLike: json['feels_like'].toDouble(),
      pressure: json['pressure'],
      humidity: json['humidity'],
      dewPoint: json['dew_point'].toDouble(),
      uvi: json['uvi'].toDouble(),
      clouds: json['clouds'],
      visibility: json['visibility'],
      windSpeed: json['wind_speed'].toDouble(),
      windDeg: json['wind_deg'],
      windGust: json['wind_gust']?.toDouble() ?? 0.0,
      weather: List<WeatherElement>.from(
          json['weather'].map((x) => WeatherElement.fromJson(x))),
      pop: json['pop']?.toDouble(),
      rain: json['rain'] != null ? Rain.fromJson(json['rain']) : null,
    );
  }
}

class Rain {
  double the1H;

  Rain({
    required this.the1H,
  });

  factory Rain.fromJson(Map<String, dynamic> json) {
    return Rain(
      the1H: json['1h'].toDouble(),
    );
  }
}

class WeatherElement {
  int id;
  Main main;
  String description;
  String icon;

  WeatherElement({
    required this.id,
    required this.main,
    required this.description,
    required this.icon,
  });

  factory WeatherElement.fromJson(Map<String, dynamic> json) {
    return WeatherElement(
      id: json['id'],
      main: MainValues.map[json['main']]!,
      description: json['description']!,
      icon: json['icon']!,
    );
  }
}

enum Description { LIGHT_RAIN, MODERATE_RAIN, OVERCAST_CLOUDS }

final DescriptionValues = EnumValues({
  "light rain": Description.LIGHT_RAIN,
  "moderate rain": Description.MODERATE_RAIN,
  "overcast clouds": Description.OVERCAST_CLOUDS
});

enum Icon { THE_04_D, THE_04_N, THE_10_D, THE_10_N }

final IconValues = EnumValues({
  "04d": Icon.THE_04_D,
  "04n": Icon.THE_04_N,
  "10d": Icon.THE_10_D,
  "10n": Icon.THE_10_N
});

enum Main { CLOUDS, RAIN }

final MainValues = EnumValues({"Clouds": Main.CLOUDS, "Rain": Main.RAIN});

class Daily {
  int dt;
  int sunrise;
  int sunset;
  int moonrise;
  int moonset;
  double moonPhase;
  String summary;
  Temp temp;
  FeelsLike feelsLike;
  int pressure;
  int humidity;
  double dewPoint;
  double windSpeed;
  int windDeg;
  double windGust;
  List<WeatherElement> weather;
  int clouds;
  double pop;
  double rain;
  double uvi;

  Daily({
    required this.dt,
    required this.sunrise,
    required this.sunset,
    required this.moonrise,
    required this.moonset,
    required this.moonPhase,
    required this.summary,
    required this.temp,
    required this.feelsLike,
    required this.pressure,
    required this.humidity,
    required this.dewPoint,
    required this.windSpeed,
    required this.windDeg,
    required this.windGust,
    required this.weather,
    required this.clouds,
    required this.pop,
    required this.rain,
    required this.uvi,
  });

  factory Daily.fromJson(Map<String, dynamic> json) {
    return Daily(
      dt: json['dt'],
      sunrise: json['sunrise'],
      sunset: json['sunset'],
      moonrise: json['moonrise'],
      moonset: json['moonset'],
      moonPhase: json['moon_phase'].toDouble(),
      summary: json['summary'],
      temp: Temp.fromJson(json['temp']),
      feelsLike: FeelsLike.fromJson(json['feels_like']),
      pressure: json['pressure'],
      humidity: json['humidity'],
      dewPoint: json['dew_point'].toDouble(),
      windSpeed: json['wind_speed'].toDouble(),
      windDeg: json['wind_deg'],
      windGust: json['wind_gust']?.toDouble() ?? 0.0,
      weather: List<WeatherElement>.from(
          json['weather'].map((x) => WeatherElement.fromJson(x))),
      clouds: json['clouds'],
      pop: json['pop'].toDouble(),
      rain: json['rain']?.toDouble() ?? 0.0,
      uvi: json['uvi'].toDouble(),
    );
  }
}

class FeelsLike {
  double day;
  double night;
  double eve;
  double morn;

  FeelsLike({
    required this.day,
    required this.night,
    required this.eve,
    required this.morn,
  });

  factory FeelsLike.fromJson(Map<String, dynamic> json) {
    return FeelsLike(
      day: json['day'].toDouble(),
      night: json['night'].toDouble(),
      eve: json['eve'].toDouble(),
      morn: json['morn'].toDouble(),
    );
  }
}

class Temp {
  double day;
  double min;
  double max;
  double night;
  double eve;
  double morn;

  Temp({
    required this.day,
    required this.min,
    required this.max,
    required this.night,
    required this.eve,
    required this.morn,
  });

  factory Temp.fromJson(Map<String, dynamic> json) {
    return Temp(
      day: json['day'].toDouble(),
      min: json['min'].toDouble(),
      max: json['max'].toDouble(),
      night: json['night'].toDouble(),
      eve: json['eve'].toDouble(),
      morn: json['morn'].toDouble(),
    );
  }
}

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
