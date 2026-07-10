import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'dart:ui';
import '../../core/theme/app_theme.dart';
import '../providers/home_music_provider.dart';
import '../widgets/music_list_item.dart';
import '../../domain/entities/song.dart';
import '../widgets/glass_card.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeState = ref.watch(homeMusicProvider);

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
        child: RefreshIndicator(
          onRefresh: () => ref.read(homeMusicProvider.notifier).loadHomeData(),
          color: AppTheme.accentColor,
          backgroundColor: AppTheme.cardColor,
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
                        'Good Evening',
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 26,
                          letterSpacing: -0.5,
                          shadows: [Shadow(color: Colors.black45, blurRadius: 10)],
                        ),
                      ).animate().fadeIn(duration: 800.ms).slideY(begin: 0.3),
                    ),
                  ),
                ),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.notifications_outlined, size: 28),
                    onPressed: () {},
                  ).animate().scale(delay: 400.ms),
                  const SizedBox(width: 16),
                ],
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Hero Featured Section (Top song of new releases)
                      _buildHeroSection(context, homeState.newReleases),
                      
                      const SizedBox(height: 32),
                      _buildSectionTitle('Trending Now'),
                      const SizedBox(height: 16),
                      _buildHorizontalList(context, homeState.trending),
                      
                      const SizedBox(height: 32),
                      _buildSectionTitle('New Releases'),
                      const SizedBox(height: 16),
                      _buildVerticalList(context, homeState.newReleases),
                      const SizedBox(height: 120), // padding for bottom nav
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeroSection(BuildContext context, AsyncValue<List<Song>> state) {
    return state.when(
      loading: () => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Container(
          height: 220,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(32),
          ),
        ).animate().shimmer(),
      ),
      error: (e, st) => const SizedBox.shrink(),
      data: (songs) {
        if (songs.isEmpty) return const SizedBox.shrink();
        final featured = songs.first; // Pick the first song as featured
        
        return GestureDetector(
          onTap: () => context.push('/detail', extra: featured),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 24),
            height: 240,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(32),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.primaryColor.withOpacity(0.3),
                  blurRadius: 30,
                  offset: const Offset(0, 15),
                )
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(32),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  CachedNetworkImage(
                    imageUrl: featured.coverUrl ?? '',
                    fit: BoxFit.cover,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.2),
                          Colors.black.withOpacity(0.8),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 24,
                    left: 24,
                    right: 24,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: AppTheme.primaryColor.withOpacity(0.8),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Text(
                                  'FEATURED',
                                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1),
                                ),
                              ).animate().fadeIn(delay: 300.ms),
                              const SizedBox(height: 8),
                              Text(
                                featured.title,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                featured.artist,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white.withOpacity(0.8),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(40),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                            child: Container(
                              width: 56,
                              height: 56,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white.withOpacity(0.2),
                                border: Border.all(color: Colors.white.withOpacity(0.3)),
                              ),
                              child: const Icon(Icons.play_arrow_rounded, color: Colors.white, size: 36),
                            ),
                          ),
                        ).animate().scale(delay: 500.ms),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ).animate().fadeIn(duration: 800.ms).slideY(begin: 0.1),
        );
      }
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.5,
              color: Colors.white,
            ),
          ),
          const Icon(Icons.chevron_right_rounded, color: Colors.white54, size: 28),
        ],
      ).animate().fadeIn().slideX(begin: -0.1),
    );
  }

  Widget _buildHorizontalList(BuildContext context, AsyncValue<List<Song>> state) {
    return SizedBox(
      height: 220,
      child: state.when(
        loading: () => ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: 5,
          itemBuilder: (context, index) => _buildSkeletonCard().animate().shimmer(),
        ),
        error: (err, stack) => Center(child: Text('Error: $err')),
        data: (songs) {
          if (songs.isEmpty) return const Center(child: Text('No trending songs'));
          return ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: songs.length,
            itemBuilder: (context, index) {
              final song = songs[index];
              return _buildFeaturedCard(context, song)
                  .animate(delay: (50 * index).ms)
                  .fadeIn()
                  .slideX(begin: 0.2);
            },
          );
        },
      ),
    );
  }

  Widget _buildFeaturedCard(BuildContext context, Song song) {
    return GestureDetector(
      onTap: () => context.push('/detail', extra: song),
      child: Container(
        width: 160,
        margin: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Hero(
              tag: 'cover_${song.id}',
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.4),
                      blurRadius: 15,
                      offset: const Offset(0, 8),
                    )
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: CachedNetworkImage(
                    imageUrl: song.coverUrl ?? '',
                    height: 160,
                    width: 160,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              song.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
            ),
            Text(
              song.artist,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 13, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVerticalList(BuildContext context, AsyncValue<List<Song>> state) {
    return state.when(
      loading: () => Column(
        children: List.generate(5, (index) => _buildSkeletonListItem().animate().shimmer()),
      ),
      error: (err, stack) => Center(child: Text('Error: $err')),
      data: (songs) {
        if (songs.isEmpty) return const Center(child: Text('No new releases'));
        // Skip the first song since it's in the Hero section
        final listSongs = songs.length > 1 ? songs.skip(1).toList() : songs;
        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: listSongs.length,
          itemBuilder: (context, index) {
            final song = listSongs[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: GlassCard(
                padding: const EdgeInsets.all(0),
                child: PremiumMusicListItem(
                  song: song,
                  onTap: () => context.push('/detail', extra: song),
                ),
              ).animate(delay: (30 * index).ms).fadeIn().slideY(begin: 0.1),
            );
          },
        );
      },
    );
  }

  Widget _buildSkeletonCard() {
    return Container(
      width: 160,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 160,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(24),
            ),
          ),
          const SizedBox(height: 12),
          Container(height: 16, width: 120, color: Colors.white.withOpacity(0.1)),
          const SizedBox(height: 6),
          Container(height: 12, width: 80, color: Colors.white.withOpacity(0.1)),
        ],
      ),
    );
  }
  
  Widget _buildSkeletonListItem() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Container(
            width: 60, height: 60,
            decoration: BoxDecoration(color: Colors.white.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(height: 16, width: double.infinity, color: Colors.white.withOpacity(0.1)),
                const SizedBox(height: 8),
                Container(height: 12, width: 100, color: Colors.white.withOpacity(0.1)),
              ],
            ),
          )
        ],
      ),
    );
  }
}
