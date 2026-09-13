import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pulse/core/app_colors.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primaryColor,
        brightness: Brightness.light,
      ),
      scaffoldBackgroundColor: const Color(0xFFF9FAFC),
      cardColor: Colors.white,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        scrolledUnderElevation: 0,
        centerTitle: false,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark, // Android: dark icons
          statusBarBrightness: Brightness.light, // iOS: dark icons
          systemNavigationBarColor: Color(0xFFF9FAFC),
          systemNavigationBarDividerColor: Colors.transparent,
          systemNavigationBarIconBrightness: Brightness.dark,
          systemNavigationBarContrastEnforced: false,
        ),
      ),
      buttonTheme: ButtonThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      ),
      textTheme: _buildTextTheme(),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        shape: CircleBorder(),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primaryColor,
        brightness: Brightness.dark,
      ),
      scaffoldBackgroundColor: const Color(0xFF17182C),
      cardColor: const Color(0xFF22243A),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        scrolledUnderElevation: 0,
        centerTitle: false,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light, // Android: light icons
          statusBarBrightness: Brightness.dark, // iOS: light icons
          systemNavigationBarColor: Color(0xFF17182C),
          systemNavigationBarDividerColor: Colors.transparent,
          systemNavigationBarIconBrightness: Brightness.light,
          systemNavigationBarContrastEnforced: false,
        ),
      ),
      buttonTheme: ButtonThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      ),
      textTheme: _buildTextTheme(color: Colors.white),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        shape: CircleBorder(),
      ),
    );
  }

  static TextTheme _buildTextTheme({Color? color}) {
    TextStyle style(
      double size, {
      FontWeight weight = FontWeight.w400,
      double? letterSpacing,
    }) {
      return GoogleFonts.lato(
        fontSize: size,
        fontWeight: weight,
        letterSpacing: letterSpacing,
        color: color,
      );
    }

    return TextTheme(
      labelSmall: style(12, weight: FontWeight.w500),
      labelMedium: style(14, weight: FontWeight.w500),
      labelLarge: style(16, weight: FontWeight.w600),
      bodySmall: style(13, weight: FontWeight.w400),
      bodyMedium: style(14, weight: FontWeight.w400),
      bodyLarge: style(16, weight: FontWeight.w400),
      titleSmall: style(16, weight: FontWeight.w600),
      titleMedium: style(18, weight: FontWeight.w600),
      titleLarge: style(22, weight: FontWeight.w600),
      headlineSmall: style(24, weight: FontWeight.w700),
      headlineMedium: style(28, weight: FontWeight.w700),
      headlineLarge: style(32, weight: FontWeight.w700),
      displaySmall: style(34, weight: FontWeight.w700),
      displayMedium: style(40, weight: FontWeight.w700),
      displayLarge: style(44, weight: FontWeight.w700),
    );
  }
}
