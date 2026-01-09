import 'package:flutter/material.dart';

class AppColors {
  // Brand Colors - Deep Slate & Electric Accents (Same for both themes)
  static const Color primary = Color(0xFF6366F1); // Indigo
  static const Color secondary = Color(0xFF06B6D4); // Cyan
  static const Color accent = Color(0xFFF43F5E); // Rose
  
  // Status Colors (Same for both themes)
  static const Color success = Color(0xFF10B981);
  static const Color error = Color(0xFFEF4444);

  // Dark Theme Colors
  static const Color darkScaffold = Color(0xFF0F172A); // Deep Navy
  static const Color darkSurface = Color(0xFF1E293B);  // Lighter Navy
  static const Color darkCard = Color(0xFF334155);     // Slate
  static const Color darkGlassBorder = Color(0x33FFFFFF);
  static const Color darkGlassSurface = Color(0x1AFFFFFF);
  static const Color darkTextMain = Color(0xFFF8FAFC);
  static const Color darkTextDim = Color(0xFF94A3B8);

  // Light Theme Colors
  static const Color lightScaffold = Color(0xFFFAFAFA); // Off White
  static const Color lightSurface = Color(0xFFFFFFFF);  // Pure White
  static const Color lightCard = Color(0xFFF5F5F5);     // Light Gray
  static const Color lightGlassBorder = Color(0x1A000000);
  static const Color lightGlassSurface = Color(0x0D000000);
  static const Color lightTextMain = Color(0xFF1E293B); // Dark Slate
  static const Color lightTextDim = Color(0xFF64748B);  // Medium Gray

  // Legacy support - keep literal consts for use inside const widgets
  static const Color scaffold = Color(0xFF0F172A);
  static const Color surface = Color(0xFF1E293B);
  static const Color card = Color(0xFF334155);
  static const Color cardSurface = Color(0xFF334155);
  static const Color glassBorder = Color(0x33FFFFFF);
  static const Color glassSurface = Color(0x1AFFFFFF);
  static const Color textMain = Color(0xFFF8FAFC);
  static const Color textDim = Color(0xFF94A3B8);

  // Theme-aware getters
  static Color scaffoldFor(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return brightness == Brightness.dark ? darkScaffold : lightScaffold;
  }

  static Color surfaceFor(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return brightness == Brightness.dark ? darkSurface : lightSurface;
  }

  static Color cardFor(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return brightness == Brightness.dark ? darkCard : lightCard;
  }

  static Color textMainFor(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return brightness == Brightness.dark ? darkTextMain : lightTextMain;
  }

  static Color textDimFor(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return brightness == Brightness.dark ? darkTextDim : lightTextDim;
  }

  static Color glassBorderFor(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return brightness == Brightness.dark ? darkGlassBorder : lightGlassBorder;
  }

  static Color glassSurfaceFor(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return brightness == Brightness.dark ? darkGlassSurface : lightGlassSurface;
  }

  // Gradients - Dark Theme
  static const LinearGradient meshGradient = LinearGradient(
    colors: [Color(0xFF6366F1), Color(0xFFA855F7), Color(0xFFEC4899)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient darkSurfaceGradient = LinearGradient(
    colors: [Color(0xFF1E293B), Color(0xFF0F172A)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  // Gradients - Light Theme
  static const LinearGradient lightSurfaceGradient = LinearGradient(
    colors: [Color(0xFFFFFFFF), Color(0xFFF5F5F5)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static LinearGradient surfaceGradientFor(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return brightness == Brightness.dark ? darkSurfaceGradient : lightSurfaceGradient;
  }

  // Legacy gradient (defaults to dark)
  static const LinearGradient surfaceGradient = darkSurfaceGradient;
}
