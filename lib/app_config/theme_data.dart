import 'package:flutter/material.dart';
import '../generic_blocs/settings_bloc.dart';

const Color cexColor = Color.fromARGB(200, 253, 247, 227);
const Color cexColorLight = Color.fromRGBO(24, 35, 49, 0.6);

// Seed colors for dark theme
Color primaryDark = Color(0xFF2A3647);
Color secondaryDark = Color(0xFF39A1EE);

// Seed colors for light theme
Color primaryLight = const Color.fromRGBO(255, 255, 255, 1);
Color secondaryLight = Color(0xFF3CC9BF);

ColorScheme _defaultColorScheme(Brightness brightness) {
  return brightness == Brightness.dark ? _colorSchemeDark : _colorSchemeLight;
}

ColorScheme get _colorSchemeDark => const ColorScheme(
      primary: Color.fromRGBO(42, 54, 71, 1),
      primaryContainer: Color.fromRGBO(28, 36, 48, 1),
      secondary: Color.fromRGBO(57, 161, 238, 1),
      secondaryContainer: Color.fromRGBO(57, 161, 238, 1),
      surface: Color.fromRGBO(42, 54, 71, 1),
      background: Color.fromRGBO(30, 42, 58, 1),
      error: Color.fromRGBO(202, 78, 61, 1),
      onPrimary: Color.fromRGBO(255, 255, 255, 1),
      onSecondary: Color.fromRGBO(255, 255, 255, 1),
      onSurface: Color.fromRGBO(255, 255, 255, 1),
      onBackground: Color.fromRGBO(255, 255, 255, 1),
      onError: Color.fromRGBO(255, 255, 255, 1),
      brightness: Brightness.dark,
    );

// Color scheme light adapted from current dev
ColorScheme get _colorSchemeLight => const ColorScheme(
      primary: Color.fromRGBO(255, 255, 255, 1),
      primaryContainer: Color.fromRGBO(183, 187, 191, 1),
      secondary: Color.fromRGBO(60, 201, 191, 1),
      secondaryContainer: Color.fromRGBO(60, 201, 191, 1),
      surface: Color.fromRGBO(255, 255, 255, 1),
      background: Color.fromRGBO(245, 245, 245, 1),
      error: Color.fromRGBO(202, 78, 61, 1),
      onPrimary: Color.fromRGBO(69, 96, 120, 1),
      onSecondary: Color.fromRGBO(255, 255, 255, 1),
      onSurface: Color.fromRGBO(69, 96, 120, 1),
      onBackground: Color.fromRGBO(69, 96, 120, 1),
      onError: Color.fromRGBO(255, 255, 255, 1),
      brightness: Brightness.light,
    );

ColorScheme _getColorScheme({
  Color? color,
  required Brightness brightness,
}) {
  ColorScheme colorScheme = color == null
      ? ColorScheme.fromSwatch(
          primarySwatch: Colors.blue,
          brightness: brightness,
        )
      : ColorScheme.
//
          fromSeed(
          seedColor: color,
          brightness: brightness,
          // primary: brightness == Brightness.dark ? primaryDark : primaryLight,
        );
  //   fromSwatch(
  //   primarySwatch: Colors.cyan,
  //   brightness: brightness,
  // );

  return colorScheme;
}

ThemeData getThemeDark({Color? seed}) {
  final colorScheme = _getColorScheme(
    color: seed,
    brightness: Brightness.dark,
  );

  return ThemeData.dark(useMaterial3: true).copyWith(
    // scaffoldBackgroundColor: colorScheme.background,
    colorScheme: colorScheme,
  );
}

ThemeData getThemeLight({Color? seed}) {
  final colorScheme = _getColorScheme(
    color: seed,
    brightness: Brightness.light,
  );
  return ThemeData.light(useMaterial3: true).copyWith(
    colorScheme: colorScheme,
  );
}

ButtonStyle elevatedButtonSmallButtonStyle({EdgeInsets? padding}) =>
    ElevatedButton.styleFrom(
      elevation: 0,
      padding: padding,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0),
      ),
    );

InputDecorationTheme defaultUnderlineInputTheme(ColorScheme colorScheme) {
  return InputDecorationTheme(
    enabledBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: colorScheme.secondary.withOpacity(0.3)),
    ),
    focusedBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: colorScheme.secondary),
    ),
    errorBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: colorScheme.error),
    ),
  );
}

const lightColorScheme = ColorScheme(
  brightness: Brightness.light,
  primary: Color(0xFF1760A5),
  onPrimary: Color(0xFFFFFFFF),
  primaryContainer: Color(0xFFD3E3FF),
  onPrimaryContainer: Color(0xFF001C38),
  secondary: Color(0xFF006A64),
  onSecondary: Color(0xFFFFFFFF),
  secondaryContainer: Color(0xFF71F7EC),
  onSecondaryContainer: Color(0xFF00201E),
  tertiary: Color(0xFF0958C9),
  onTertiary: Color(0xFFFFFFFF),
  tertiaryContainer: Color(0xFFD9E2FF),
  onTertiaryContainer: Color(0xFF001945),
  error: Color(0xFFBA1A1A),
  errorContainer: Color(0xFFFFDAD6),
  onError: Color(0xFFFFFFFF),
  onErrorContainer: Color(0xFF410002),
  background: Color(0xFFFDFCFF),
  onBackground: Color(0xFF1A1C1E),
  surface: Color(0xFFFDFCFF),
  onSurface: Color(0xFF1A1C1E),
  surfaceVariant: Color(0xFFDFE2EB),
  onSurfaceVariant: Color(0xFF43474E),
  outline: Color(0xFF73777F),
  onInverseSurface: Color(0xFFF1F0F4),
  inverseSurface: Color(0xFF2F3033),
  inversePrimary: Color(0xFFA3C9FF),
  shadow: Color(0xFF000000),
  surfaceTint: Color(0xFF1760A5),
  outlineVariant: Color(0xFFC3C6CF),
  scrim: Color(0xFF000000),
);

const darkColorScheme = ColorScheme(
  brightness: Brightness.dark,
  primary: Color(0xFFA3C9FF),
  onPrimary: Color(0xFF00315C),
  primaryContainer: Color(0xFF004882),
  onPrimaryContainer: Color(0xFFD3E3FF),
  secondary: Color(0xFF50DBD0),
  onSecondary: Color(0xFF003734),
  secondaryContainer: Color(0xFF00504B),
  onSecondaryContainer: Color(0xFF71F7EC),
  tertiary: Color(0xFFB0C6FF),
  onTertiary: Color(0xFF002D6F),
  tertiaryContainer: Color(0xFF00419C),
  onTertiaryContainer: Color(0xFFD9E2FF),
  error: Color(0xFFFFB4AB),
  errorContainer: Color(0xFF93000A),
  onError: Color(0xFF690005),
  onErrorContainer: Color(0xFFFFDAD6),
  background: Color(0xFF1A1C1E),
  onBackground: Color(0xFFE3E2E6),
  surface: Color(0xFF1A1C1E),
  onSurface: Color(0xFFE3E2E6),
  surfaceVariant: Color(0xFF43474E),
  onSurfaceVariant: Color(0xFFC3C6CF),
  outline: Color(0xFF8D9199),
  onInverseSurface: Color(0xFF1A1C1E),
  inverseSurface: Color(0xFFE3E2E6),
  inversePrimary: Color(0xFF1760A5),
  shadow: Color(0xFF000000),
  surfaceTint: Color(0xFFA3C9FF),
  outlineVariant: Color(0xFF43474E),
  scrim: Color(0xFF000000),
);
