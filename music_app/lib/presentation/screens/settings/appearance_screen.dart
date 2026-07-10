import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'dart:ui';
import '../../../core/theme/app_theme.dart';

class AppearanceScreen extends StatelessWidget {
  const AppearanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF1E1433), Color(0xFF0F0C29), Color(0xFF090909)],
            stops: [0.0, 0.4, 1.0],
          ),
        ),
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              floating: true,
              pinned: true,
              expandedHeight: 110,
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_rounded),
                onPressed: () => Navigator.pop(context),
              ),
              flexibleSpace: ClipRRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: FlexibleSpaceBar(
                    titlePadding: const EdgeInsets.only(left: 72, bottom: 16),
                    title: const Text('Appearance', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 26, letterSpacing: -0.5))
                        .animate().fadeIn(duration: 800.ms).slideX(begin: -0.2),
                  ),
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.all(24.0),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  const Text('Theme Style', style: TextStyle(color: AppTheme.primaryColor, fontWeight: FontWeight.bold, fontSize: 14, letterSpacing: 1.5)).animate().fadeIn(delay: 100.ms),
                  const SizedBox(height: 16),
                  _buildThemeOption('Midnight Blue', 'Current active theme', true, 200),
                  const SizedBox(height: 12),
                  _buildThemeOption('True Black', 'OLED optimized', false, 300),
                  
                  const SizedBox(height: 48),
                  
                  const Text('Accent Color', style: TextStyle(color: AppTheme.primaryColor, fontWeight: FontWeight.bold, fontSize: 14, letterSpacing: 1.5)).animate().fadeIn(delay: 400.ms),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildColorCircle(AppTheme.primaryColor, true, 500),
                      _buildColorCircle(Colors.tealAccent, false, 600),
                      _buildColorCircle(Colors.orangeAccent, false, 700),
                      _buildColorCircle(Colors.pinkAccent, false, 800),
                    ],
                  ),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildThemeOption(String title, String subtitle, bool isSelected, int delay) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20),
        border: isSelected ? Border.all(color: AppTheme.primaryColor, width: 2) : Border.all(color: Colors.transparent, width: 2),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        title: Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
        subtitle: Text(subtitle, style: TextStyle(color: Colors.white.withOpacity(0.5))),
        trailing: isSelected ? const Icon(Icons.check_circle_rounded, color: AppTheme.primaryColor, size: 28) : const SizedBox.shrink(),
      ),
    ).animate().fadeIn(delay: delay.ms).slideY(begin: 0.1);
  }

  Widget _buildColorCircle(Color color, bool isSelected, int delay) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: isSelected ? Border.all(color: Colors.white, width: 4) : Border.all(color: Colors.transparent, width: 4),
        boxShadow: isSelected ? [BoxShadow(color: color.withOpacity(0.5), blurRadius: 20)] : [],
      ),
    ).animate().scale(delay: delay.ms, duration: 500.ms, curve: Curves.easeOutBack);
  }
}
