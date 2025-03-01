import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:weather_app/screens/splash_screen.dart';
import 'package:weather_app/screens/home.dart'; // Assuming you have a HomeScreen

void main() async {
  // Ensure that plugin services are initialized so that SystemChrome can be used
  WidgetsFlutterBinding.ensureInitialized();

  // Request location permission
  PermissionStatus permissionStatus = await Permission.location.request();

  // Set the status bar and navigation bar colors
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: Color(0xFF676BD0), // Set status bar color
      statusBarIconBrightness:
          Brightness.light, // Set status bar icon brightness
      systemNavigationBarColor: Colors.green, // Set navigation bar color
      systemNavigationBarIconBrightness:
          Brightness.light, // Set navigation bar icon brightness
    ),
  );

  runApp(MyApp(permissionStatus: permissionStatus));
}

class MyApp extends StatelessWidget {
  final PermissionStatus permissionStatus;

  const MyApp({super.key, required this.permissionStatus});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(permissionStatus: permissionStatus),
    );
  }
}
