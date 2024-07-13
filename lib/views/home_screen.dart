import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../controllers/weather_controller.dart';
import 'daily_screen.dart';
import 'hourly_screen.dart';
import 'search_screen.dart';
import 'widgets/drawer.dart';

class WeatherView extends StatelessWidget {
  final WeatherController weatherController = Get.put(WeatherController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Obx(() => Text(
              weatherController.placeName.value,
              style: const TextStyle(
                fontSize: 18,
                color: Colors.white,
              ),
            )),
        titleSpacing: 0,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(
              Icons.location_pin,
              color: Colors.white,
              size: 20,
            ),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.search,
              color: Colors.white,
            ),
            onPressed: () {
              Get.to(() => SearchScreen());
            },
          )
        ],
        backgroundColor: const Color.fromARGB(255, 4, 129, 163),
      ),
      backgroundColor: const Color.fromARGB(255, 4, 129, 163),
      drawer: const MyDrawer(),
      body: Obx(() {
        if (weatherController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        } else if (weatherController.weather.value.timezone.isEmpty) {
          return const Center(child: Text('Failed to load weather data'));
        } else {
          double tempCelsius = weatherController.convertKelvinToCelsius(
              weatherController.weather.value.current.temp);

          // Convert weather description to camel case
          String description =
              weatherController.weather.value.current.weather[0].description;
          String formattedDescription = description.split(' ').map((word) {
            if (word.isEmpty) return '';
            return word.substring(0, 1).toUpperCase() +
                word.substring(1).toLowerCase();
          }).join(' ');

          // Day formatted as EEEE, MMM dd, yyyy
          String dayName = DateFormat('EEEE, MMM dd, yyyy').format(
              DateTime.fromMillisecondsSinceEpoch(
                  weatherController.weather.value.current.dt * 1000));

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: weatherController.weather.value.current.weather
                      .map((weatherElement) {
                    return Row(
                      children: [
                        Image.network(
                          'http://openweathermap.org/img/wn/${weatherElement.icon}@2x.png',
                          width: 100,
                          height: 100,
                        ),
                        Text(
                          '${tempCelsius.toStringAsFixed(0)} °C',
                          style: const TextStyle(
                            fontSize: 35,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ),
                Text(
                  '$formattedDescription',
                  style: const TextStyle(
                    fontSize: 22,
                    color: Colors.white,
                  ),
                ),

                const SizedBox(height: 5),

                // Day to EEEE, MMM, DD, YYYY
                Text(
                  '$dayName',
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),

                const SizedBox(height: 10),

                // Row to display max and min temperatures
                Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.arrow_drop_up,
                          color: Colors.white,
                        ),
                        Text(
                          '${weatherController.convertKelvinToCelsius(weatherController.weather.value.daily[0].temp.max).toStringAsFixed(2)} °C',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Row(
                      children: [
                        const Icon(
                          Icons.arrow_drop_down,
                          color: Colors.white,
                        ),
                        Text(
                          '${weatherController.convertKelvinToCelsius(weatherController.weather.value.daily[0].temp.min).toStringAsFixed(2)} °C',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // Design here
                ClipPath(
                  clipper: ReverseWaveClipper(),
                  child: Container(
                    width: double.infinity,
                    color: Colors.grey[100],
                    padding: const EdgeInsets.only(
                      top: 20,
                      left: 10,
                      right: 10,
                      bottom: 10,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Hourly',
                          style: TextStyle(fontSize: 17),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: List.generate(
                              weatherController.weather.value.hourly.length,
                              (index) {
                                final hourlyWeather = weatherController
                                    .weather.value.hourly[index];
                                double hourlyTempCelsius = weatherController
                                    .convertKelvinToCelsius(hourlyWeather.temp);
                                final selectedHourlyWeather =
                                    weatherController.selectedHourlyWeather;
                                return GestureDetector(
                                  onTap: () {
                                    weatherController
                                        .selectedHourlyIndex(index);
                                    Get.to(() => HourlyDetailScreen(
                                          selectedHour: '',
                                        ));
                                  },
                                  child: Card(
                                    color: Colors.white,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        children: [
                                          Text(
                                            '${DateFormat.jm().format(DateTime.fromMillisecondsSinceEpoch(hourlyWeather.dt * 1000))}',
                                            style:
                                                const TextStyle(fontSize: 14),
                                          ),
                                          Image.network(
                                            'http://openweathermap.org/img/wn/${hourlyWeather.weather[0].icon}@2x.png',
                                            width: 50,
                                            height: 50,
                                          ),
                                          Text(
                                            '${hourlyTempCelsius.toStringAsFixed(0)}°C',
                                            style:
                                                const TextStyle(fontSize: 16),
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
                        const Text(
                          'Daily',
                          style: TextStyle(fontSize: 17),
                        ),
                        const SizedBox(
                          height: 5,
                        ),

                        // Daily weather section
                        Column(
                          children: List.generate(
                            weatherController.weather.value.daily.length,
                            (index) {
                              final dailyWeather =
                                  weatherController.weather.value.daily[index];
                              double dayTempCelsius =
                                  weatherController.convertKelvinToCelsius(
                                      dailyWeather.temp.day);
                              String dayName = DateFormat.EEEE().format(
                                  DateTime.fromMillisecondsSinceEpoch(
                                      dailyWeather.dt * 1000));
                              return GestureDetector(
                                onTap: () {
                                  weatherController.selectedDailyIndex(index);
                                  Get.to(() => DailyDetailScreen(
                                        selectedDaily: '',
                                      ));
                                },
                                child: Card(
                                  color: Colors.white,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Image.network(
                                              'http://openweathermap.org/img/wn/${dailyWeather.weather[0].icon}@2x.png',
                                              width: 50,
                                              height: 50,
                                            ),
                                            const SizedBox(width: 10),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  dayName,
                                                  style: const TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Text(
                                                  dailyWeather
                                                      .weather[0].description,
                                                  style: const TextStyle(
                                                      fontSize: 14),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        Text(
                                          '${dayTempCelsius.toStringAsFixed(2)} °C',
                                          style: const TextStyle(fontSize: 14),
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

// Custom Clipper class for reversed wave shape
class ReverseWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.moveTo(0, size.height); // start from bottom-left corner
    path.lineTo(0, 0); // move to top-left corner
    path.quadraticBezierTo(
        size.width / 4, 0, size.width / 2, 25); // wave curve control points
    path.quadraticBezierTo(
        3 / 4 * size.width, 50, size.width, 25); // wave curve control points
    path.lineTo(size.width, size.height); // line to bottom-right corner
    path.close(); // close the path for a clean look
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
