import 'dart:ui';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

// ═══════════════════════════════════════════════════════════
// GLASS CARD — Premium frosted glass container
// ═══════════════════════════════════════════════════════════

class GlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;
  final EdgeInsets margin;
  final double? width;
  final double? height;
  final double blur;
  final double opacity;
  final Color? borderColor;
  final double radius;
  final VoidCallback? onTap;

  const GlassCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(20),
    this.margin = EdgeInsets.zero,
    this.width,
    this.height,
    this.blur = 12,
    this.opacity = 0.08,
    this.borderColor,
    this.radius = 24,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final card = Container(
      width: width,
      height: height,
      margin: margin,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(
          color: borderColor ?? Colors.white.withOpacity(0.08),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
          child: Container(
            padding: padding,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white.withOpacity(opacity),
                  Colors.white.withOpacity(opacity * 0.3),
                ],
              ),
            ),
            child: child,
          ),
        ),
      ),
    );

    if (onTap != null) {
      return GestureDetector(
        onTap: onTap,
        child: card,
      );
    }
    return card;
  }
}

// ═══════════════════════════════════════════════════════════
// GRADIENT CARD — Premium gradient container
// ═══════════════════════════════════════════════════════════

class GradientCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;
  final EdgeInsets margin;
  final double? width;
  final double? height;
  final Gradient? gradient;
  final double radius;
  final VoidCallback? onTap;

  const GradientCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(20),
    this.margin = EdgeInsets.zero,
    this.width,
    this.height,
    this.gradient,
    this.radius = 24,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final card = Container(
      width: width,
      height: height,
      margin: margin,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        gradient: gradient ?? AppTheme.primaryGradient,
        boxShadow: [
          BoxShadow(
            color: AppTheme.gradStart.withOpacity(0.3),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      padding: padding,
      child: child,
    );

    if (onTap != null) {
      return GestureDetector(onTap: onTap, child: card);
    }
    return card;
  }
}

// ═══════════════════════════════════════════════════════════
// DARK CARD — Simple elevated dark card
// ═══════════════════════════════════════════════════════════

class DarkCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;
  final EdgeInsets margin;
  final double? width;
  final double? height;
  final double radius;
  final VoidCallback? onTap;
  final Color? color;

  const DarkCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(20),
    this.margin = EdgeInsets.zero,
    this.width,
    this.height,
    this.radius = 24,
    this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final card = Container(
      width: width,
      height: height,
      margin: margin,
      padding: padding,
      decoration: BoxDecoration(
        color: color ?? AppTheme.surface,
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(
          color: Colors.white.withOpacity(0.05),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: child,
    );

    if (onTap != null) {
      return GestureDetector(onTap: onTap, child: card);
    }
    return card;
  }
}