import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // 🎨 Candy Color Palette (India-inspired vibrant)
  static const Color watermelonRed = Color(0xFFFF4757);
  static const Color bananaYellow = Color(0xFFFFD32A);
  static const Color mintGreen = Color(0xFF2ED573);
  static const Color skyBlue = Color(0xFF1E90FF);
  static const Color peachOrange = Color(0xFFFF6B35);
  static const Color lavender = Color(0xFFA29BFE);
  static const Color coral = Color(0xFFFF7675);
  static const Color turquoise = Color(0xFF00CEC9);

  // Background
  static const Color bgLight = Color(0xFFFFF9F0);
  static const Color bgCard = Color(0xFFFFFFFF);
  static const Color bgDark = Color(0xFF2D3436);

  // Gradients
  static const LinearGradient heroGradient = LinearGradient(
    colors: [Color(0xFFFF6B35), Color(0xFFFFD32A)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient blueGradient = LinearGradient(
    colors: [Color(0xFF1E90FF), Color(0xFF00CEC9)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient greenGradient = LinearGradient(
    colors: [Color(0xFF2ED573), Color(0xFF1ABC9C)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient purpleGradient = LinearGradient(
    colors: [Color(0xFFA29BFE), Color(0xFF6C5CE7)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient bgGradient = LinearGradient(
    colors: [Color(0xFFFFF9F0), Color(0xFFFFF0E6)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static ThemeData get theme => ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: watermelonRed,
          primary: watermelonRed,
          secondary: bananaYellow,
          surface: bgLight,
        ),
        textTheme: GoogleFonts.quicksandTextTheme().copyWith(
          displayLarge: GoogleFonts.quicksand(
            fontWeight: FontWeight.w800,
            fontSize: 32,
            color: bgDark,
          ),
          headlineLarge: GoogleFonts.quicksand(
            fontWeight: FontWeight.w700,
            fontSize: 24,
            color: bgDark,
          ),
          headlineMedium: GoogleFonts.quicksand(
            fontWeight: FontWeight.w700,
            fontSize: 20,
            color: bgDark,
          ),
          bodyLarge: GoogleFonts.quicksand(
            fontWeight: FontWeight.w600,
            fontSize: 16,
            color: bgDark,
          ),
          bodyMedium: GoogleFonts.quicksand(
            fontWeight: FontWeight.w500,
            fontSize: 14,
            color: Color(0xFF636E72),
          ),
        ),
        cardTheme: CardThemeData(
          elevation: 8,
          shadowColor: Colors.black.withOpacity(0.12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: watermelonRed,
            foregroundColor: Colors.white,
            elevation: 6,
            shadowColor: watermelonRed.withOpacity(0.4),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
            textStyle: GoogleFonts.quicksand(
              fontWeight: FontWeight.w700,
              fontSize: 16,
            ),
          ),
        ),
        scaffoldBackgroundColor: bgLight,
      );
}
