import 'dart:typed_data';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:meshcode/styles/colors.dart';
import 'package:meshcode/widgets/custom_toast.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:saver_gallery/saver_gallery.dart';
import 'package:sizer/sizer.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:path_provider/path_provider.dart';

class QRGeneratorDialog extends StatefulWidget {
  final String qrData;

  const QRGeneratorDialog({super.key, required this.qrData});

  @override
  State<QRGeneratorDialog> createState() => _QRGeneratorDialogState();
}

class _QRGeneratorDialogState extends State<QRGeneratorDialog> {
  // Convert QR code to an image file
  Future<File?> generateQrImage() async {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    final qrPainter = QrPainter(
      data: widget.qrData,
      version: QrVersions.auto,
      eyeStyle: QrEyeStyle(
        eyeShape: QrEyeShape.square,
        color: Colors.black
      ),
      emptyColor: Colors.white
    );

    final ui.Picture picture = qrPainter.toPicture(300);
    final ui.Image image = await picture.toImage(
      300,
      300,
    ); // Adjust size as needed
    final ByteData? byteData = await image.toByteData(
      format: ui.ImageByteFormat.png,
    );
    final Uint8List pngBytes = byteData!.buffer.asUint8List();

    // Save image to temporary directory
    final directory = await getTemporaryDirectory();
    final filePath = '${directory.path}/qr_code.png';
    final file = File(filePath);
    await file.writeAsBytes(pngBytes);
    return file;

  }

  // Save QR Code to Gallery
  Future<void> saveQrToGallery() async {
    File? qrFile = await generateQrImage();
    if (qrFile != null) {
      final Uint8List bytes = await qrFile.readAsBytes();
      final result = await SaverGallery.saveImage(
        bytes,
        fileName: '${DateTime.now().microsecondsSinceEpoch}.png',
        skipIfExists: true,
      );
      showCustomToast(context, result.isSuccess ? "Saved to Gallery" : "Failed to Save");
    }
  }

  // Share QR Code Image
  Future<void> shareQrCode() async {
    File? qrFile = await generateQrImage();
    if (qrFile != null) {
      Share.shareXFiles([XFile(qrFile.path)], text: "Scan this QR Code!");
      showCustomToast(context, "Sharing...");
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Dialog(
      // backgroundColor: Colors.white.withAlpha(255),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.w)),
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
              // QR Code Display
              QrImageView(
                data: widget.qrData,
                version: QrVersions.auto,
                size: 200.0,
                backgroundColor: isDark ? Colors.black : Colors.white,
                eyeStyle: QrEyeStyle(
                  eyeShape: QrEyeShape.square,
                  color:
                      isDark
                          ? AppColorsDark.themedForegroundColor
                          : AppColorsLight.themedForegroundColor,
                ),
                errorStateBuilder:
                    (context, error) => Center(child: Text("$error")),
              ),

              SizedBox(height: 2.h),

              // QR Code Data
              Text(
                widget.qrData,
                style: TextStyle(
                  fontSize: 0.25.dp,
                  fontWeight: FontWeight.bold,
                  color:
                      isDark
                          ? AppColorsDark.themedForegroundColor
                          : AppColorsLight.themedForegroundColor,
                ),
              ),

              SizedBox(height: 1.h),

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

              // Buttons: Share, Open, Save
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildActionButton(
                    icon: Icons.share,
                    label: "Share",
                    onTap: shareQrCode,
                    isDark: isDark,
                  ),
                  _buildActionButton(
                    icon: Icons.link,
                    label: "Open",
                    onTap: () async {
                      if (await canLaunchUrl(Uri.parse(widget.qrData))) {
                        await launchUrl(Uri.parse(widget.qrData));
                        showCustomToast(context, "Opening...");
                      }
                    },
                    isDark: isDark,
                  ),
                  _buildActionButton(
                    icon: Icons.save,
                    label: "Save",
                    onTap: saveQrToGallery,
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
