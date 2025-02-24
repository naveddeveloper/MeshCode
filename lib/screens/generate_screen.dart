import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:meshcode/widgets/custom_toast.dart';
import 'package:meshcode/widgets/qr_generator.dialog.dart';
import 'package:sizer/sizer.dart';
import 'package:meshcode/styles/colors.dart';
import 'package:qr_flutter/qr_flutter.dart';

class GenerateScreen extends StatefulWidget {
  final String category;

  const GenerateScreen({super.key, required this.category});

  @override
  State<GenerateScreen> createState() => _GenerateScreenState();
}

class _GenerateScreenState extends State<GenerateScreen> {
  final TextEditingController _inputController = TextEditingController();
  final TextEditingController _extraController = TextEditingController(); 
  String qrData = "";


  // Generate QR Code data based on category
  void generateQrCode() {
    String inputText = _inputController.text.trim();
    String extraText = _extraController.text.trim();

    if (inputText.isEmpty) {
      showCustomToast(context, "Please fill that first!");
      return;
    };

    switch (widget.category.toLowerCase()) {
      case "website":
        qrData =
            inputText.startsWith("http") ? inputText : "https://$inputText";
        break;
      case "text":
        qrData = inputText;
        break;
      case "email":
        qrData = "mailto:$inputText?subject=${Uri.encodeComponent(extraText)}";
        break;
      case "sms":
        qrData = "sms:$inputText?body=${Uri.encodeComponent(extraText)}";
        break;
      case "wifi":
        qrData = "WIFI:S:$inputText;T:WPA;P:$extraText;;"; // SSID and Password
        break;
      case "whatsapp":
        qrData =
            "https://wa.me/$inputText?text=${Uri.encodeComponent(extraText)}";
        break;
      case "phone":
        qrData = "tel:$inputText";
        break;
      default:
        qrData = inputText;
    }

    showDialog(
      context: context,
      builder: (context) => QRGeneratorDialog(qrData: qrData),
    );

    setState(() {});
  }

  // Get input fields based on category
  Widget getInputFields(isDark) {
    widget.category.toLowerCase();
    if (widget.category == "website" ||
        widget.category == "text" ||
        widget.category == "whatsapp" ||
        widget.category == "phone") {
      switch (widget.category) {
        case "website":
          return buildInputField("Enter your website url...", isDark);
        case "text":
          return buildInputField("Enter your text...", isDark);
        case "whatsapp":
          return buildInputField("Enter your number, including the country code...", isDark);
        case "phone":
          return buildInputField("Enter your phone number, including the country code...", isDark);
        default:
      }
    } else if (widget.category == "email") {
      return Column(
        children: [
          buildInputField("Enter Email Address", isDark),
          SizedBox(height: 10),
          buildInputField("Enter Subject", isDark, extra: true),
        ],
      );
    } else if (widget.category == "sms") {
      return Column(
        children: [
          buildInputField("Enter your number, including the country code", isDark),
          SizedBox(height: 10),
          buildInputField("Enter SMS Message", isDark, extra: true),
        ],
      );
    } else if (widget.category == "wifi") {
      return Column(
        children: [
          buildInputField("Enter WiFi Name (SSID)", isDark),
          SizedBox(height: 10),
          buildInputField("Enter WiFi Password", isDark, extra: true),
        ],
      );
    }
    return SizedBox();
  }

  // Custom input field
  Widget buildInputField(String hintText, bool isDark, {bool extra = false}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(5.w),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 180, sigmaY: 180),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 5.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5.w),
            border: Border.all(
              color:
                  isDark
                      ? AppColorsDark.borderColor
                      : AppColorsLight.borderColor,
              width: 1,
            ),
          ),
          child: TextField(
            controller: extra ? _extraController : _inputController,
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: TextStyle(
                color: isDark ? Colors.white : Colors.black,
                fontSize: 0.22.dp,
              ),
              border: InputBorder.none,
            ),
            style: TextStyle(color: isDark ? Colors.white : Colors.black),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: 100.h,
      decoration: BoxDecoration(
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
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: SingleChildScrollView(
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
                      SizedBox(height: 2.h),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: ClipRRect(
                          // borderRadius: BorderRadius.circular(5.w),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 160, sigmaY: 160),
                            child: Container(
                              alignment: Alignment.center,
                              width: 10.w,
                              height: 5.h,
                              decoration: BoxDecoration(
                                color:
                                    isDark
                                        ? AppColorsDark.themedForegroundColor
                                            .withAlpha(100)
                                        : AppColorsLight.themedForegroundColor
                                            .withAlpha(100),
                                borderRadius: BorderRadius.circular(4.w),
                                border: Border.all(
                                  color:
                                      isDark
                                          ? AppColorsDark.borderColor
                                          : AppColorsLight.borderColor,
                                ),
                              ),
                              child: IconButton(
                                icon: Icon(
                                  Icons.arrow_back_ios,
                                  color: isDark ? Colors.white : Colors.black,
                                  size: 0.25.dp,
                                ),
                                onPressed: () => Navigator.of(context).pop(),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 2.h),
                      // App Name
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

                      SizedBox(height: 6.h),

                      // Heading Text
                      Align(
                        alignment: Alignment.centerLeft,
                        child: RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: 'Make a simple QR code with ',
                                style: TextStyle(
                                  fontSize: 0.3.dp,
                                  fontWeight: FontWeight.bold,
                                  color: isDark ? Colors.white : Colors.black,
                                ),
                              ),
                              TextSpan(
                                text: widget.category,
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
                            ],
                          ),
                        ),
                      ),

                      SizedBox(height: 2.h),

                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Fill in this input and press to generate your QR code",
                          style: TextStyle(
                            fontSize: 0.2.dp,
                            color:
                                isDark
                                    ? AppColorsDark.textInactive
                                    : AppColorsLight.textInactive,
                          ),
                        ),
                      ),

                      SizedBox(height: 2.h),

                      // Dynamic Input Fields
                      getInputFields(isDark),

                      SizedBox(height: 2.h),

                      // Submit Button
                      ClipRRect(
                        borderRadius: BorderRadius.circular(5.w),
                        child: GestureDetector(
                          onTap: generateQrCode,
                          child: Container(
                            margin: EdgeInsets.symmetric(horizontal: 20.w),
                            padding: EdgeInsets.symmetric(
                              vertical: 1.5.h,
                              horizontal: 2.w,
                            ),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color:
                                  isDark
                                      ? AppColorsDark.themedForegroundColor
                                            .withAlpha(100)
                                      : AppColorsLight.themedForegroundColor.withAlpha(100),
                              borderRadius: BorderRadius.circular(30),
                              border: Border.all(
                                color:
                                    isDark
                                        ? AppColorsDark.borderColor
                                        : AppColorsLight.borderColor,
                                width: 1,
                              ),
                            ),
                            child: Text(
                              "Generate QR Code",
                              style: TextStyle(
                                fontSize: 0.25.dp,
                                fontWeight: FontWeight.bold,
                                color: isDark ? Colors.white.withAlpha(200) : Colors.black.withAlpha(200),
                              ),
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: 2.h),

                      // Generated QR Code
                      qrData.isNotEmpty
                          ? QrImageView(
                            data: qrData,
                            version: QrVersions.auto,
                            size: 200.0,
                            backgroundColor:
                                isDark ? Colors.black : Colors.white,
                            eyeStyle: QrEyeStyle(
                              eyeShape: QrEyeShape.square,
                              color:
                                  isDark
                                      ? AppColorsDark.themedForegroundColor
                                      : AppColorsLight.themedForegroundColor,
                            ),
                            errorStateBuilder:
                                (context, error) =>
                                    Center(child: Text("$error")),
                          )
                          : SizedBox(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
