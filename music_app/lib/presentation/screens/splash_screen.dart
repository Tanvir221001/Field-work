import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/theme/app_theme.dart';
import 'dart:ui';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 4), () {
      if (mounted) {
        context.go('/home');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF1E1433), // Deep purple
              Color(0xFF0F0C29), // Midnight dark
              Color(0xFF000000), // Black
            ],
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            stops: [0.0, 0.5, 1.0],
          ),
        ),
        child: Stack(
          children: [
            // Ambient glowing orbs in the background
            Positioned(
              top: 100,
              left: -50,
              child: _buildGlowingOrb(AppTheme.primaryColor.withOpacity(0.3), 200)
                  .animate(onPlay: (controller) => controller.repeat(reverse: true))
                  .moveY(begin: -20, end: 20, duration: 2.seconds)
                  .fadeIn(duration: 1.seconds),
            ),
            Positioned(
              bottom: -50,
              right: -50,
              child: _buildGlowingOrb(Colors.blueAccent.withOpacity(0.2), 300)
                  .animate(onPlay: (controller) => controller.repeat(reverse: true))
                  .moveX(begin: 20, end: -20, duration: 3.seconds)
                  .fadeIn(duration: 1.seconds),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Animated Logo
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.1),
                          border: Border.all(color: Colors.white.withOpacity(0.2), width: 2),
                        ),
                      )
                      .animate()
                      .scale(duration: 1000.ms, curve: Curves.easeOutCubic)
                      .shimmer(delay: 1000.ms, duration: 1500.ms),
                      
                      ClipRRect(
                        borderRadius: BorderRadius.circular(60),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                          child: Container(
                            width: 120,
                            height: 120,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.transparent,
                            ),
                          ),
                        ),
                      ).animate().fadeIn(duration: 1200.ms),

                      ClipRRect(
                        borderRadius: BorderRadius.circular(60),
                        child: Image.asset(
                          'assets/images/logo.png',
                          width: 120,
                          height: 120,
                          fit: BoxFit.cover,
                        ),
                      )
                      .animate()
                      .scale(delay: 400.ms, duration: 800.ms, curve: Curves.elasticOut)
                      .shimmer(delay: 1500.ms, color: Colors.white24, duration: 1000.ms),
                    ],
                  ),
                  const SizedBox(height: 32),
                  
                  // Track Music Text
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Track',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 40,
                          fontWeight: FontWeight.w900,
                          letterSpacing: -1,
                        ),
                      )
                      .animate()
                      .slideX(begin: -0.5, end: 0, duration: 800.ms, curve: Curves.easeOutCubic)
                      .fadeIn(duration: 800.ms),
                      
                      const SizedBox(width: 8),
                      
                      const Text(
                        'Music',
                        style: TextStyle(
                          color: AppTheme.primaryColor,
                          fontSize: 40,
                          fontWeight: FontWeight.w900,
                          letterSpacing: -1,
                        ),
                      )
                      .animate()
                      .slideX(begin: 0.5, end: 0, duration: 800.ms, curve: Curves.easeOutCubic)
                      .fadeIn(duration: 800.ms),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Experience luxury sound',
                    style: TextStyle(
                      color: Colors.white54,
                      fontSize: 16,
                      letterSpacing: 2,
                      fontWeight: FontWeight.w500,
                    ),
                  )
                  .animate()
                  .slideY(begin: 1, end: 0, duration: 800.ms, delay: 400.ms, curve: Curves.easeOut)
                  .fadeIn(duration: 800.ms, delay: 400.ms),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGlowingOrb(Color color, double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
        boxShadow: [
          BoxShadow(
            color: color,
            blurRadius: size / 2,
            spreadRadius: size / 4,
          )
        ],
      ),
    );
  }
}
