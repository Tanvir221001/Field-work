import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/model/playlist.dart';
import '../../data/model/music_item.dart';
import '../../providers/playlist_provider.dart';
import '../widgets/music_list_item.dart';
import 'detail_screen.dart';

class PlaylistDetailScreen extends StatefulWidget {
  final Playlist playlist;

  const PlaylistDetailScreen({super.key, required this.playlist});

  @override
  State<PlaylistDetailScreen> createState() => _PlaylistDetailScreenState();
}

class _PlaylistDetailScreenState extends State<PlaylistDetailScreen> {
  List<MusicItem> _tracks = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTracks();
  }

  Future<void> _loadTracks() async {
    final provider = context.read<PlaylistProvider>();
    final tracks = await provider.getPlaylistTracks(widget.playlist.id!);
    setState(() {
      _tracks = tracks;
      _isLoading = false;
    });
  }

  void _removeTrack(MusicItem item) async {
    final provider = context.read<PlaylistProvider>();
    await provider.removeTrackFromPlaylist(widget.playlist.id!, item.id);
    _loadTracks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF0F0817), Color(0xFF1E1128), Color(0xFF0C101A)],
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Expanded(
                    child: Text(
                      widget.playlist.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              Expanded(
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator(color: Colors.deepPurpleAccent))
                    : _tracks.isEmpty
                        ? const Center(
                            child: Text(
                              'This playlist is empty.',
                              style: TextStyle(color: Colors.white54, fontSize: 16),
                            ),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                            itemCount: _tracks.length,
                            itemBuilder: (context, index) {
                              final item = _tracks[index];
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 12.0),
                                child: Stack(
                                  children: [
                                    MusicListItem(
                                      item: item,
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => DetailScreen(item: item),
                                          ),
                                        );
                                      },
                                    ),
                                    Positioned(
                                      right: 8,
                                      top: 8,
                                      bottom: 8,
                                      child: IconButton(
                                        icon: const Icon(Icons.remove_circle_outline, color: Colors.redAccent),
                                        onPressed: () => _removeTrack(item),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
