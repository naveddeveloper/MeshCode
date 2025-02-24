import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:meshcode/screens/generate_screen.dart';
import 'package:meshcode/styles/colors.dart';
import 'package:sizer/sizer.dart';
import 'package:provider/provider.dart';
import 'package:meshcode/provider/theme_provider.dart';

class DestinationScreen extends StatefulWidget {
  const DestinationScreen({super.key});

  @override
  State<StatefulWidget> createState() => DestinationScreenState();
}

class DestinationScreenState extends State<DestinationScreen> {
  final List<Map<String, dynamic>> destinations = [
    {
      'icon': Icons.language,
      'text': 'Website',
      'color': AppColorsLight.websiteAppIconColor,
      'shadow1': AppColorsLight.websiteShadowGradient1,
    },
    {
      'icon': Icons.text_fields,
      'text': 'Text',
      'color': AppColorsLight.textAppIconColor,
      'shadow1': AppColorsLight.textShadowGradient1,
    },
    {
      'icon': Icons.email,
      'text': 'Email',
      'color': AppColorsLight.emailAppIconColor,
      'shadow1': AppColorsLight.emailShadowGradient1,
    },
    {
      'icon': Icons.sms,
      'text': 'SMS',
      'color': AppColorsLight.smsAppIconColor,
      'shadow1': AppColorsLight.smsShadowGradient1,
    },
    {
      'icon': Icons.wifi,
      'text': 'Wifi',
      'color': AppColorsLight.wifiAppIconColor,
      'shadow1': AppColorsLight.wifiShadowGradient1,
    },
    {
      'icon': Icons.chat_rounded,
      'text': 'WhatsApp',
      'color': AppColorsLight.whatsAppIconColor,
      'shadow1': AppColorsLight.whatsappShadowGradient1,
    },
  ];

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Consumer<ThemeProvider>(
      builder: (context, value, child) {
        return Scaffold(
          backgroundColor: Colors.transparent,
          body: SafeArea(
            child: Stack(
              children: [
                // Background image
                Positioned(
                  top: -13.sh,
                  right: -15.sw,
                  child: Image.asset(
                    "assets/img/qr-decorated.png",
                    scale: 1.8,
                    opacity: const AlwaysStoppedAnimation(.5),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5.w),
                  child: Column(
                    children: [
                      SizedBox(height: 6.sh),

                      Align(
                        alignment: Alignment.centerLeft,
                        child: RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: "Mesh",
                                style: TextStyle(
                                  fontSize: 0.25.dp,
                                  color: isDark ? Colors.white : Colors.black,
                                ),
                              ),
                              TextSpan(
                                text: "Code",
                                style: TextStyle(
                                  fontSize: 0.25.dp,
                                  color:
                                      isDark
                                          ? AppColorsDark.themedForegroundColor
                                          : AppColorsLight
                                              .themedForegroundColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      SizedBox(height: 2.h),

                      Align(
                        alignment: Alignment.centerLeft,
                        child: Ink(
                          decoration: ShapeDecoration(
                            color:
                                isDark
                                    ? AppColorsDark.themedForegroundColor
                                        .withAlpha(100)
                                    : AppColorsLight.themedForegroundColor
                                        .withAlpha(100),
                            shape: const CircleBorder(),
                          ),
                          child: IconButton(
                            icon: Icon(
                              isDark ? Icons.dark_mode : Icons.light_mode,
                              size: 0.3.dp,
                            ),
                            color: Colors.white,
                            onPressed: value.toggleTheme,
                          ),
                        ),
                      ),

                      SizedBox(height: 2.h),

                      Align(
                        alignment: Alignment.centerLeft,
                        child: RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: 'Choose ',
                                style: TextStyle(
                                  fontSize: 0.3.dp,
                                  fontWeight: FontWeight.bold,
                                  color:
                                      isDark
                                          ? AppColorsDark.themedForegroundColor
                                          : AppColorsLight
                                              .themedForegroundColor,
                                ),
                              ),
                              TextSpan(
                                text: 'your Destination!',
                                style: TextStyle(
                                  fontSize: 0.3.dp,
                                  fontWeight: FontWeight.bold,
                                  color: isDark ? Colors.white : Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 4.h),

                      // Main List
                      Expanded(
                        child: ListView.builder(
                          itemCount: destinations.length,
                          itemBuilder: (context, index) {
                            final item = destinations[index];

                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (context) => GenerateScreen(
                                          category: item['text'].toLowerCase(),
                                        ),
                                  ),
                                );
                              },
                              child: ClipRRect(
                                // Match the same rounded corners
                                borderRadius: BorderRadius.circular(5.w),
                                child: BackdropFilter(
                                  // This blurs everything behind the container
                                  filter: ImageFilter.blur(
                                    sigmaX: 50,
                                    sigmaY: 50,
                                  ),
                                  child: Container(
                                    margin: EdgeInsets.only(bottom: 1.5.h),
                                    padding: EdgeInsets.all(1.5.h),
                                    // Semi-transparent color + radial gradient
                                    decoration: BoxDecoration(
                                      color:
                                          isDark
                                              ? Colors.black.withAlpha(80)
                                              : Colors.white.withAlpha(80),
                                      borderRadius: BorderRadius.circular(5.w),
                                      border: Border.all(
                                        width: 1,
                                        color:
                                            isDark
                                                ? AppColorsDark.borderColor
                                                : AppColorsLight.borderColor,
                                      ),
                                      gradient: RadialGradient(
                                        center: Alignment.centerLeft,
                                        radius: 1.0,
                                        colors: [
                                          item['shadow1']!,
                                          isDark ? Colors.black : Colors.white,
                                        ],
                                        stops: const [0.2, 0.7],
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        // Left Row: Icon + Text
                                        Row(
                                          children: [
                                            Container(
                                              padding: EdgeInsets.all(1.2.h),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(3.w),
                                                border: Border.all(
                                                  width: 0.6,
                                                  color:
                                                      isDark
                                                          ? AppColorsDark
                                                              .borderColor
                                                          : AppColorsLight
                                                              .borderColor,
                                                ),
                                                // Optional color behind icon
                                                color: item['color']
                                                    .withOpacity(0.15),
                                              ),
                                              child: Icon(
                                                item['icon'],
                                                color: item['color'],
                                              ),
                                            ),
                                            const SizedBox(width: 12),
                                            Text(
                                              item['text'],
                                              style: TextStyle(
                                                fontSize: 0.25.dp,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                        // Right Arrow
                                        Icon(
                                          Icons.arrow_forward_ios,
                                          size: 0.25.dp,
                                          color:
                                              isDark
                                                  ? AppColorsDark
                                                      .themedForegroundColor
                                                  : AppColorsLight
                                                      .themedForegroundColor,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
