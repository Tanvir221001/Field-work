import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:ui';
import '../../../core/theme/app_theme.dart';
import '../../providers/home_music_provider.dart';
import '../../widgets/music_list_item.dart';
import '../../widgets/glass_card.dart';

class ListeningHistoryScreen extends ConsumerWidget {
  const ListeningHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // We'll mock listening history using the trending songs from home provider
    final homeState = ref.watch(homeMusicProvider);

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
                    title: const Text('Listening History', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 22, letterSpacing: -0.5))
                        .animate().fadeIn(duration: 800.ms).slideX(begin: -0.2),
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('History cleared.'), backgroundColor: AppTheme.primaryColor)
                    );
                  },
                  child: const Text('Clear', style: TextStyle(color: AppTheme.primaryColor, fontWeight: FontWeight.bold)),
                ).animate().fadeIn(delay: 300.ms)
              ],
            ),
            SliverPadding(
              padding: const EdgeInsets.all(16.0),
              sliver: homeState.trending.when(
                loading: () => SliverToBoxAdapter(child: const Center(child: CircularProgressIndicator())),
                error: (e, st) => SliverToBoxAdapter(child: Text('Error: $e', style: const TextStyle(color: AppTheme.errorColor))),
                data: (songs) {
                  if (songs.isEmpty) {
                    return SliverToBoxAdapter(child: const Center(child: Text('No history found.', style: TextStyle(color: Colors.white54))));
                  }
                  return SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final song = songs[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: GlassCard(
                            padding: EdgeInsets.zero,
                            child: PremiumMusicListItem(
                              song: song,
                              onTap: () {},
                              trailing: const Icon(Icons.history_rounded, color: Colors.white24),
                            ),
                          ),
                        ).animate(delay: (40 * index).ms).fadeIn().slideY(begin: 0.1);
                      },
                      childCount: songs.length > 20 ? 20 : songs.length, // Show up to 20 recent songs
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
