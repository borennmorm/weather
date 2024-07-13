import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import '../models/weather_model.dart';
import '../services/weather_service.dart';

class WeatherController extends GetxController {
  var isLoading = true.obs;
  var placeName = ''.obs;
  var weather = Weather(
    lat: 0,
    lon: 0,
    timezone: '',
    timezoneOffset: 0,
    current: Current(
      dt: 0,
      temp: 0,
      feelsLike: 0,
      pressure: 0,
      humidity: 0,
      dewPoint: 0,
      uvi: 0,
      clouds: 0,
      visibility: 0,
      windSpeed: 0,
      windDeg: 0,
      windGust: 0,
      weather: [],
    ),
    hourly: [],
    daily: [],
  ).obs;

  var selectedHourlyIndex = 0.obs;
  var selectedDailyIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
    getCurrentLocation();
  }

  void getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      Get.snackbar('Location Error', 'Location services are disabled.');
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        Get.snackbar('Location Error', 'Location permissions are denied.');
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      Get.snackbar('Location Error', 'Location permissions are permanently denied.');
      return;
    }

    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    fetchWeather(position.latitude, position.longitude);
    getPlaceName(position.latitude, position.longitude);
  }

  void fetchWeather(double lat, double lon) async {
    try {
      isLoading(true);
      var weatherData = await WeatherService.getCurrentWeatherByCoordinates(lat, lon);
      weather(weatherData);
    } catch (e) {
      Get.snackbar('Error', 'Failed to load weather data');
    } finally {
      isLoading(false);
    }
  }

  void getPlaceName(double lat, double lon) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, lon);
      if (placemarks.isNotEmpty) {
        placeName(placemarks[0].locality ?? 'Unknown location');
      } else {
        placeName('Unknown location');
      }
    } catch (e) {
      placeName('Failed to get place name');
    }
  }

  void fetchWeatherByLocationName(String locationName) async {
    try {
      isLoading(true);
      List<Location> locations = await locationFromAddress(locationName);
      if (locations.isNotEmpty) {
        Location first = locations.first;
        fetchWeather(first.latitude, first.longitude);
        placeName(locationName);
      } else {
        throw Exception('Location not found');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to load weather data');
    } finally {
      isLoading(false);
    }
  }

  double convertKelvinToCelsius(double kelvin) {
    return kelvin - 273.15;
  }

  Current get selectedHourlyWeather {
    if (weather.value.hourly.isEmpty) {
      return Current(
        dt: 0,
        temp: 0,
        feelsLike: 0,
        pressure: 0,
        humidity: 0,
        dewPoint: 0,
        uvi: 0,
        clouds: 0,
        visibility: 0,
        windSpeed: 0,
        windDeg: 0,
        windGust: 0,
        weather: [],
      );
    }
    return weather.value.hourly[selectedHourlyIndex.value];
  }

  Daily get selectedDailyWeather {
    if (weather.value.daily.isEmpty) {
      return Daily(
        dt: 0,
        sunrise: 0,
        sunset: 0,
        moonrise: 0,
        moonset: 0,
        moonPhase: 0,
        summary: '',
        temp: Temp(day: 0, min: 0, max: 0, night: 0, eve: 0, morn: 0),
        feelsLike: FeelsLike(day: 0, night: 0, eve: 0, morn: 0),
        pressure: 0,
        humidity: 0,
        dewPoint: 0,
        windSpeed: 0,
        windDeg: 0,
        windGust: 0,
        weather: [],
        clouds: 0,
        pop: 0,
        rain: 0,
        uvi: 0,
      );
    }
    return weather.value.daily[selectedDailyIndex.value];
  }

  void navigateToHourlyDetailScreen() {
    Get.toNamed('/hourly_detail');
  }

  void navigateToDailyDetailScreen() {
    Get.toNamed('/daily_detail');
  }
}
