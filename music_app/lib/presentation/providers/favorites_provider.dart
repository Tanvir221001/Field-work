import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/song.dart';
import 'repository_providers.dart';

final favoritesProvider = AsyncNotifierProvider<FavoritesNotifier, List<Song>>(FavoritesNotifier.new);

class FavoritesNotifier extends AsyncNotifier<List<Song>> {
  @override
  Future<List<Song>> build() async {
    return ref.read(localRepositoryProvider).getFavorites();
  }

  Future<void> toggleFavorite(Song song) async {
    try {
      await ref.read(localRepositoryProvider).toggleFavorite(song);
      // Reload favorites
      state = AsyncValue.data(await ref.read(localRepositoryProvider).getFavorites());
    } catch (e, st) {
      // Handle error implicitly or log
    }
  }
}
