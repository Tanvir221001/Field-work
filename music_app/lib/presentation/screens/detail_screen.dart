import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'dart:ui';
import '../../domain/entities/song.dart';
import '../../core/theme/app_theme.dart';
import '../providers/player_provider.dart';
import '../providers/favorites_provider.dart';

class MusicDetailScreen extends ConsumerStatefulWidget {
  final Song song;
  const MusicDetailScreen({super.key, required this.song});

  @override
  ConsumerState<MusicDetailScreen> createState() => _MusicDetailScreenState();
}

class _MusicDetailScreenState extends ConsumerState<MusicDetailScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(playerStateProvider.notifier).playSong(widget.song);
    });
  }

  @override
  Widget build(BuildContext context) {
    final playerState = ref.watch(playerStateProvider);
    final isFavAsync = ref.watch(favoritesProvider);
    final isFavorite = isFavAsync.maybeWhen(
      data: (songs) => songs.any((s) => s.id == widget.song.id),
      orElse: () => false,
    );

    return Scaffold(
      body: Stack(
        children: [
          // Background blurred image
          Positioned.fill(
            child: CachedNetworkImage(
              imageUrl: widget.song.coverUrl ?? '',
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
              child: Container(color: Colors.black.withOpacity(0.5)),
            ),
          ),
          
          SafeArea(
            child: Column(
              children: [
                // AppBar
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.keyboard_arrow_down_rounded, size: 32, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const Text('Now Playing', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    IconButton(
                      icon: const Icon(Icons.more_vert, color: Colors.white),
                      onPressed: () {},
                    ),
                  ],
                ),
                
                const Spacer(flex: 1),
                
                // Album Art
                Hero(
                  tag: 'cover_${widget.song.id}',
                  child: Container(
                    width: 300,
                    height: 300,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(32),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.4),
                          blurRadius: 30,
                          offset: const Offset(0, 15),
                        )
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(32),
                      child: CachedNetworkImage(
                        imageUrl: widget.song.coverUrl ?? '',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                
                const Spacer(flex: 1),
                
                // Song Info
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.song.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              widget.song.artist,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: isFavorite ? AppTheme.secondaryColor : Colors.white,
                          size: 32,
                        ),
                        onPressed: () {
                          ref.read(favoritesProvider.notifier).toggleFavorite(widget.song);
                        },
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 32),
                
                // Progress Bar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Column(
                    children: [
                      SliderTheme(
                        data: SliderThemeData(
                          trackHeight: 4,
                          activeTrackColor: AppTheme.primaryColor,
                          inactiveTrackColor: Colors.white.withOpacity(0.2),
                          thumbColor: AppTheme.primaryColor,
                          thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
                          overlayShape: const RoundSliderOverlayShape(overlayRadius: 12),
                        ),
                        child: Slider(
                          value: playerState.position.inSeconds.toDouble(),
                          max: playerState.duration.inSeconds.toDouble() > 0 
                               ? playerState.duration.inSeconds.toDouble() 
                               : 30.0, // iTunes previews are usually 30s
                          onChanged: (val) {
                            ref.read(playerStateProvider.notifier).seek(Duration(seconds: val.toInt()));
                          },
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(_formatDuration(playerState.position), style: const TextStyle(color: Colors.white54)),
                          Text(_formatDuration(playerState.duration), style: const TextStyle(color: Colors.white54)),
                        ],
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // Controls
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.shuffle, color: Colors.white54),
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: const Icon(Icons.skip_previous_rounded, color: Colors.white, size: 40),
                      onPressed: () {},
                    ),
                    Container(
                      width: 80,
                      height: 80,
                      decoration: const BoxDecoration(
                        color: AppTheme.primaryColor,
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: Icon(
                          playerState.isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                          color: Colors.white,
                          size: 40,
                        ),
                        onPressed: () {
                          if (playerState.isPlaying) {
                            ref.read(playerStateProvider.notifier).pause();
                          } else {
                            ref.read(playerStateProvider.notifier).resume();
                          }
                        },
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.skip_next_rounded, color: Colors.white, size: 40),
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: const Icon(Icons.repeat, color: Colors.white54),
                      onPressed: () {},
                    ),
                  ],
                ),
                
                const Spacer(flex: 1),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  String _formatDuration(Duration d) {
    String minutes = d.inMinutes.toString().padLeft(2, '0');
    String seconds = (d.inSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }
}
