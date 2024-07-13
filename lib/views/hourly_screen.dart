import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/weather_controller.dart';

class HourlyDetailScreen extends StatelessWidget {
  final WeatherController weatherController = Get.find();

  @override
  Widget build(BuildContext context) {
    final selectedHourlyWeather = weatherController.selectedHourlyWeather;

    return Scaffold(
      appBar: AppBar(
        title: Text('Hourly Detail'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Time: ${DateTime.fromMillisecondsSinceEpoch(selectedHourlyWeather.dt * 1000)}'),
            Text('Temperature: ${weatherController.convertKelvinToCelsius(selectedHourlyWeather.temp)}°C'),
            // Add more details as needed
          ],
        ),
      ),
    );
  }
}
