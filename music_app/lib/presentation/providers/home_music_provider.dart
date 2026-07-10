import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/song.dart';
import 'repository_providers.dart';

final homeMusicProvider = NotifierProvider<HomeMusicNotifier, HomeMusicState>(HomeMusicNotifier.new);

class HomeMusicState {
  final AsyncValue<List<Song>> trending;
  final AsyncValue<List<Song>> newReleases;

  HomeMusicState({
    this.trending = const AsyncValue.loading(),
    this.newReleases = const AsyncValue.loading(),
  });

  HomeMusicState copyWith({
    AsyncValue<List<Song>>? trending,
    AsyncValue<List<Song>>? newReleases,
  }) {
    return HomeMusicState(
      trending: trending ?? this.trending,
      newReleases: newReleases ?? this.newReleases,
    );
  }
}

class HomeMusicNotifier extends Notifier<HomeMusicState> {
  @override
  HomeMusicState build() {
    // Start data load asynchronously, but return initial loading state
    Future.microtask(() => loadHomeData());
    return HomeMusicState();
  }

  Future<void> loadHomeData() async {
    _loadTrending();
    _loadNewReleases();
  }

  Future<void> _loadTrending() async {
    try {
      state = state.copyWith(trending: const AsyncValue.loading());
      final songs = await ref.read(musicRepositoryProvider).getTrendingSongs();
      state = state.copyWith(trending: AsyncValue.data(songs));
    } catch (e, st) {
      state = state.copyWith(trending: AsyncValue.error(e, st));
    }
  }

  Future<void> _loadNewReleases() async {
    try {
      state = state.copyWith(newReleases: const AsyncValue.loading());
      final songs = await ref.read(musicRepositoryProvider).getNewReleases();
      state = state.copyWith(newReleases: AsyncValue.data(songs));
    } catch (e, st) {
      state = state.copyWith(newReleases: AsyncValue.error(e, st));
    }
  }
}
