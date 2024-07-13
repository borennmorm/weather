import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/weather_controller.dart';

class SearchScreen extends StatelessWidget {
  final WeatherController weatherController = Get.find();

  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Weather by Location'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: searchController,
              decoration: InputDecoration(
                labelText: 'Enter Location Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                String locationName = searchController.text.trim();
                if (locationName.isNotEmpty) {
                  weatherController.fetchWeatherByLocationName(locationName);
                  Get.back(); // Close the search screen after initiating search
                } else {
                  Get.snackbar('Error', 'Please enter a location name');
                }
              },
              child: const Text('Search'),
            ),
          ],
        ),
      ),
    );
  }
}
