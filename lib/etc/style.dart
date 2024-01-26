import 'dart:ui';
import 'package:flutter/material.dart';

@immutable
class Style {
  final ColorScheme colorScheme;

  const Style({required this.colorScheme});

  static const light = Style(
    colorScheme: ColorScheme.light(
      primary: Color(0xFF9439C4),
      primaryContainer: Color(0xDDCA92E6),
      secondary: Color(0xFF2DC999),
      secondaryContainer: Color(0xFF86DDC3),
      tertiary: Color(0xFFE3A68F),
      error: Color(0xFFFF6969),
      outline: Color(0xFF838383),
      //
      surface: Color(0xFF0F0F0F),
      onSurface: Color(0xFFFFFFFF),
      surfaceVariant: Color(0xFF313131),
      onSurfaceVariant: Color(0xFFC1C1C1),
      background: Color(0xFF1F1F1F),
      onBackground: Color(0xFFFCFCFC),
    ),
  );
  static const dark = Style(
    colorScheme: ColorScheme.dark(
      primary: Color(0xFF9439C4),
      primaryContainer: Color(0xDDCA92E6),
      secondary: Color(0xFF2DC999),
      secondaryContainer: Color(0xFF86DDC3),
      tertiary: Color(0xFFE3A68F),
      error: Color(0xFFFF6969),
      outline: Color(0xFF838383),
      //
      surface: Color(0xFF0F0F0F),
      onSurface: Color(0xFFFFFFFF),
      surfaceVariant: Color(0xFF313131),
      onSurfaceVariant: Color(0xFFC1C1C1),
      background: Color(0xFF1F1F1F),
      onBackground: Color(0xFFFCFCFC),
    ),
  );

  final TextStyle graphMainTitle = const TextStyle(
    color: Color(0xFFD6D6D6),
    fontSize: 14,
    fontWeight: FontWeight.bold,
  );
  final TextStyle graphMediumTitle = const TextStyle(
    color: Color(0xFFD6D6D6),
    fontSize: 17,
    fontWeight: FontWeight.bold,
  );
  final TextStyle graphTitles = const TextStyle(
    color: Color(0xFFFAFAFA),
    fontSize: 11,
    fontWeight: FontWeight.bold,
    fontFeatures: [FontFeature.tabularFigures()],
  );
  final TextStyle visitorCountLarge = const TextStyle(
    color: Color(0xFFFAFAFA),
    fontSize: 35,
  );
  final TextStyle visitorCountSmall = const TextStyle(
    color: Color(0xFFFAFAFA),
    fontSize: 25,
  );
  final TextStyle visitorCountText = const TextStyle(
    color: Color(0xFFFAFAFA),
    fontSize: 16,
  );
  final TextStyle pieChartTitleText = const TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.bold,
    color: Colors.white,
    shadows: [Shadow(color: Colors.black, blurRadius: 2)],
  );

  static Style of(BuildContext context) {
    final mq = MediaQuery.of(context);
    return mq.platformBrightness == Brightness.dark ? dark : light;
  }
}

ThemeData getTheme(BuildContext context, Style style) {
  final theme = Theme.of(context);
  return ThemeData(
    useMaterial3: true,
    colorScheme: style.colorScheme,
    scaffoldBackgroundColor: style.colorScheme.background,
    cardColor: style.colorScheme.background,
    dialogBackgroundColor: style.colorScheme.surfaceVariant,
    splashColor: Colors.transparent,
    highlightColor: Colors.transparent,
    fontFamily: 'Hiragino Kaku Gothic ProN',
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: style.colorScheme.primary,
        foregroundColor: Colors.white,
        textStyle: TextStyle(
          fontSize: theme.textTheme.labelLarge!.fontSize,
          fontWeight: FontWeight.w700,
        ),
        shape: const StadiumBorder(),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        minimumSize: const Size(60, 40),
        elevation: 0,
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: style.colorScheme.onSurface,
        side: BorderSide(color: style.colorScheme.outline),
        textStyle: const TextStyle(fontWeight: FontWeight.w700),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        minimumSize: const Size(60, 40),
        shape: const StadiumBorder(),
        elevation: 0,
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: style.colorScheme.primaryContainer,
        shape: const StadiumBorder(),
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      ),
    ),
    timePickerTheme: TimePickerThemeData(
      dayPeriodTextColor: style.colorScheme.onSurface,
      // dayPeriodColor: style.colorScheme.secondary
    ),
    chipTheme: ChipThemeData(
      side: const BorderSide(color: Colors.transparent),
      padding: const EdgeInsets.all(10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
      backgroundColor: style.colorScheme.tertiary,
    ),
  );
}
