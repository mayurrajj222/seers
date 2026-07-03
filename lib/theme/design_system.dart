import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const Color background = Color(0xFFF5F5F3);
  static const Color cardBackground = Colors.white;
  static const Color textPrimary = Color(0xFF1E1E1E);
  static const Color textSecondary = Color(0xFF757470);
  static const Color textTertiary = Color(0xFF9E9D99);
  static const Color accentGold = Color(0xFFDCA037);
  static const Color border = Color(0xFFE5E4E0);
  static const Color offlineBanner = Color(0xFFE9E8E4);
  static const Color communityQuoteBg = Color(0xFFF9F9F8);
  static const Color iconColor = Color(0xFF4A4A46);
}

class AppStyles {
  // Headings using Newsreader
  static TextStyle greetingTitle(BuildContext context) {
    return GoogleFonts.newsreader(
      fontSize: 36,
      fontWeight: FontWeight.w400,
      color: AppColors.textPrimary,
      height: 1.1,
    );
  }

  // Script subtitle using Caveat
  static TextStyle greetingSubtitle(BuildContext context) {
    return GoogleFonts.caveat(
      fontSize: 24,
      fontWeight: FontWeight.w400,
      color: AppColors.textSecondary,
    );
  }

  // Section header (all caps, wide tracking) using Work Sans
  static TextStyle sectionHeader(BuildContext context) {
    return GoogleFonts.workSans(
      fontSize: 11,
      fontWeight: FontWeight.w700,
      letterSpacing: 1.5,
      color: AppColors.textSecondary,
    );
  }

  // Card headers using Newsreader
  static TextStyle cardTitle(BuildContext context) {
    return GoogleFonts.newsreader(
      fontSize: 22,
      fontWeight: FontWeight.w400,
      color: AppColors.textPrimary,
      height: 1.2,
    );
  }

  // Smaller Newsreader titles for image overlays
  static TextStyle overlayCardTitle(BuildContext context) {
    return GoogleFonts.newsreader(
      fontSize: 20,
      fontWeight: FontWeight.w400,
      color: Colors.white,
      height: 1.2,
    );
  }

  // Subtitles / Body text using Work Sans
  static TextStyle bodyText(BuildContext context) {
    return GoogleFonts.workSans(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: AppColors.textSecondary,
      height: 1.4,
    );
  }

  static TextStyle bodyTextPrimary(BuildContext context) {
    return GoogleFonts.workSans(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: AppColors.textPrimary,
    );
  }

  static TextStyle metaText(BuildContext context) {
    return GoogleFonts.workSans(
      fontSize: 12,
      fontWeight: FontWeight.w400,
      color: AppColors.textTertiary,
    );
  }

  static TextStyle badgeText(BuildContext context) {
    return GoogleFonts.workSans(
      fontSize: 10,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.5,
      color: AppColors.textPrimary,
    );
  }
}
