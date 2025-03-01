import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:weather_app/screens/home.dart';

class SplashScreen extends StatefulWidget {
  final PermissionStatus permissionStatus;

  const SplashScreen({super.key, required this.permissionStatus});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToHome();
  }

  _navigateToHome() async {
    await Future.delayed(Duration(seconds: 3));
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => WeatherHome()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF676BD0),
      body: Center(
        child: Image.asset('assets/splash.png'), // Display the splash image
      ),
    );
  }
}
