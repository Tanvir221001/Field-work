import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'dart:ui';
import '../../../core/theme/app_theme.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  bool _newReleases = true;
  bool _playlistUpdates = true;
  bool _concerts = false;
  bool _promotions = false;

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
                    title: const Text('Notifications', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 26, letterSpacing: -0.5))
                        .animate().fadeIn(duration: 800.ms).slideX(begin: -0.2),
                  ),
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.all(16.0),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  const Text('Push Notifications', style: TextStyle(color: AppTheme.primaryColor, fontWeight: FontWeight.bold, fontSize: 14)).animate().fadeIn(delay: 100.ms),
                  const SizedBox(height: 16),
                  _buildSwitchTile('New Music', 'Get notified when your favorite artists release new tracks.', Icons.music_note_rounded, _newReleases, (val) => setState(() => _newReleases = val), 200),
                  const SizedBox(height: 12),
                  _buildSwitchTile('Playlist Updates', 'Know when curated playlists are refreshed.', Icons.queue_music_rounded, _playlistUpdates, (val) => setState(() => _playlistUpdates = val), 300),
                  const SizedBox(height: 12),
                  _buildSwitchTile('Concerts & Events', 'Local shows from artists you love.', Icons.event_rounded, _concerts, (val) => setState(() => _concerts = val), 400),
                  const SizedBox(height: 12),
                  _buildSwitchTile('Special Offers', 'Promotions and premium features.', Icons.local_offer_rounded, _promotions, (val) => setState(() => _promotions = val), 500),
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
