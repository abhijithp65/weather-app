import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  static const List<Color> clearDay   = [Color(0xFF1E90FF), Color(0xFF87CEEB)];
  static const List<Color> clearNight = [Color(0xFF0D1B2A), Color(0xFF1B3A5C)];
  static const List<Color> cloudy     = [Color(0xFF4A5568), Color(0xFF718096)];
  static const List<Color> rainy      = [Color(0xFF2D3748), Color(0xFF4A5568)];
  static const List<Color> stormy     = [Color(0xFF1A202C), Color(0xFF2D3748)];
  static const List<Color> snowy      = [Color(0xFF90CDF4), Color(0xFFBEE3F8)];
  static const List<Color> foggy      = [Color(0xFF718096), Color(0xFFA0AEC0)];

  static const Color white70 = Color(0xB3FFFFFF);
  static const Color white50 = Color(0x80FFFFFF);
  static const Color white20 = Color(0x33FFFFFF);
  static const Color white10 = Color(0x1AFFFFFF);
  static const Color black30 = Color(0x4D000000);
}

class AppTextStyles {
  AppTextStyles._();

  static const TextStyle temperature = TextStyle(
    fontSize: 88,
    fontWeight: FontWeight.w100,
    color: Colors.white,
    height: 1,
    letterSpacing: -4,
  );

  static const TextStyle cityName = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w300,
    color: Colors.white,
    letterSpacing: 0.5,
  );

  static const TextStyle condition = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w300,
    color: AppColors.white70,
    letterSpacing: 0.3,
  );

  static const TextStyle feelsLike = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w300,
    color: AppColors.white70,
  );

  static const TextStyle detailLabel = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: AppColors.white50,
    letterSpacing: 1.2,
  );

  static const TextStyle detailValue = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w400,
    color: Colors.white,
  );

  static const TextStyle forecastDay = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.white70,
  );

  static const TextStyle forecastTemp = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: Colors.white,
  );

  static const TextStyle forecastTempLow = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.white50,
  );

  static const TextStyle searchHint = TextStyle(
    fontSize: 16,
    color: AppColors.white50,
  );
}

class AppTheme {
  AppTheme._();

  static ThemeData get theme => ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1E90FF),
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: Colors.transparent,
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.white10,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          hintStyle: AppTextStyles.searchHint,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        ),
      );
}
