import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:meshcode/styles/colors.dart';
import 'package:meshcode/widgets/custom_toast.dart';
import 'package:sizer/sizer.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:saver_gallery/saver_gallery.dart';

// ignore: must_be_immutable
class QrScannerDialog extends StatefulWidget {
  String url;
  Uint8List? imageData;

  QrScannerDialog({super.key, required this.url, required this.imageData});

  @override
  State<QrScannerDialog> createState() => _QrScannerDialogState();
}

class _QrScannerDialogState extends State<QrScannerDialog> {
  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      child: Container(
        width: 100.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.w),
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
        child: Padding(
          padding: EdgeInsets.all(4.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              widget.imageData != null
                  ? Image.memory(widget.imageData!)
                  : Image.asset(
                    "assets/img/qr-decorated.png",
                    width: 150,
                    height: 150,
                    fit: BoxFit.cover,
                  ), // Provide a valid asset path

              SizedBox(height: 2.h),

              // Title Text
              Text(
                widget.url,
                style: TextStyle(
                  fontSize: 0.28.dp,
                  fontWeight: FontWeight.bold,
                  color:
                      isDark
                          ? AppColorsDark.themedForegroundColor
                          : AppColorsLight.themedForegroundColor,
                ),
              ),

              SizedBox(height: 1.h),

              // Subtitle Text
              Text(
                "This is your unique QR Code for another person to scan",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color:
                      isDark
                          ? AppColorsDark.textInactive
                          : AppColorsLight.textInactive,
                ),
              ),

              SizedBox(height: 2.h),

              // Action Buttons (Share, Open, Save)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildActionButton(
                    icon: Icons.share,
                    label: "Share",
                    onTap: () {
                      if (widget.imageData != null) {
                        final xFile = XFile.fromData(
                          widget.imageData!,
                          name: 'qr_code.png',
                          mimeType: 'image/png',
                        );
                        Share.shareXFiles([
                          xFile,
                        ], text: 'Check out this QR code!');
                        showCustomToast(context, "Sharing...");
                      }
                    },
                    isDark: isDark,
                  ),
                  _buildActionButton(
                    icon: Icons.link,
                    label: "Open",
                    onTap: () async {
                      if (await canLaunchUrl(Uri.parse(widget.url))) {
                        await launchUrl(Uri.parse(widget.url));
                        showCustomToast(context, "Opening...");
                      }
                    },
                    isDark: isDark,
                  ),
                  _buildActionButton(
                    icon: Icons.save,
                    label: "Save",
                    onTap: () async {
                      await SaverGallery.saveImage(
                        widget.imageData!,
                        fileName:
                            '${DateTime.now().microsecondsSinceEpoch}.png',
                        skipIfExists: true,
                      );
                      showCustomToast(context, "QR Saved");
                    },
                    isDark: isDark,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required bool isDark,
  }) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color:
                  isDark
                      ? AppColorsDark.themedForegroundColor.withAlpha(100)
                      : AppColorsLight.themedForegroundColor.withAlpha(100),
            ),
            child: Icon(
              icon,
              color:
                  isDark
                      ? AppColorsDark.themedForegroundColor
                      : AppColorsLight.themedForegroundColor,
              size: 0.3.dp,
            ),
          ),
        ),
        SizedBox(height: 1.h),
        Text(
          label,
          style: TextStyle(
            fontSize: 0.25.dp,
            fontWeight: FontWeight.w500,
            color: isDark ? Colors.white : Colors.black,
          ),
        ),
      ],
    );
  }
}
