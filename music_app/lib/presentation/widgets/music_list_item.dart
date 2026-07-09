import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import '../../data/model/music_item.dart';
import '../../providers/auth_provider.dart';
import '../../providers/playlist_provider.dart';
import '../screens/detail_screen.dart';

class MusicListItem extends StatelessWidget {
  final MusicItem item;
  final VoidCallback? onTap;
  final Widget? trailing;

  const MusicListItem({super.key, required this.item, this.onTap, this.trailing});

  void _showAddToPlaylistDialog(BuildContext context) {
    final user = context.read<AuthProvider>().currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please login first')));
      return;
    }
    
    final playlists = context.read<PlaylistProvider>().playlists;
    if (playlists.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('No playlists available')));
      return;
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1E1128),
          title: const Text('Add to Playlist', style: TextStyle(color: Colors.white)),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: playlists.length,
              itemBuilder: (context, index) {
                final playlist = playlists[index];
                return ListTile(
                  title: Text(playlist.name, style: const TextStyle(color: Colors.white)),
                  onTap: () {
                    context.read<PlaylistProvider>().addTrackToPlaylist(playlist.id!, item.id);
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Added to ${playlist.name}')));
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Hero(
        tag: 'list_img_${item.id}',
        child: ClipRRect(
          borderRadius: BorderRadius.circular(25.0),
          child: item.imageUrl.isNotEmpty
              ? CachedNetworkImage(
                  imageUrl: item.imageUrl,
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(color: Colors.white10),
                  errorWidget: (context, url, error) => const Icon(Icons.error, color: Colors.white54),
                )
              : Container(
                  width: 50,
                  height: 50,
                  color: Colors.white10,
                  child: const Icon(Icons.music_note, color: Colors.white54),
                ),
        ),
      ),
      title: Text(item.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
      subtitle: Text(item.subtitle, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.white54, fontSize: 13)),
      trailing: trailing ?? Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(item.isLocal ? Icons.favorite : Icons.favorite_border, color: item.isLocal ? Colors.redAccent : Colors.white24, size: 20),
          const SizedBox(width: 12),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: Colors.white54, size: 20),
            color: const Color(0xFF1E1128),
            onSelected: (value) {
              if (value == 'add_playlist') {
                _showAddToPlaylistDialog(context);
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'add_playlist',
                child: Text('Add to Playlist', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ],
      ),
      onTap: onTap ?? () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => DetailScreen(item: item),
          ),
        );
      },
    );
  }
}
