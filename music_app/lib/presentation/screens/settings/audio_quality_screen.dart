import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'dart:ui';
import '../../../core/theme/app_theme.dart';

class AudioQualityScreen extends StatefulWidget {
  const AudioQualityScreen({super.key});

  @override
  State<AudioQualityScreen> createState() => _AudioQualityScreenState();
}

class _AudioQualityScreenState extends State<AudioQualityScreen> {
  String _wifiQuality = 'Very High';
  String _cellularQuality = 'Normal';
  
  final List<String> _options = ['Low', 'Normal', 'High', 'Very High'];

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
                    title: const Text('Audio Quality', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 26, letterSpacing: -0.5))
                        .animate().fadeIn(duration: 800.ms).slideX(begin: -0.2),
                  ),
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.all(16.0),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  const Text('Wi-Fi Streaming', style: TextStyle(color: AppTheme.primaryColor, fontWeight: FontWeight.bold, fontSize: 14)).animate().fadeIn(delay: 100.ms),
                  const SizedBox(height: 12),
                  _buildQualitySelector('wifi', _wifiQuality, (val) => setState(() => _wifiQuality = val), 200),
                  
                  const SizedBox(height: 32),
                  const Text('Cellular Streaming', style: TextStyle(color: AppTheme.primaryColor, fontWeight: FontWeight.bold, fontSize: 14)).animate().fadeIn(delay: 300.ms),
                  const SizedBox(height: 12),
                  _buildQualitySelector('cellular', _cellularQuality, (val) => setState(() => _cellularQuality = val), 400),
                  
                  const SizedBox(height: 32),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(color: AppTheme.primaryColor.withOpacity(0.1), borderRadius: BorderRadius.circular(16)),
                    child: Row(
                      children: [
                        const Icon(Icons.info_outline, color: AppTheme.primaryColor),
                        const SizedBox(width: 16),
                        Expanded(child: const Text('Higher quality uses more data and bandwidth.', style: TextStyle(color: Colors.white70, fontSize: 13))),
                      ],
                    ),
                  ).animate().fadeIn(delay: 500.ms),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQualitySelector(String group, String currentValue, Function(String) onChanged, int delay) {
    return Container(
      decoration: BoxDecoration(color: Colors.white.withOpacity(0.05), borderRadius: BorderRadius.circular(16)),
      child: Column(
        children: _options.map((option) {
          final isSelected = option == currentValue;
          return ListTile(
            title: Text(option, style: TextStyle(color: Colors.white, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
            trailing: isSelected ? const Icon(Icons.check_circle_rounded, color: AppTheme.primaryColor) : null,
            onTap: () => onChanged(option),
          );
        }).toList(),
      ),
    ).animate().fadeIn(delay: delay.ms).slideY(begin: 0.1);
  }
}
