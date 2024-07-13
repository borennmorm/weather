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
        title: const Text(
          'Search Location',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_sharp, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        backgroundColor: const Color(0xFF00566D),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: searchController,
              decoration: const InputDecoration(
                labelText: 'Location Name ',
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
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00566D), // Background color
                foregroundColor: Colors.white, // Text color
                padding: const EdgeInsets.symmetric(
                    horizontal: 24, vertical: 12), // Button padding
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8), // Rounded corners
                ),
              ),
              child: const Text('Search '),
            )
          ],
        ),
      ),
    );
  }
}
