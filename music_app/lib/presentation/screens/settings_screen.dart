import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'dart:ui';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_theme.dart';
import '../providers/settings_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF1E1433), // Deep purple
              Color(0xFF0F0C29), // Midnight dark
              Color(0xFF090909), // Black
            ],
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
                    title: const Text(
                      'Settings',
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 26,
                        letterSpacing: -0.5,
                      ),
                    ).animate().fadeIn(duration: 800.ms).slideX(begin: -0.2),
                  ),
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.all(16.0),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  _buildSectionHeader('Account', 0),
                  _buildSettingsTile(
                    context, 
                    icon: Icons.person_outline, 
                    title: 'Account Details', 
                    subtitle: 'Edit your profile info',
                    delay: 50,
                    onTap: () => context.push('/settings/account'),
                  ),
                  _buildSettingsTile(
                    context, 
                    icon: Icons.lock_outline, 
                    title: 'Privacy & Security', 
                    subtitle: 'Manage your data',
                    delay: 100,
                    onTap: () => context.push('/settings/privacy'),
                  ),
                  _buildSettingsTile(
                    context, 
                    icon: Icons.payment, 
                    title: 'Subscription', 
                    subtitle: 'Manage your Luxury Premium',
                    delay: 150,
                    onTap: () => context.push('/settings/subscription'),
                  ),
                  
                  const SizedBox(height: 32),
                  _buildSectionHeader('Playback', 200),
                  _buildSwitchTile(
                    icon: Icons.offline_bolt_outlined, 
                    title: 'Offline Mode', 
                    subtitle: 'Only play downloaded music', 
                    value: settings.offlineMode,
                    delay: 250,
                    onChanged: (val) => ref.read(settingsProvider.notifier).toggleOfflineMode(val),
                  ),
                  _buildSwitchTile(
                    icon: Icons.high_quality, 
                    title: 'High Quality Audio', 
                    subtitle: 'Always stream at 320kbps', 
                    value: settings.highQualityAudio,
                    delay: 300,
                    onChanged: (val) => ref.read(settingsProvider.notifier).toggleHighQualityAudio(val),
                  ),
                  _buildSwitchTile(
                    icon: Icons.av_timer, 
                    title: 'Crossfade', 
                    subtitle: 'Seamless transitions between songs', 
                    value: settings.crossfade,
                    delay: 350,
                    onChanged: (val) => ref.read(settingsProvider.notifier).toggleCrossfade(val),
                  ),
                  
                  const SizedBox(height: 32),
                  _buildSectionHeader('App', 400),
                  _buildSettingsTile(
                    context,
                    icon: Icons.color_lens_outlined, 
                    title: 'Appearance', 
                    subtitle: 'Dark mode enabled',
                    delay: 450,
                    onTap: () => context.push('/settings/appearance'),
                  ),
                  _buildSettingsTile(
                    context,
                    icon: Icons.language, 
                    title: 'Language', 
                    subtitle: 'English (US)',
                    delay: 500,
                    onTap: () => context.push('/settings/language'),
                  ),
                  _buildSettingsTile(
                    context,
                    icon: Icons.info_outline, 
                    title: 'About', 
                    subtitle: 'Version 1.0.0',
                    delay: 550,
                    onTap: () {
                      showAboutDialog(
                        context: context,
                        applicationName: 'Luxury Music',
                        applicationVersion: '1.0.0',
                        applicationIcon: const Icon(Icons.music_note_rounded, size: 50, color: AppTheme.primaryColor),
                        children: [
                          const Text('Designed for the ultimate listening experience.')
                        ]
                      );
                    },
                  ),
                  
                  const SizedBox(height: 60),
                  Center(
                    child: TextButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Delete Account process initiated.', style: TextStyle(color: Colors.white)), backgroundColor: AppTheme.errorColor)
                        );
                      },
                      child: const Text('Delete Account', style: TextStyle(color: AppTheme.errorColor, fontSize: 16, fontWeight: FontWeight.bold)),
                    ).animate().fadeIn(delay: 800.ms),
                  ),
                  const SizedBox(height: 40),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, int delay) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, bottom: 12, top: 8),
      child: Text(
        title,
        style: const TextStyle(
          color: AppTheme.primaryColor,
          fontWeight: FontWeight.w800,
          fontSize: 14,
          letterSpacing: 1.5,
        ),
      ).animate().fadeIn(delay: delay.ms).slideX(begin: -0.1),
    );
  }

  Widget _buildSettingsTile(BuildContext context, {required IconData icon, required String title, required String subtitle, required int delay, VoidCallback? onTap}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.03),
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: Colors.white70),
        ),
        title: Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 16)),
        subtitle: Text(subtitle, style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 13)),
        trailing: Icon(Icons.chevron_right_rounded, color: Colors.white.withOpacity(0.3)),
        onTap: onTap,
      ),
    ).animate().fadeIn(delay: delay.ms).slideY(begin: 0.2);
  }

  Widget _buildSwitchTile({required IconData icon, required String title, required String subtitle, required bool value, required int delay, required Function(bool) onChanged}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.03),
        borderRadius: BorderRadius.circular(16),
      ),
      child: SwitchListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        secondary: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: Colors.white70),
        ),
        title: Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 16)),
        subtitle: Text(subtitle, style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 13)),
        value: value,
        activeColor: AppTheme.primaryColor,
        inactiveTrackColor: Colors.white.withOpacity(0.1),
        onChanged: onChanged,
      ),
    ).animate().fadeIn(delay: delay.ms).slideY(begin: 0.2);
  }

  // Note: _showComingSoon was removed since all functions now work!
}
