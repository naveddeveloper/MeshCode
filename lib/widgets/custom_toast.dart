import 'package:flutter/material.dart';
import 'package:meshcode/styles/colors.dart';
import 'package:sizer/sizer.dart';

void showCustomToast(BuildContext context, String message) {
  final overlay = Overlay.of(context);
  final overlayEntry = OverlayEntry(
    builder: (context) => Positioned(
      bottom: 5.h,
      left: MediaQuery.of(context).size.width * 0.2,
      width: MediaQuery.of(context).size.width * 0.6,
      child: Material(
        borderRadius: BorderRadius.circular(3.5.w),
        color: Theme.of(context).brightness == Brightness.dark ? AppColorsDark.themedForegroundColor : AppColorsLight.themedForegroundColor.withAlpha(100),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 4.w),
          decoration: BoxDecoration(
            color: Theme.of(context).hintColor.withValues(alpha: .6),
            borderRadius: BorderRadius.circular(3.5.w),
          ),
          child: Text(
            message,
            style: TextStyle(color: Colors.white, fontSize: 0.25.dp),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    ),
  );

  overlay.insert(overlayEntry);

  Future.delayed(Duration(seconds: 2), () {
    overlayEntry.remove();
  });
}