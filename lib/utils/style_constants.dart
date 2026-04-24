import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const Color background = Color(0xFF0F0F12);
  static const Color surface = Color(0xFF1C1C23);
  static const Color primary = Color(0xFF7C4DFF);
  static const Color accent = Color(0xFF00E5FF);
  
  static const Color stockHigh = Color(0xFF00E676);
  static const Color stockMid = Color(0xFFFFD600);
  static const Color stockLow = Color(0xFFFF5252);

  static const LinearGradient premiumGradient = LinearGradient(
    colors: [primary, Color(0xFFB388FF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient glassGradient = LinearGradient(
    colors: [
      Color(0x1AFFFFFF),
      Color(0x08FFFFFF),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}

class AppStyles {
  static final TextStyle heading = GoogleFonts.outfit(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: Colors.white,
    letterSpacing: -0.5,
  );

  static final TextStyle subHeading = GoogleFonts.outfit(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: Colors.white70,
  );

  static final TextStyle body = GoogleFonts.inter(
    fontSize: 14,
    color: Colors.white60,
  );

  static BoxDecoration glassDecoration = BoxDecoration(
    color: AppColors.surface.withOpacity(0.4),
    borderRadius: BorderRadius.circular(24),
    border: Border.all(color: Colors.white12, width: 1),
  );
}
