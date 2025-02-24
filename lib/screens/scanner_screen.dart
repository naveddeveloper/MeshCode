import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:meshcode/provider/theme_provider.dart';
import 'package:meshcode/styles/colors.dart';
import 'package:meshcode/widgets/overlay_scanner_border.dart';
import 'package:meshcode/widgets/qr_scanner_dialog.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class ScannerScreen extends StatefulWidget {
  const ScannerScreen({super.key});

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {
  final MobileScannerController _controller = MobileScannerController(
    detectionSpeed:
        DetectionSpeed.noDuplicates, // Change speed for better performance
    facing: CameraFacing.back, // Ensure it's using the back camera
    torchEnabled: false,
    returnImage: true,
    useNewCameraSelector: true,
  );

  @override
  void initState() {
    super.initState();
    _controller.start();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 5.w),
              child: Column(
                children: [
                  SizedBox(height: 5.h),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Row(
                      children: [
                        RichText(
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

                        Align(
                          alignment: Alignment.centerLeft,
                          child: Ink(
                            height: 0.35.dp,
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
                                size: 0.25.dp,
                              ),
                              color: Colors.white,
                              onPressed:
                                  Provider.of<ThemeProvider>(
                                    context,
                                    listen: false,
                                  ).toggleTheme,
                            ),
                          ),
                        ),
                      ],
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
                              fontSize: 0.35.dp,
                              fontWeight: FontWeight.bold,
                              color:
                                  isDark
                                      ? AppColorsDark.themedForegroundColor
                                      : AppColorsLight.themedForegroundColor,
                            ),
                          ),
                          TextSpan(
                            text: 'your Destination!',
                            style: TextStyle(
                              fontSize: 0.35.dp,
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.white : Colors.black,
                            ),
                          ),
                        ],
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
                            text: "Position the QR Code within the frame",
                            style: TextStyle(
                              fontSize: 0.2.dp,
                              color:
                                  isDark
                                      ? AppColorsDark.textInactive
                                      : AppColorsLight.textInactive,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 5.h),

                  SizedBox(
                    height: 40.h,
                    width: 100.w,
                    child: Stack(
                      children: [
                        MobileScanner(
                          controller: _controller,
                          onDetect: (capture) {
                            final List<Barcode> barcodes = capture.barcodes;
                            final Uint8List? image = capture.image;
                            if (barcodes.isNotEmpty &&
                                barcodes.first.rawValue != null) {
                              showDialog(
                                context: context,
                                builder:
                                    (context) => QrScannerDialog(
                                      url: barcodes.first.rawValue!,
                                      imageData: image,
                                    ),
                              );
                            }
                          },
                        ),
                        // Overlay the custom border
                        Positioned.fill(
                          child: CustomPaint(
                            painter: QrScannerCornerOverlay(
                              borderColor:
                                  isDark
                                      ? AppColorsDark.themedForegroundColor
                                      : AppColorsLight.themedForegroundColor,
                              borderWidth: 5.0,
                              // Define your scanning area size (you can customize this)
                              cutOutSize: Size(90.w, 40.h),
                              borderLength: 50,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
