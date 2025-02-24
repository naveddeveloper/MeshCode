import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:meshcode/provider/theme_provider.dart';
import 'package:meshcode/screens/destination_screen.dart';
import 'package:meshcode/screens/onboarding_screen.dart';
import 'package:meshcode/screens/scanner_screen.dart';
import 'package:meshcode/styles/colors.dart';
import 'package:meshcode/styles/theme.dart';
import 'package:meshcode/widgets/custom_toast.dart' show showCustomToast;
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'dart:ui';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();

  // Check if the onboarding screen has been seen
  bool seenOnboarding = prefs.getBool("seenOnboarding") ?? false;

  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: MyApp(seenOnboarding: seenOnboarding),
    ),
  );
}

class MyApp extends StatelessWidget {
  bool seenOnboarding;

  MyApp({super.key, required this.seenOnboarding});

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, screenType) {
        return Consumer<ThemeProvider>(
          builder: (context, themeProvider, child) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: lightTheme,
              darkTheme: darkTheme,
              themeMode: themeProvider.themeMode,
              home: SplashScreen(seenOnboarding: seenOnboarding),
            );
          },
        );
      },
    );
  }
}

class SplashScreen extends StatelessWidget {
  bool seenOnboarding;
  SplashScreen({super.key, required this.seenOnboarding});

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      duration: 3000,
      splash: Center(child: Image.asset("assets/img/meshcodesplashicon.png")),
      nextScreen: seenOnboarding ? const MyHomePage() : OnboardingScreen(),
      splashTransition: SplashTransition.fadeTransition,
      backgroundColor:
          Theme.of(context).brightness == Brightness.dark
              ? const Color.fromARGB(255, 165, 165, 250).withAlpha(100)
              : const Color.fromARGB(255, 142, 142, 251).withAlpha(100),
      splashIconSize: 200,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;
  final List<Widget> widgetOptions = [DestinationScreen(), ScannerScreen()];

  void onItemTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    _requestCameraPermission();
  }

  Future<void> _requestCameraPermission() async {
    var status = await Permission.camera.request();
    if (status.isDenied) {
      showCustomToast(context, "Camera Permission is required for scanning.");
      Permission.camera.request();
      openAppSettings();
    }
  }

  @override
  Widget build(BuildContext context) {
    final Brightness brightness = Theme.of(context).brightness;
    bool isDark = brightness == Brightness.dark;

    return Container(
      width: 100.w,
      decoration: BoxDecoration(
        // Add a background linear gradient
        gradient: LinearGradient(
          colors: [
            isDark
                ? AppColorsDark.backgroundColorGradient1
                : AppColorsLight.backgroundColorGradient1,
            isDark
                ? AppColorsDark.backgroundColorGradient2
                : AppColorsLight.backgroundColorGradient2,
          ],
        ),
      ),
      child: Scaffold(
        backgroundColor:
            Colors.transparent, // make it transparent to pass the colors
        body: widgetOptions[_selectedIndex],
        bottomNavigationBar: ClipRRect(
          borderRadius: BorderRadius.only(topLeft: Radius.circular(8.w), topRight: Radius.circular(8.0)),
          child: BackdropFilter(
            // Blur the bottom Navigation Bar
            filter: ImageFilter.blur(sigmaX: 50, sigmaY: 50),
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 1.5.h, horizontal: 8.w),
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(8.w),
                border: Border.all(
                  color:
                      isDark
                          ? AppColorsDark.borderColor
                          : AppColorsLight.borderColor,
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildNavItem(Icons.qr_code, 0, isDark, "Destination"),
                  _buildNavItem(Icons.scanner, 1, isDark, "Scanner"),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, int index, bool isDark, String label) {
    return GestureDetector(
      onTap: () => onItemTap(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color:
                _selectedIndex == index
                    ? (isDark
                        ? AppColorsDark.themedForegroundColor
                        : AppColorsLight.themedForegroundColor)
                    : (isDark
                        ? AppColorsDark.textInactive
                        : AppColorsLight.textInactive),
          ),
          SizedBox(height: 1.h),
          Text(
            label,
            style: TextStyle(
              fontSize: 0.23.dp,
              fontWeight: FontWeight.w500,
              color:
                  _selectedIndex == index
                      ? (isDark
                          ? AppColorsDark.themedForegroundColor
                          : AppColorsLight.themedForegroundColor)
                      : (isDark
                          ? AppColorsDark.textInactive
                          : AppColorsLight.textInactive),
            ),
          ),
        ],
      ),
    );
  }
}
