import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'dart:ui';
import '../../core/theme/app_theme.dart';
import '../providers/search_provider.dart';
import '../widgets/music_list_item.dart';
import '../widgets/glass_card.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final searchState = ref.watch(searchProvider);
    final isSearching = searchState.query.isNotEmpty;

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
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: const Text(
                  'Search',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    letterSpacing: -0.5,
                  ),
                ).animate().fadeIn(duration: 600.ms).slideX(begin: -0.1),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Hero(
                  tag: 'search_bar',
                  child: Material(
                    color: Colors.transparent,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.white.withOpacity(0.1)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          )
                        ],
                      ),
                      child: TextField(
                        controller: _controller,
                        focusNode: _focusNode,
                        style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
                        decoration: InputDecoration(
                          hintText: 'Songs, Albums, or Artists',
                          hintStyle: TextStyle(color: Colors.white.withOpacity(0.4)),
                          prefixIcon: Icon(Icons.search_rounded, color: Colors.white.withOpacity(0.6), size: 28),
                          suffixIcon: _controller.text.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.close_rounded, color: Colors.white70),
                                  onPressed: () {
                                    _controller.clear();
                                    ref.read(searchProvider.notifier).search('');
                                  },
                                )
                              : null,
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                        ),
                        onChanged: (val) {
                          ref.read(searchProvider.notifier).search(val);
                        },
                      ),
                    ),
                  ),
                ).animate().fadeIn(delay: 200.ms).slideY(begin: -0.2),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: isSearching
                    ? _buildSearchResults(searchState)
                    : _buildSearchHistory(searchState),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchResults(SearchState state) {
    return state.results.when(
      loading: () => ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: 8,
        itemBuilder: (context, index) => _buildSkeletonItem().animate().shimmer(),
      ),
      error: (e, st) => Center(child: Text('Error: $e', style: const TextStyle(color: AppTheme.errorColor))),
      data: (songs) {
        if (songs.isEmpty) {
          return const Center(child: Text('No results found.', style: TextStyle(color: Colors.white54, fontSize: 16)));
        }
        return ListView.builder(
          padding: const EdgeInsets.only(left: 16, right: 16, bottom: 120),
          itemCount: songs.length,
          itemBuilder: (context, index) {
            final song = songs[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: GlassCard(
                padding: EdgeInsets.zero,
                child: PremiumMusicListItem(
                  song: song,
                  onTap: () => context.push('/detail', extra: song),
                ),
              ),
            ).animate(delay: (20 * index).ms).fadeIn().slideY(begin: 0.1);
          },
        );
      },
    );
  }

  Widget _buildSearchHistory(SearchState state) {
    if (state.history.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_rounded, size: 80, color: Colors.white.withOpacity(0.1)),
            const SizedBox(height: 16),
            Text('Search for your favorite tracks', style: TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 16)),
          ],
        ).animate().fadeIn(delay: 300.ms),
      );
    }
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Recent Searches',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Colors.white),
              ),
              TextButton(
                onPressed: () => ref.read(searchProvider.notifier).clearHistory(),
                child: const Text('Clear', style: TextStyle(color: AppTheme.primaryColor)),
              ),
            ],
          ).animate().fadeIn(delay: 300.ms),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: state.history.length,
            itemBuilder: (context, index) {
              final query = state.history[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.02),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: ListTile(
                  leading: const Icon(Icons.history_rounded, color: Colors.white54),
                  title: Text(query, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500)),
                  trailing: const Icon(Icons.north_west_rounded, color: Colors.white24, size: 16),
                  onTap: () {
                    _controller.text = query;
                    ref.read(searchProvider.notifier).search(query);
                    // Move cursor to end
                    _controller.selection = TextSelection.fromPosition(TextPosition(offset: _controller.text.length));
                  },
                ),
              ).animate(delay: (40 * index).ms).fadeIn().slideX(begin: -0.1);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSkeletonItem() {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
