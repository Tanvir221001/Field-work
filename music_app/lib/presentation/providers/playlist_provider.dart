import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/playlist.dart';
import '../../domain/entities/song.dart';
import 'repository_providers.dart';

final playlistProvider = AsyncNotifierProvider<PlaylistNotifier, List<Playlist>>(PlaylistNotifier.new);

class PlaylistNotifier extends AsyncNotifier<List<Playlist>> {
  @override
  Future<List<Playlist>> build() async {
    return ref.read(localRepositoryProvider).getPlaylists();
  }

  Future<void> createPlaylist(String name) async {
    try {
      await ref.read(localRepositoryProvider).createPlaylist(name);
      state = AsyncValue.data(await ref.read(localRepositoryProvider).getPlaylists());
    } catch (e) {
      // handle
    }
  }

  Future<void> deletePlaylist(int id) async {
    try {
      await ref.read(localRepositoryProvider).deletePlaylist(id);
      state = AsyncValue.data(await ref.read(localRepositoryProvider).getPlaylists());
    } catch (e) {
      // handle
    }
  }

  Future<void> addSongToPlaylist(int playlistId, Song song) async {
    try {
      await ref.read(localRepositoryProvider).addSongToPlaylist(playlistId, song);
      state = AsyncValue.data(await ref.read(localRepositoryProvider).getPlaylists());
    } catch (e) {
      // handle
    }
  }
}
