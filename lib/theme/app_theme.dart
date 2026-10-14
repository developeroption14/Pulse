import 'package:flutter/material.dart';

class AppTheme {
  // ═══════════════════════════════════════════════════════════
  // PREMIUM COLOR PALETTE
  // ═══════════════════════════════════════════════════════════

  // Background layers
  static const Color bg = Color(0xFF0A0A0F);
  static const Color surface = Color(0xFF16161F);
  static const Color surfaceAlt = Color(0xFF1F1F2E);
  static const Color surfaceElevated = Color(0xFF2A2A3E);

  // Gradient primary (Purple → Pink)
  static const Color gradStart = Color(0xFF8B5CF6);
  static const Color gradMid = Color(0xFFB855F6);
  static const Color gradEnd = Color(0xFFEC4899);

  // Accent colors for categories
  static const Color cyan = Color(0xFF06B6D4);
  static const Color amber = Color(0xFFF59E0B);
  static const Color emerald = Color(0xFF10B981);
  static const Color red = Color(0xFFEF4444);
  static const Color violet = Color(0xFF8B5CF6);
  static const Color pink = Color(0xFFEC4899);
  static const Color blue = Color(0xFF3B82F6);
  static const Color orange = Color(0xFFF97316);
  static const Color rose = Color(0xFFF43F5E);

  // Text colors
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFA1A1AA);
  static const Color textTertiary = Color(0xFF71717A);

  // Mood colors
  static const Color moodHappy = Color(0xFF10B981);
  static const Color moodNeutral = Color(0xFF3B82F6);
  static const Color moodStressed = Color(0xFFEF4444);
  static const Color moodCelebrating = Color(0xFFF59E0B);
  static const Color moodTired = Color(0xFF8B5CF6);

  // ═══════════════════════════════════════════════════════════
  // GRADIENTS
  // ═══════════════════════════════════════════════════════════

  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [gradStart, gradMid, gradEnd],
  );

  static const LinearGradient cardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF1F1F2E), Color(0xFF16161F)],
  );

  static const LinearGradient glassGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0x1AFFFFFF),
      Color(0x05FFFFFF),
    ],
  );

  // ═══════════════════════════════════════════════════════════
  // SHADOWS (For 3D effect)
  // ═══════════════════════════════════════════════════════════

  static List<BoxShadow> softShadow = [
    BoxShadow(
      color: Colors.black.withOpacity(0.4),
      blurRadius: 20,
      offset: const Offset(0, 10),
    ),
  ];

  static List<BoxShadow> glowShadow(Color color) => [
        BoxShadow(
          color: color.withOpacity(0.4),
          blurRadius: 30,
          spreadRadius: 2,
        ),
      ];

  static List<BoxShadow> cardShadow = [
    BoxShadow(
      color: Colors.black.withOpacity(0.5),
      blurRadius: 20,
      offset: const Offset(0, 8),
    ),
    BoxShadow(
      color: Colors.white.withOpacity(0.03),
      blurRadius: 1,
      offset: const Offset(0, -1),
    ),
  ];

  // ═══════════════════════════════════════════════════════════
  // BORDER RADIUS
  // ═══════════════════════════════════════════════════════════

  static const double radiusSm = 12.0;
  static const double radiusMd = 20.0;
  static const double radiusLg = 28.0;
  static const double radiusXl = 32.0;

  // ═══════════════════════════════════════════════════════════
  // SPACING
  // ═══════════════════════════════════════════════════════════

  static const double spaceXs = 4.0;
  static const double spaceSm = 8.0;
  static const double spaceMd = 16.0;
  static const double spaceLg = 24.0;
  static const double spaceXl = 32.0;

  // ═══════════════════════════════════════════════════════════
  // PREMIUM ANIMATIONS (Smooth, fast feel)
  // ═══════════════════════════════════════════════════════════

  /// Fast page transitions (300ms)
  static const Duration fastDuration = Duration(milliseconds: 300);

  /// Standard duration (400ms)
  static const Duration standardDuration = Duration(milliseconds: 400);

  /// Slow, smooth duration (600ms)
  static const Duration slowDuration = Duration(milliseconds: 600);

  /// Snappy curve for button taps and page transitions
  static const Curve snappy = Cubic(0.4, 0.0, 0.2, 1.0);

  /// Bouncy curve for emphasis
  static const Curve bouncy = Cubic(0.68, -0.55, 0.27, 1.55);

  /// Smooth ease out
  static const Curve smooth = Curves.easeOutCubic;
}