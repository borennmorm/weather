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

  @override
  void onInit() {
    super.onInit();
    getCurrentLocation();
  }

  void getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
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

    // When we reach here, permissions are granted and we can get the position of the device.
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
}
