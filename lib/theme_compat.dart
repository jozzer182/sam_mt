import 'package:flutter/material.dart';

// Extensiones para compatibilidad con getters de tema obsoletos
extension TextThemeCompat on TextTheme {
  // Equivalencias de Material 2 a Material 3
  TextStyle? get headline6 => titleLarge;
  TextStyle? get headline5 => headlineSmall;
  TextStyle? get headline4 => headlineMedium;
  TextStyle? get headline3 => headlineLarge;
  
  TextStyle? get subtitle1 => titleMedium;
  TextStyle? get subtitle2 => titleSmall;
  
  TextStyle? get bodyText1 => bodyLarge;
  TextStyle? get bodyText2 => bodyMedium;
  
  TextStyle? get button => labelLarge;
  TextStyle? get caption => bodySmall;
  TextStyle? get overline => labelSmall;
}

extension ColorSchemeCompat on ColorScheme {
  // Equivalencias de colores deprecados a los nuevos
  Color get background => surface;
  Color get onBackground => onSurface;
  // surfaceVariant está deprecado pero aún existe, se recomienda usar surfaceContainerHighest
  Color get surfaceVariant => surfaceContainerHighest;
}