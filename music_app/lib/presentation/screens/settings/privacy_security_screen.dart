import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'dart:ui';
import '../../../core/theme/app_theme.dart';

class PrivacySecurityScreen extends StatefulWidget {
  const PrivacySecurityScreen({super.key});

  @override
  State<PrivacySecurityScreen> createState() => _PrivacySecurityScreenState();
}

class _PrivacySecurityScreenState extends State<PrivacySecurityScreen> {
  bool _analyticsEnabled = true;
  bool _personalizedAds = false;
  bool _twoFactorEnabled = true;

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
                    title: const Text('Privacy', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 26, letterSpacing: -0.5))
                        .animate().fadeIn(duration: 800.ms).slideX(begin: -0.2),
                  ),
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.all(16.0),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  _buildSectionHeader('Security', 0),
                  _buildActionTile('Change Password', 'Last updated 3 months ago', Icons.password_rounded, 50),
                  _buildSwitchTile('Two-Factor Auth', 'Protect your account', Icons.security_rounded, _twoFactorEnabled, (val) => setState(() => _twoFactorEnabled = val), 100),
                  
                  const SizedBox(height: 32),
                  _buildSectionHeader('Data Sharing', 150),
                  _buildSwitchTile('Share Analytics', 'Help us improve the app', Icons.analytics_outlined, _analyticsEnabled, (val) => setState(() => _analyticsEnabled = val), 200),
                  _buildSwitchTile('Personalized Ads', 'Show relevant advertisements', Icons.ad_units_rounded, _personalizedAds, (val) => setState(() => _personalizedAds = val), 250),
                  
                  const SizedBox(height: 32),
                  _buildSectionHeader('Control', 300),
                  _buildActionTile('Download My Data', 'Get a copy of your listening history', Icons.download_rounded, 350),
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
        style: const TextStyle(color: AppTheme.primaryColor, fontWeight: FontWeight.w800, fontSize: 14, letterSpacing: 1.5),
      ).animate().fadeIn(delay: delay.ms).slideX(begin: -0.1),
    );
  }

  Widget _buildActionTile(String title, String subtitle, IconData icon, int delay) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(color: Colors.white.withOpacity(0.03), borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: Colors.white.withOpacity(0.05), borderRadius: BorderRadius.circular(12)), child: Icon(icon, color: Colors.white70)),
        title: Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 16)),
        subtitle: Text(subtitle, style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 13)),
        trailing: Icon(Icons.chevron_right_rounded, color: Colors.white.withOpacity(0.3)),
        onTap: () {},
      ),
    ).animate().fadeIn(delay: delay.ms).slideY(begin: 0.2);
  }

  Widget _buildSwitchTile(String title, String subtitle, IconData icon, bool value, Function(bool) onChanged, int delay) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(color: Colors.white.withOpacity(0.03), borderRadius: BorderRadius.circular(16)),
      child: SwitchListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        secondary: Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: Colors.white.withOpacity(0.05), borderRadius: BorderRadius.circular(12)), child: Icon(icon, color: Colors.white70)),
        title: Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 16)),
        subtitle: Text(subtitle, style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 13)),
        value: value,
        activeColor: AppTheme.primaryColor,
        inactiveTrackColor: Colors.white.withOpacity(0.1),
        onChanged: onChanged,
      ),
    ).animate().fadeIn(delay: delay.ms).slideY(begin: 0.2);
  }
}
