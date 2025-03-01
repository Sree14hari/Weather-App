import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:weather_app/screens/home.dart'; // Assuming you have a HomeScreen

class SplashScreen extends StatelessWidget {
  final PermissionStatus? permissionStatus;

  const SplashScreen({super.key, required this.permissionStatus});

  @override
  Widget build(BuildContext context) {
    // Check the permission status and navigate accordingly
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (permissionStatus != null && permissionStatus!.isGranted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => WeatherHome()),
        );
      } else {
        // Handle the case where permission is denied
        // Show a message or navigate to a different screen
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Location permission is required to use this app.'),
          ),
        );
      }
    });

    return Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
