import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:weather_app/Services/services.dart';
import 'package:weather_app/services/weather_model.dart';

class WeatherHome extends StatefulWidget {
  const WeatherHome({super.key});

  @override
  State<WeatherHome> createState() => _WeatherHomeState();
}

class _WeatherHomeState extends State<WeatherHome> {
  late WeatherData weatherInfo;
  bool isLoading = false;

  myWeather() {
    isLoading = false;
    WeatherServices().fetchWeather().then((value) {
      setState(() {
        weatherInfo = value!;
        isLoading = true;
      });
    });
  }

  @override
  void initState() {
    weatherInfo = WeatherData(
      name: '',
      temperature: Temperature(current: 0.0),
      humidity: 0,
      wind: Wind(speed: 0.0),
      maxTemperature: 0,
      minTemperature: 0,
      pressure: 0,
      seaLevel: 0,
      weather: [],
    );
    myWeather();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String formattedDate = DateFormat(
      'EEEE d, MMMM yyyy',
    ).format(DateTime.now());
    String formattedTime = DateFormat('hh:mm a').format(DateTime.now());

    // Get screen height minus app bar and nav bar
    final double availableHeight =
        MediaQuery.of(context).size.height -
        AppBar().preferredSize.height -
        MediaQuery.of(context).padding.top -
        MediaQuery.of(context).padding.bottom -
        80; // Approximate height for bottom nav bar

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Center(
            child:
                isLoading
                    ? WeatherDetail(
                      weather: weatherInfo,
                      formattedDate: formattedDate,
                      formattedTime: formattedTime,
                      availableHeight: availableHeight,
                    )
                    : const CircularProgressIndicator(color: Colors.white),
          ),
        ),
      ),
    );
  }
}

class WeatherDetail extends StatelessWidget {
  final WeatherData weather;
  final String formattedDate;
  final String formattedTime;
  final double availableHeight;

  const WeatherDetail({
    super.key,
    required this.weather,
    required this.formattedDate,
    required this.formattedTime,
    required this.availableHeight,
  });
  String getWeatherImage(String condition) {
    switch (condition.toLowerCase()) {
      case 'clear':
        return 'assets/sunny.png';
      case 'clouds':
        return 'assets/cloud.png';
      case 'rain':
        return 'assets/rainy.png';
      case 'snow':
        return 'assets/snowy.png';
      case 'thunderstorm':
        return 'assets/thunderstorm.png';
      default:
        return 'assets/sunny.png';
    }
  }

  @override
  Widget build(BuildContext context) {
    String weatherCondition =
        weather.weather.isNotEmpty ? weather.weather[0].main : 'clouds';
    String weatherImage = getWeatherImage(weatherCondition);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(15),
          // decoration: BoxDecoration(
          //   gradient: LinearGradient(
          //     begin: Alignment.topLeft,
          //     end: Alignment.bottomRight,
          //     colors: [
          //       Colors.white.withOpacity(0.2),
          //       Colors.white.withOpacity(0.1),
          //     ],
          //   ),
          //   borderRadius: BorderRadius.circular(20),
          //   border: Border.all(color: Colors.white.withOpacity(0.2)),
          // ),
          child: Column(
            children: [
              Text(
                weather.name,
                style: const TextStyle(
                  fontSize: 22,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "${weather.temperature.current.toStringAsFixed(1)}°C",
                style: const TextStyle(
                  fontSize: 36,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (weather.weather.isNotEmpty)
                Text(
                  weather.weather[0].main,
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    formattedDate,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    formattedTime,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: availableHeight * 0.25,
                child: Image.asset(weatherImage, fit: BoxFit.contain),
              ),
              const SizedBox(height: 10),
              _buildWeatherInfoGrid(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildWeatherInfoGrid() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withOpacity(0.2),
            Colors.white.withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildInfoItem(
                  Icons.wind_power,
                  "Wind",
                  "${weather.wind.speed}km/h",
                ),
                _buildInfoItem(
                  Icons.sunny,
                  "Max",
                  "${weather.maxTemperature.toStringAsFixed(1)}°C",
                ),
                _buildInfoItem(
                  Icons.thermostat,
                  "Min",
                  "${weather.minTemperature.toStringAsFixed(1)}°C",
                ),
              ],
            ),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildInfoItem(
                  Icons.water_drop,
                  "Humidity",
                  "${weather.humidity}%",
                ),
                _buildInfoItem(
                  Icons.compress,
                  "Pressure",
                  "${weather.pressure}hPa",
                ),
                _buildInfoItem(
                  Icons.waves,
                  "Sea Level",
                  "${weather.seaLevel}m",
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String title, String value) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 22),
        const SizedBox(height: 4),
        Text(
          title,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(value, style: const TextStyle(fontSize: 12, color: Colors.white)),
      ],
    );
  }
}
