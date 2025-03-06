import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:weather_app/screens/weatherhome.dart';

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
    _checkPermissionsAndNavigate();
  }

  _checkPermissionsAndNavigate() async {
    print('Checking permissions...');
    if (await _requestPermissions()) {
      print('Permissions granted, navigating to home...');
      _navigateToHome();
    } else {
      // Handle permission denied scenario
      print('Required permissions denied');
    }
  }

  Future<bool> _requestPermissions() async {
    Map<Permission, PermissionStatus> statuses =
        await [Permission.location, Permission.locationWhenInUse].request();

    bool allGranted = statuses.values.every((status) => status.isGranted);
    print('Permissions status: $statuses');
    return allGranted;
  }

  _navigateToHome() async {
    print('Navigating to home screen...');
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
