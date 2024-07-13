import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../controllers/weather_controller.dart';

class DailyDetailScreen extends StatelessWidget {
  final WeatherController weatherController = Get.find();
  final String selectedDaily;

  DailyDetailScreen({super.key, required this.selectedDaily});

  @override
  Widget build(BuildContext context) {
    final selectedDailyWeather = weatherController.selectedDailyWeather;

    // Format weather description
    String formattedDescription =
        selectedDailyWeather.weather[0].description.split(' ').map((word) {
      if (word.isEmpty) return '';
      return word.substring(0, 1).toUpperCase() +
          word.substring(1).toLowerCase();
    }).join(' ');

    // Construct the URL for the weather icon
    String iconUrl =
        'http://openweathermap.org/img/wn/${selectedDailyWeather.weather[0].icon}@2x.png';

    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${DateFormat.EEEE().format(DateTime.fromMillisecondsSinceEpoch(selectedDailyWeather.dt * 1000))}',
          style: const TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_sharp, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        backgroundColor: const Color.fromARGB(255, 4, 129, 163),
      ),
      backgroundColor: const Color.fromARGB(255, 4, 129, 163),
      body: GestureDetector(
        onHorizontalDragEnd: (details) {
          if (details.primaryVelocity! > 0) {
            // User swiped to the right
            Get.back();
          }
        },
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${weatherController.convertKelvinToCelsius(selectedDailyWeather.temp.day).toStringAsFixed(1)} °C',
                          style: const TextStyle(
                            fontSize: 35,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '$formattedDescription',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    Image.network(
                      iconUrl,
                      width: 100,
                      height: 100,
                    ),
                  ],
                ),
              ),
              ClipPath(
                clipper: ReverseWaveClipper(),
                child: Container(
                  width: double.infinity,
                  color: Colors.grey[100],
                  padding: const EdgeInsets.only(
                    top: 50,
                    left: 20,
                    right: 20,
                    bottom: 10,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          WeatherDetailCard(
                            icon: CupertinoIcons.wind,
                            value:
                                '${selectedDailyWeather.windSpeed.toStringAsFixed(1)} km/h',
                            label: 'Wind Speed',
                            iconColor: Colors.green,
                            iconBackgroundColor: Colors.green[100]!,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          WeatherDetailCard(
                            icon: CupertinoIcons.drop_fill,
                            label: 'Humidity',
                            value: '${selectedDailyWeather.humidity} %',
                            iconColor: Colors.blue,
                            iconBackgroundColor: Colors.blue[100]!,
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          WeatherDetailCard(
                            icon: CupertinoIcons.cloud_fill,
                            label: 'Cloud',
                            value: '${selectedDailyWeather.clouds} %',
                            iconColor: Colors.grey[800]!,
                            iconBackgroundColor: Colors.grey[300]!,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          WeatherDetailCard(
                            icon: CupertinoIcons.sun_max_fill,
                            value:
                                '${selectedDailyWeather.uvi.toStringAsFixed(1)}',
                            label: 'UVI',
                            iconColor: Colors.amber[800]!,
                            iconBackgroundColor: Colors.amber[100]!,
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          WeatherDetailCard(
                            icon: Icons.water_drop_outlined,
                            label: 'Dew Point',
                            value: '${selectedDailyWeather.dewPoint} °',
                            iconColor: Colors.green,
                            iconBackgroundColor: Colors.greenAccent[100]!,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          WeatherDetailCard(
                            icon: CupertinoIcons.arrow_down_right_arrow_up_left,
                            value:
                                '${selectedDailyWeather.pressure.toStringAsFixed(0)} hPa',
                            label: 'Pressure',
                            iconColor: Colors.red,
                            iconBackgroundColor: Colors.red[100]!,
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                        "Feel Likes",
                        style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          WeatherDetailCard(
                            icon: CupertinoIcons.sun_min_fill,
                            label: 'Day',
                            value:
                                '${weatherController.convertKelvinToCelsius(selectedDailyWeather.feelsLike.day).toStringAsFixed(1)} °C',
                            iconColor: Colors.orange,
                            iconBackgroundColor: Colors.orange[100]!,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          WeatherDetailCard(
                            icon: CupertinoIcons.moon_fill,
                            label: 'Night',
                            value:
                                '${weatherController.convertKelvinToCelsius(selectedDailyWeather.feelsLike.night).toStringAsFixed(1)} °C',
                            iconColor: Colors.blueAccent,
                            iconBackgroundColor: Colors.lightBlue[100]!,
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          WeatherDetailCard(
                            icon: CupertinoIcons.sun_haze_fill,
                            label: 'Evening',
                            value:
                                '${weatherController.convertKelvinToCelsius(selectedDailyWeather.feelsLike.eve).toStringAsFixed(1)} °C',
                            iconColor: Colors.amber,
                            iconBackgroundColor: Colors.yellowAccent[100]!,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          WeatherDetailCard(
                            icon: CupertinoIcons.sunrise_fill,
                            label: 'Morning',
                            value:
                                '${weatherController.convertKelvinToCelsius(selectedDailyWeather.feelsLike.morn).toStringAsFixed(1)} °C',
                            iconColor: Colors.green,
                            iconBackgroundColor: Colors.greenAccent[100]!,
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.3),
                              spreadRadius: 1,
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Summary",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            Text('${selectedDailyWeather.summary}')
                          ],
                        ),
                      ),
                      const SizedBox(
                          height: 20), // Extra spacing to ensure scroll
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class WeatherDetailCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color iconColor;
  final Color iconBackgroundColor;

  const WeatherDetailCard({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    required this.iconColor,
    required this.iconBackgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: iconBackgroundColor,
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 18,
            ),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

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
