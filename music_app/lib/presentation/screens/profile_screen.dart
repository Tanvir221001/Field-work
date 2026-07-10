import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'dart:ui';
import '../../core/theme/app_theme.dart';
import '../widgets/glass_card.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
              flexibleSpace: ClipRRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: FlexibleSpaceBar(
                    titlePadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    title: const Text(
                      'Profile',
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 26,
                        letterSpacing: -0.5,
                      ),
                    ).animate().fadeIn(duration: 800.ms).slideY(begin: 0.3),
                  ),
                ),
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.settings_rounded, size: 28),
                  onPressed: () => context.push('/settings'),
                ).animate().scale(delay: 300.ms),
                const SizedBox(width: 16),
              ],
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    // Avatar
                    Center(
                      child: Container(
                        width: 130,
                        height: 130,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.05),
                          border: Border.all(color: AppTheme.primaryColor.withOpacity(0.5), width: 3),
                          boxShadow: [
                            BoxShadow(
                              color: AppTheme.primaryColor.withOpacity(0.3),
                              blurRadius: 30,
                              spreadRadius: 5,
                            )
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(65),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                            child: const Icon(Icons.person_rounded, size: 70, color: Colors.white70),
                          ),
                        ),
                      ).animate().scale(duration: 600.ms, curve: Curves.easeOutBack),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Premium User',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                      ),
                    ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.2),
                    const SizedBox(height: 8),
                    Text(
                      'user@luxurymusic.com',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white.withOpacity(0.6),
                        fontWeight: FontWeight.w500,
                      ),
                    ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.2),
                    const SizedBox(height: 48),

                    // Stats row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildStatColumn('Followers', '1.2K'),
                        Container(height: 40, width: 1, color: Colors.white.withOpacity(0.1)),
                        _buildStatColumn('Following', '340'),
                        Container(height: 40, width: 1, color: Colors.white.withOpacity(0.1)),
                        _buildStatColumn('Playlists', '12'),
                      ],
                    ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.2),
                    const SizedBox(height: 48),

                    // Premium Subscription Card
                    GestureDetector(
                      onTap: () => context.push('/create_profile'),
                      child: GlassCard(
                        padding: const EdgeInsets.all(24),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: AppTheme.primaryColor.withOpacity(0.2),
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: AppTheme.primaryColor.withOpacity(0.2),
                                    blurRadius: 15,
                                  )
                                ],
                              ),
                              child: const Icon(Icons.person_add_rounded, color: AppTheme.primaryColor, size: 32),
                            ),
                            const SizedBox(width: 20),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Create Profile',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w800,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    'Join to save playlists & favorites across devices',
                                    style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 14, height: 1.4),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ).animate().fadeIn(delay: 500.ms).slideX(begin: 0.1),

                    const SizedBox(height: 40),

                    // Settings options
                    _buildSettingsTile(
                      context, 
                      Icons.history_rounded, 
                      'Listening History', 
                      delay: 700,
                      onTap: () => context.push('/settings/history'),
                    ),
                    _buildSettingsTile(
                      context, 
                      Icons.data_usage_rounded, 
                      'Data Saver', 
                      delay: 750,
                      onTap: () => context.push('/settings/data'),
                    ),
                    _buildSettingsTile(
                      context, 
                      Icons.equalizer_rounded, 
                      'Audio Quality', 
                      delay: 800,
                      onTap: () => context.push('/settings/audio'),
                    ),
                    _buildSettingsTile(
                      context, 
                      Icons.notifications_outlined, 
                      'Notifications', 
                      delay: 850,
                      onTap: () => context.push('/settings/notifications'),
                    ),
                    _buildSettingsTile(context, Icons.logout_rounded, 'Log Out', isDestructive: true, delay: 800),
                    
                    const SizedBox(height: 120), // padding for bottom nav
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatColumn(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w900,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.white.withOpacity(0.5),
            letterSpacing: 1,
          ),
        ),
      ],
    );
  }

  Widget _buildSettingsTile(BuildContext context, IconData icon, String title, {bool isDestructive = false, required int delay, VoidCallback? onTap}) {
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
            color: isDestructive ? AppTheme.errorColor.withOpacity(0.1) : Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: isDestructive ? AppTheme.errorColor : Colors.white70),
        ),
        title: Text(title, style: TextStyle(color: isDestructive ? AppTheme.errorColor : Colors.white, fontWeight: FontWeight.w600, fontSize: 16)),
        trailing: Icon(Icons.chevron_right_rounded, color: Colors.white.withOpacity(0.3)),
        onTap: onTap,
      ),
    ).animate().fadeIn(delay: delay.ms).slideY(begin: 0.2);
  }
}
