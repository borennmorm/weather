import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../controllers/weather_controller.dart';
import 'daily_screen.dart';
import 'hourly_screen.dart';
import 'search_screen.dart';

class WeatherView extends StatelessWidget {
  final WeatherController weatherController = Get.put(WeatherController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Obx(() => Text(weatherController.placeName.value)),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              Get.to(() => SearchScreen());
            },
          )
        ],
      ),
      body: Obx(() {
        if (weatherController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        } else if (weatherController.weather.value.timezone.isEmpty) {
          return const Center(child: Text('Failed to load weather data'));
        } else {
          double tempCelsius = weatherController.convertKelvinToCelsius(
              weatherController.weather.value.current.temp);
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Location: ${weatherController.placeName.value}',
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: weatherController.weather.value.current.weather
                      .map((weatherElement) {
                    return Column(
                      children: [
                        Image.network(
                          'http://openweathermap.org/img/wn/${weatherElement.icon}@2x.png',
                          width: 50,
                          height: 50,
                        ),
                        Text(
                          weatherElement.description,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20),
                Text(
                  'Temperature: ${tempCelsius.toStringAsFixed(2)}°C',
                  style: const TextStyle(fontSize: 18),
                ),
                Text(
                  'Humidity: ${weatherController.weather.value.current.humidity}%',
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 20),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: List.generate(
                      weatherController.weather.value.hourly.length,
                      (index) {
                        final hourlyWeather =
                            weatherController.weather.value.hourly[index];
                        double hourlyTempCelsius = weatherController
                            .convertKelvinToCelsius(hourlyWeather.temp);
                        return GestureDetector(
                          onTap: () {
                            weatherController.selectedHourlyIndex(index);
                            Get.to(() => HourlyDetailScreen());
                          },
                          child: Card(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  Text(
                                    '${DateFormat.jm().format(DateTime.fromMillisecondsSinceEpoch(hourlyWeather.dt * 1000))}',
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                  Image.network(
                                    'http://openweathermap.org/img/wn/${hourlyWeather.weather[0].icon}@2x.png',
                                    width: 50,
                                    height: 50,
                                  ),
                                  Text(
                                    '${hourlyTempCelsius.toStringAsFixed(2)}°C',
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Column(
                  children: List.generate(
                    weatherController.weather.value.daily.length,
                    (index) {
                      final dailyWeather =
                          weatherController.weather.value.daily[index];
                      double dayTempCelsius = weatherController
                          .convertKelvinToCelsius(dailyWeather.temp.day);
                      String dayName = DateFormat.EEEE().format(
                          DateTime.fromMillisecondsSinceEpoch(
                              dailyWeather.dt * 1000));
                      return GestureDetector(
                        onTap: () {
                          weatherController.selectedDailyIndex(index);
                          Get.to(() => DailyDetailScreen());
                        },
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Image.network(
                                  'http://openweathermap.org/img/wn/${dailyWeather.weather[0].icon}@2x.png',
                                  width: 50,
                                  height: 50,
                                ),
                                const SizedBox(width: 10),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      dayName,
                                      style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      dailyWeather.weather[0].description,
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                    Text(
                                      '${dayTempCelsius.toStringAsFixed(2)}°C',
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        }
      }),
    );
  }
}
