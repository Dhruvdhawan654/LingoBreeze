import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// LingoBreeze App Theme
/// Warm, organic, human-centered design — like a well-loved language notebook.
class AppTheme {
  AppTheme._();

  // ─── Color Palette ──────────────────────────────────────────────────────

  static const Color warmCream = Color(0xFFFAF7F2); // Warm Ivory Background
  static const Color warmWhite = Color(0xFFFFFDF9); // Card / Surface White
  static const Color warmBeige = Color(0xFFF3EDE4); // Soft Beige Surface
  static const Color accentTerracotta = Color(0xFFC17753); // Warm Terracotta
  static const Color accentCoral = Color(0xFFD4896A); // Soft Coral
  static const Color accentSage = Color(0xFF7A9E7E); // Sage Green
  static const Color accentMoss = Color(0xFF5E8564); // Deeper Moss Green
  static const Color textPrimary = Color(0xFF2D2A26); // Warm Charcoal
  static const Color textSecondary = Color(0xFF5C564E); // Warm Brownish Gray
  static const Color textMuted = Color(0xFF9B9388); // Warm Taupe
  static const Color cardBg = Color(0xFFFFFDF9); // Warm White Card
  static const Color cardBorder = Color(0xFFE8E0D6); // Soft Warm Border
  static const Color errorColor = Color(0xFFCF6679); // Soft Warm Rose
  static const Color successColor = Color(0xFF7A9E7E); // Sage Green

  // ─── Gradients ──────────────────────────────────────────────────────────

  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFFFAF7F2), // Warm Ivory
      Color(0xFFF5EFE6), // Soft Parchment
      Color(0xFFF0E9DE), // Warm Sand
    ],
  );

  static const LinearGradient accentGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [accentTerracotta, accentCoral],
  );

  static const LinearGradient sageGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [accentSage, accentMoss],
  );

  static const LinearGradient cardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFFFFDF9), // Warm White
      Color(0xFFFCF8F3), // Slightly warmer
    ],
  );

  // ─── Text Styles ────────────────────────────────────────────────────────

  static TextStyle get headingLarge => GoogleFonts.outfit(
        fontSize: 30,
        fontWeight: FontWeight.w700,
        color: textPrimary,
        letterSpacing: -0.3,
      );

  static TextStyle get headingMedium => GoogleFonts.outfit(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: textPrimary,
        letterSpacing: -0.2,
      );

  static TextStyle get headingSmall => GoogleFonts.outfit(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: textPrimary,
      );

  static TextStyle get bodyLarge => GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: textPrimary,
        height: 1.5,
      );

  static TextStyle get bodyMedium => GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: textSecondary,
        height: 1.5,
      );

  static TextStyle get bodySmall => GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: textMuted,
      );

  static TextStyle get labelMedium => GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: textPrimary,
      );

  static TextStyle get buttonText => GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: Colors.white,
        letterSpacing: 0.2,
      );

  // ─── Decorations ────────────────────────────────────────────────────────

  static BoxDecoration get warmCard => BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: cardBorder,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF8B7355).withValues(alpha: 0.06),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
          BoxShadow(
            color: const Color(0xFF8B7355).withValues(alpha: 0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      );

  // Keep glassCard as an alias so existing references don't break
  static BoxDecoration get glassCard => warmCard;

  static BoxDecoration get glassCardHover => BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: accentTerracotta.withValues(alpha: 0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: accentTerracotta.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      );

  // ─── Input Decoration ───────────────────────────────────────────────────

  static InputDecoration inputDecoration({
    required String label,
    required String hint,
    IconData? icon,
  }) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      prefixIcon: icon != null
          ? Icon(icon, color: accentTerracotta.withValues(alpha: 0.6), size: 22)
          : null,
      labelStyle: bodyMedium.copyWith(color: textMuted),
      hintStyle: bodyMedium.copyWith(color: textMuted.withValues(alpha: 0.5)),
      filled: true,
      fillColor: warmBeige.withValues(alpha: 0.5),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: cardBorder),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: cardBorder),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: accentTerracotta, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: errorColor),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: errorColor, width: 1.5),
      ),
      errorStyle: bodySmall.copyWith(color: errorColor),
    );
  }

  // ─── Material Theme ─────────────────────────────────────────────────────

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: warmCream,
      colorScheme: const ColorScheme.light(
        primary: accentTerracotta,
        secondary: accentSage,
        surface: warmWhite,
        error: errorColor,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: textPrimary,
        onError: Colors.white,
      ),
      textTheme: TextTheme(
        headlineLarge: headingLarge,
        headlineMedium: headingMedium,
        headlineSmall: headingSmall,
        bodyLarge: bodyLarge,
        bodyMedium: bodyMedium,
        bodySmall: bodySmall,
        labelMedium: labelMedium,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: headingMedium,
        iconTheme: const IconThemeData(color: textPrimary),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: accentTerracotta,
        foregroundColor: Colors.white,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: warmWhite,
        contentTextStyle: bodyMedium.copyWith(color: textPrimary),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
