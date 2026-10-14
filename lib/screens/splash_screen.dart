import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_theme.dart';
import 'main_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Navigate to home after 2 seconds
    Future.delayed(const Duration(milliseconds: 2200), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
                       transitionDuration: AppTheme.standardDuration,
            pageBuilder: (_, __, ___) => const MainScreen(),
            transitionsBuilder: (_, anim, __, child) =>
                FadeTransition(opacity: anim, child: child),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bg,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                gradient: AppTheme.primaryGradient,
                borderRadius: BorderRadius.circular(36),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.gradStart.withOpacity(0.5),
                    blurRadius: 60,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: const Center(
                child: Text(
                  '💗',
                  style: TextStyle(fontSize: 60),
                ),
              ),
            )
                .animate()
                .scale(
                    duration: 900.ms,
                    curve: Curves.elasticOut,
                    begin: const Offset(0.2, 0.2))
                .fadeIn(duration: 500.ms),

            const SizedBox(height: 40),

            // Title
            ShaderMask(
              shaderCallback: (bounds) =>
                  AppTheme.primaryGradient.createShader(bounds),
              child: const Text(
                'Pulse',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 44,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 4,
                ),
              ),
            )
                .animate()
                .fadeIn(delay: 400.ms, duration: 700.ms)
                .slideY(begin: 0.3, end: 0, curve: Curves.easeOut),

            const SizedBox(height: 12),

            // Subtitle
            Text(
              'LIFE ENERGY TRACKER',
              style: TextStyle(
                color: Colors.white.withOpacity(0.5),
                fontSize: 12,
                letterSpacing: 6,
                fontWeight: FontWeight.w300,
              ),
            )
                .animate()
                .fadeIn(delay: 800.ms, duration: 700.ms),
          ],
        ),
      ),
    );
  }
}