import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:weather_app/screens/splash_screen.dart';
import 'package:weather_app/screens/weatherhome.dart';
import 'package:fluid_bottom_nav_bar/fluid_bottom_nav_bar.dart';

void main() async {
  // Ensure that plugin services are initialized so that SystemChrome can be used
  WidgetsFlutterBinding.ensureInitialized();

  // Request location permission
  PermissionStatus permissionStatus = await Permission.location.request();

  // Set the status bar and navigation bar colors
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, // Make status bar transparent
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Color(0xFF676BD0),
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

  // Set preferred orientations (optional)
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(MyApp(permissionStatus: permissionStatus));
}

class MyApp extends StatelessWidget {
  final PermissionStatus permissionStatus;

  const MyApp({super.key, required this.permissionStatus});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Color(0xFF676BD0),
        colorScheme: ColorScheme.fromSeed(
          seedColor: Color(0xFF676BD0),
          brightness: Brightness.light,
        ),
        fontFamily: 'Roboto',
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        primaryColor: Color(0xFF676BD0),
        colorScheme: ColorScheme.fromSeed(
          seedColor: Color(0xFF676BD0),
          brightness: Brightness.dark,
        ),
        fontFamily: 'Roboto',
        useMaterial3: true,
      ),
      themeMode: ThemeMode.system, // Respects system theme
      home: MainScreen(permissionStatus: permissionStatus),
    );
  }
}

// Add this new class for the main screen with navigation
class MainScreen extends StatefulWidget {
  final PermissionStatus permissionStatus;
  const MainScreen({super.key, required this.permissionStatus});
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  bool _showSplash = true;
  final List<Widget> _screens = [];
  @override
  void initState() {
    super.initState();
    // Add main screens (not including splash)
    _screens.add(Scaffold(body: Center(child: Text('Home'))));
    _screens.add(const WeatherHome()); // Use WeatherHome for the weather tab
    _screens.add(Scaffold(body: Center(child: Text('Forecast'))));
    _screens.add(Scaffold(body: Center(child: Text('Settings'))));
    // Show splash screen for a few seconds, then transition to main content
    Future.delayed(Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _showSplash = false;
        });
      }
    });
  }

  // In your _MainScreenState class, update the build method
  @override
  Widget build(BuildContext context) {
    if (_showSplash) {
      return SplashScreen(permissionStatus: widget.permissionStatus);
    }

    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: FluidNavBar(
        icons: [
          FluidNavBarIcon(
            icon: Icons.home,
            backgroundColor: Color(0xFF676BD0),
            extras: {"label": "Home"},
          ),
          FluidNavBarIcon(
            icon: Icons.cloud,
            backgroundColor: Color(0xFF676BD0),
            extras: {"label": "Weather"},
          ),
          // FluidNavBarIcon(
          //   icon: Icons.camera_alt,
          //   backgroundColor: Color(0xFF676BD0),
          //   extras: {"label": "Camera"},
          // ),
          FluidNavBarIcon(
            icon: Icons.calendar_today,
            backgroundColor: Color(0xFF676BD0),
            extras: {"label": "Forecast"},
          ),
          FluidNavBarIcon(
            icon: Icons.settings,
            backgroundColor: Color(0xFF676BD0),
            extras: {"label": "Settings"},
          ),
        ],
        onChange: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        style: FluidNavBarStyle(
          barBackgroundColor: Color(0xFF676BD0),
          iconSelectedForegroundColor: Colors.white,
          iconUnselectedForegroundColor: Colors.white.withOpacity(0.6),
          iconBackgroundColor: Colors.transparent, // Remove the glassy effect
        ),
        scaleFactor: 1.5,
        defaultIndex: _currentIndex,
        itemBuilder:
            (icon, item) =>
                Semantics(label: icon.extras!["label"], child: item),
      ),
    );
  }
}
