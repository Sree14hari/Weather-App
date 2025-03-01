import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:weather_app/services/weather_model.dart';

class WeatherServices {
  Future<WeatherData?> fetchWeather() async {
    try {
      print('Checking if location services are enabled...');
      // Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw Exception('Location services are disabled.');
      }

      print('Checking for location permissions...');
      // Check for location permissions
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        print('Requesting location permissions...');
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw Exception('Location permissions are denied.');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw Exception('Location permissions are permanently denied.');
      }

      print('Getting the current position...');
      // Get the current position
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      print('Fetching weather data...');
      final response = await http.get(
        Uri.parse(
          "https://api.openweathermap.org/data/2.5/weather?lat=${position.latitude}&lon=${position.longitude}&appid=d112bb7fbb737d73b1fdf2574fe391eb",
        ),
      );

      if (response.statusCode == 200) {
        var json = jsonDecode(response.body);
        print('Weather data fetched successfully.');
        return WeatherData.fromJson(json);
      } else {
        throw Exception('Failed to load Weather data');
      }
    } catch (e) {
      print('Error: ${e.toString()}');
      return null;
    }
  }
}
