import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

// ═══════════════════════════════════════════════════════════
// GRADIENT BUTTON — Premium 3D animated button
// ═══════════════════════════════════════════════════════════

class GradientButton extends StatefulWidget {
  final String label;
  final IconData? icon;
  final VoidCallback onPressed;
  final bool isLoading;
  final bool isFullWidth;
  final double height;
  final double? width;
  final Gradient? gradient;

  const GradientButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.isLoading = false,
    this.isFullWidth = false,
    this.height = 58,
    this.width,
    this.gradient,
  });

  @override
  State<GradientButton> createState() => _GradientButtonState();
}

class _GradientButtonState extends State<GradientButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scale;
  late Animation<double> _depth;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
      reverseDuration: const Duration(milliseconds: 200),
    );
    _scale = Tween(begin: 1.0, end: 0.96)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));
    _depth = Tween(begin: 0.0, end: 6.0)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _ctrl.forward(),
      onTapUp: (_) {
        _ctrl.reverse();
        if (!widget.isLoading) widget.onPressed();
      },
      onTapCancel: () => _ctrl.reverse(),
      child: AnimatedBuilder(
        animation: _ctrl,
        builder: (context, _) {
          return Transform.translate(
            offset: Offset(0, _depth.value),
            child: Transform.scale(
              scale: _scale.value,
              child: Container(
                width: widget.isFullWidth ? double.infinity : widget.width,
                height: widget.height,
                decoration: BoxDecoration(
                  gradient: widget.gradient ?? AppTheme.primaryGradient,
                  borderRadius: BorderRadius.circular(widget.height / 2),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.gradStart.withOpacity(0.4),
                      blurRadius: 24 - _depth.value * 2,
                      offset: Offset(0, 10 - _depth.value),
                    ),
                  ],
                ),
                child: Center(
                  child: widget.isLoading
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (widget.icon != null) ...[
                              Icon(widget.icon, color: Colors.white, size: 22),
                              const SizedBox(width: 10),
                            ],
                            Text(
                              widget.label,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.3,
                              ),
                            ),
                          ],
                        ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════
// OUTLINED BUTTON — Minimal outlined
// ═══════════════════════════════════════════════════════════

class OutlinedButtonCustom extends StatefulWidget {
  final String label;
  final IconData? icon;
  final VoidCallback onPressed;
  final Color? color;
  final double height;

  const OutlinedButtonCustom({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.color,
    this.height = 52,
  });

  @override
  State<OutlinedButtonCustom> createState() => _OutlinedButtonCustomState();
}

class _OutlinedButtonCustomState extends State<OutlinedButtonCustom> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final color = widget.color ?? AppTheme.gradStart;

    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        widget.onPressed();
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.96 : 1.0,
        duration: const Duration(milliseconds: 120),
        child: Container(
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.height / 2),
            border: Border.all(color: color.withOpacity(0.4), width: 1.5),
            color: color.withOpacity(0.08),
          ),
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (widget.icon != null) ...[
                  Icon(widget.icon, color: color, size: 20),
                  const SizedBox(width: 8),
                ],
                Text(
                  widget.label,
                  style: TextStyle(
                    color: color,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}