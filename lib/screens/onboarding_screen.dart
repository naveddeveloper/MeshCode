import 'package:flutter/material.dart';
import 'package:meshcode/main.dart';
import 'package:meshcode/styles/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _OnboardingScreen();
}

class _OnboardingScreen extends State<OnboardingScreen> {
  
   Future<void> _completeOnboarding(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool("seenOnboarding", true);
    Navigator.push(context, MaterialPageRoute(builder: (context) => MyHomePage()));
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            // Background image
            Positioned(
              bottom: 80,
              right: -100,
              child: Image.asset(
                "assets/img/men-qr-3d.png",
                scale: 2.0,
                opacity: const AlwaysStoppedAnimation(.5),
              ),
            ),
            Positioned(
              left: -20,
              top: 0,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    colors: [
                      AppColorsLight.backgroundRadialGradient1,
                      AppColorsLight.backgroundRadialGradient2,
                    ],
                  ),
                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    const SizedBox(height: 50),
                    // App Name
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: RichText(
                          text: const TextSpan(
                            children: [
                              TextSpan(
                                text: "Create your own QR Code",
                                style: TextStyle(
                                  fontSize: 36,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: RichText(
                          text: const TextSpan(
                            children: [
                              TextSpan(
                                text:
                                    "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin laoreet dignissim tortor, quis placerat tortor rutrum id. Maecenas cursus scelerisque ipsum, nec varius ipsum",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppColorsLight.textInactive,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 60),
                  ],
                ),

                GestureDetector(
                  onTap: (){
                    _completeOnboarding(context);
                  },
                  child: Container(
                    
                    margin: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                    padding: const EdgeInsets.symmetric(
                      vertical: 24,
                      horizontal: 24,
                    ),
                    decoration: BoxDecoration(
                      color:
                          AppColorsLight
                              .themedForegroundColor, // Background color
                      borderRadius: BorderRadius.circular(40), // Rounded corners
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Left Side: Progress Indicator
                        Row(
                          children: [
                            Container(
                              width: 30,
                              height: 8,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            const SizedBox(width: 5),
                            _buildDot(),
                            _buildDot(),
                          ],
                        ),
                  
                        // Right Side: Text and Arrow
                        Row(
                          children: [
                            Text(
                              "Explore more",
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Icon(
                              Icons.arrow_right_alt,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDot() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: Container(
        width: 6,
        height: 6,
        decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle),
      ),
    );
  }
}
