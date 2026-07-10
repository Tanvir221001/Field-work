import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:ui';
import '../../../core/theme/app_theme.dart';

class DataSaverScreen extends ConsumerStatefulWidget {
  const DataSaverScreen({super.key});

  @override
  ConsumerState<DataSaverScreen> createState() => _DataSaverScreenState();
}

class _DataSaverScreenState extends ConsumerState<DataSaverScreen> {
  bool _dataSaverEnabled = false;
  bool _audioOnly = false;
  bool _downloadOverWifiOnly = true;

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
                    title: const Text('Data Saver', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 26, letterSpacing: -0.5))
                        .animate().fadeIn(duration: 800.ms).slideX(begin: -0.2),
                  ),
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.all(16.0),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  _buildSwitchTile('Data Saver Mode', 'Sets audio quality to low and disables canvases/videos.', Icons.data_usage_rounded, _dataSaverEnabled, (val) => setState(() => _dataSaverEnabled = val), 100),
                  const SizedBox(height: 16),
                  _buildSwitchTile('Audio-Only Podcasts', 'Download only the audio of video podcasts.', Icons.podcasts_rounded, _audioOnly, (val) => setState(() => _audioOnly = val), 200),
                  const SizedBox(height: 16),
                  _buildSwitchTile('Download Over Wi-Fi Only', 'Prevents downloading using cellular data.', Icons.wifi_rounded, _downloadOverWifiOnly, (val) => setState(() => _downloadOverWifiOnly = val), 300),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSwitchTile(String title, String subtitle, IconData icon, bool value, Function(bool) onChanged, int delay) {
    return Container(
      decoration: BoxDecoration(color: Colors.white.withOpacity(0.05), borderRadius: BorderRadius.circular(16)),
      child: SwitchListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        secondary: Icon(icon, color: Colors.white70, size: 28),
        title: Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
        subtitle: Text(subtitle, style: TextStyle(color: Colors.white.withOpacity(0.5))),
        value: value,
        activeColor: AppTheme.primaryColor,
        onChanged: onChanged,
      ),
    ).animate().fadeIn(delay: delay.ms).slideY(begin: 0.1);
  }
}
