import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/song.dart';
import 'repository_providers.dart';
import 'dart:async';

final searchProvider = NotifierProvider<SearchNotifier, SearchState>(SearchNotifier.new);

class SearchState {
  final String query;
  final AsyncValue<List<Song>> results;
  final List<String> history;

  SearchState({
    this.query = '',
    this.results = const AsyncValue.data([]),
    this.history = const [],
  });

  SearchState copyWith({
    String? query,
    AsyncValue<List<Song>>? results,
    List<String>? history,
  }) {
    return SearchState(
      query: query ?? this.query,
      results: results ?? this.results,
      history: history ?? this.history,
    );
  }
}

class SearchNotifier extends Notifier<SearchState> {
  Timer? _debounce;

  @override
  SearchState build() {
    Future.microtask(() => _loadHistory());
    return SearchState();
  }

  Future<void> _loadHistory() async {
    final history = await ref.read(localRepositoryProvider).getSearchHistory();
    state = state.copyWith(history: history);
  }

  void search(String query) {
    state = state.copyWith(query: query);

    if (_debounce?.isActive ?? false) _debounce!.cancel();
    
    if (query.isEmpty) {
      state = state.copyWith(results: const AsyncValue.data([]));
      return;
    }

    _debounce = Timer(const Duration(milliseconds: 500), () async {
      try {
        state = state.copyWith(results: const AsyncValue.loading());
        final results = await ref.read(musicRepositoryProvider).searchSongs(query);
        state = state.copyWith(results: AsyncValue.data(results));
        
        // Add to history on successful search
        await ref.read(localRepositoryProvider).addSearchQuery(query);
        _loadHistory();
      } catch (e, st) {
        state = state.copyWith(results: AsyncValue.error(e, st));
      }
    });
  }
  
  Future<void> clearHistory() async {
    await ref.read(localRepositoryProvider).clearSearchHistory();
    _loadHistory();
  }
}
