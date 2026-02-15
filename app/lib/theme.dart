import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // ── Color Palette ──────────────────────────────────────────────
  static const Color deepNavy = Color(0xFF0A0E27);
  static const Color darkSurface = Color(0xFF111633);
  static const Color cardDark = Color(0xFF161B40);
  static const Color cardDarkAlt = Color(0xFF1A2048);
  static const Color accentCyan = Color(0xFF00E5FF);
  static const Color accentGreen = Color(0xFF00E676);
  static const Color accentAmber = Color(0xFFFFAB00);
  static const Color accentRed = Color(0xFFFF1744);
  static const Color accentPurple = Color(0xFF7C4DFF);
  static const Color textPrimary = Color(0xFFF0F0F5);
  static const Color textSecondary = Color(0xFF8B8FA8);
  static const Color textMuted = Color(0xFF5A5E78);
  static const Color dividerColor = Color(0xFF252A52);

  // ── Risk Colors ────────────────────────────────────────────────
  static Color riskColor(double score) {
    if (score <= 3) return accentGreen;
    if (score <= 8) return accentAmber;
    if (score <= 15) return const Color(0xFFFF6D00);
    return accentRed;
  }

  static String riskLabel(double score) {
    if (score <= 3) return 'LOW';
    if (score <= 8) return 'MEDIUM';
    if (score <= 15) return 'HIGH';
    return 'CRITICAL';
  }

  static IconData riskIcon(double score) {
    if (score <= 3) return Icons.verified_user_rounded;
    if (score <= 8) return Icons.info_rounded;
    if (score <= 15) return Icons.warning_rounded;
    return Icons.gpp_bad_rounded;
  }

  // ── Theme Data ─────────────────────────────────────────────────
  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: deepNavy,
      colorScheme: const ColorScheme.dark(
        primary: accentCyan,
        secondary: accentPurple,
        surface: darkSurface,
        error: accentRed,
        onPrimary: deepNavy,
        onSecondary: Colors.white,
        onSurface: textPrimary,
      ),
      textTheme: GoogleFonts.spaceGroteskTextTheme(
        const TextTheme(
          displayLarge: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w700,
            color: textPrimary,
            letterSpacing: -0.5,
          ),
          displayMedium: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w700,
            color: textPrimary,
            letterSpacing: -0.3,
          ),
          headlineMedium: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: textPrimary,
          ),
          titleLarge: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: textPrimary,
          ),
          titleMedium: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: textPrimary,
          ),
          bodyLarge: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w400,
            color: textSecondary,
          ),
          bodyMedium: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: textSecondary,
          ),
          bodySmall: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: textMuted,
          ),
          labelLarge: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: accentCyan,
            letterSpacing: 1.2,
          ),
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: deepNavy,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: GoogleFonts.spaceGrotesk(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: textPrimary,
        ),
        iconTheme: const IconThemeData(color: textPrimary),
      ),
      cardTheme: CardTheme(
        color: cardDark,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: dividerColor, width: 0.5),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: darkSurface,
        indicatorColor: accentCyan.withValues(alpha: 0.15),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return GoogleFonts.spaceGrotesk(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: accentCyan,
            );
          }
          return GoogleFonts.spaceGrotesk(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: textMuted,
          );
        }),
      ),
      dividerTheme: const DividerThemeData(
        color: dividerColor,
        thickness: 0.5,
      ),
    );
  }
}
