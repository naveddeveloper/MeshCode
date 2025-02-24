import 'package:flutter/material.dart';
import 'package:meshcode/styles/colors.dart';

final lightTheme = ThemeData(
  brightness: Brightness.light,
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: AppColorsLight.bottomNavigationBackgroundColor,
    elevation: 4.0,
    selectedLabelStyle: TextStyle(
      fontWeight: FontWeight.bold
    ),
    selectedItemColor: AppColorsLight.themedForegroundColor,
    unselectedIconTheme: IconThemeData(
    color: AppColorsLight.inactivebottomNavigationColor,  
    )
  ),

  dialogTheme: DialogThemeData(
    // backgroundColor: AppColorsLight.themedForegroundColor
  )
);

final darkTheme = ThemeData(
  brightness: Brightness.dark,
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: AppColorsDark.bottomNavigationBackgroundColor,
    elevation: 4.0,
    selectedLabelStyle: TextStyle(
      fontWeight: FontWeight.bold
    ),
    selectedItemColor: AppColorsDark.themedForegroundColor,
    unselectedIconTheme: IconThemeData(
    color: AppColorsDark.inactivebottomNavigationColor,  
    )
  ),

  dialogTheme: DialogThemeData(
    // backgroundColor: AppColorsDark.themedForegroundColor
  )
);