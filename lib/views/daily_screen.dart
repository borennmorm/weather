import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../controllers/weather_controller.dart';

class DailyDetailScreen extends StatelessWidget {
  final WeatherController weatherController = Get.find();

  @override
  Widget build(BuildContext context) {
    final selectedDailyWeather = weatherController.selectedDailyWeather;

    return Scaffold(
      appBar: AppBar(
        title: Text('Daily Detail'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Day: ${DateFormat.EEEE().format(DateTime.fromMillisecondsSinceEpoch(selectedDailyWeather.dt * 1000))}'),
            Text('Temperature: ${weatherController.convertKelvinToCelsius(selectedDailyWeather.temp.day)}°C'),
            // Add more details as needed
          ],
        ),
      ),
    );
  }
}
