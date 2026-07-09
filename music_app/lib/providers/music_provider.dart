import 'package:flutter/material.dart';
import '../data/model/music_item.dart';
import '../data/datasource/remote_datasource.dart';
import '../data/datasource/local_datasource.dart';

class MusicProvider extends ChangeNotifier {
  final RemoteDataSource remoteDataSource = RemoteDataSource();
  final LocalDataSource localDataSource = LocalDataSource();

  List<MusicItem> _items = [];
  bool _isLoading = false;
  String _error = '';
  
  // Pagination
  int _currentPage = 0;
  static const int _pageSize = 20;
  bool _hasMore = true;
  String _currentQuery = '';

  List<MusicItem> get items => _items;
  bool get isLoading => _isLoading;
  String get error => _error;
  bool get hasMore => _hasMore;

  MusicProvider() {
    loadInitialData();
  }

  Future<void> loadInitialData() async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      final cachedItems = await localDataSource.getCachedMusic(limit: _pageSize, offset: 0);
      if (cachedItems.isNotEmpty) {
        _items = cachedItems;
        _currentPage = 1;
        _isLoading = false;
        notifyListeners();
      }

      await fetchMusic(refresh: true);
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchMusic({String query = '', bool refresh = false}) async {
    if (refresh) {
      _currentPage = 0;
      _items.clear();
      _hasMore = true;
      _error = '';
    }

    if (!_hasMore) return;

    if (query != _currentQuery) {
      _currentQuery = query;
      _currentPage = 0;
      _items.clear();
      _hasMore = true;
    }

    _isLoading = true;
    notifyListeners();

    try {
      // If fetching the first page, fetch from API and cache
      if (_currentPage == 0) {
         try {
           final apiItems = await remoteDataSource.searchMusic(_currentQuery.isEmpty ? 'bangla hindi english pop rock jazz acoustic' : _currentQuery, limit: 200);
           await localDataSource.cacheMusicList(apiItems);
         } catch (apiError) {
           // Continue offline loading if API fails
           _error = 'Offline Mode - Loaded from Cache';
         }
      }

      // Load paginated from local SQLite database
      final localItems = _currentQuery.isEmpty
          ? await localDataSource.getCachedMusic(limit: _pageSize, offset: _currentPage * _pageSize)
          : await localDataSource.searchCachedMusic(_currentQuery, limit: _pageSize, offset: _currentPage * _pageSize);

      if (localItems.isEmpty && _currentPage > 0) {
        _hasMore = false;
      } else {
        // filter out duplicates before adding
        for(var item in localItems) {
            if(!_items.any((existing) => existing.id == item.id)){
               _items.add(item);
            }
        }
        _currentPage++;
      }
    } catch (e) {
      _error = _error.isEmpty ? e.toString() : _error;
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> addCustomMusic(MusicItem item) async {
    await localDataSource.insertLocalMusic(item);
    await fetchMusic(query: _currentQuery, refresh: true);
  }

  Future<void> updateCustomMusic(MusicItem item) async {
    await localDataSource.updateLocalMusic(item);
    await fetchMusic(query: _currentQuery, refresh: true);
  }

  Future<void> deleteCustomMusic(int id) async {
    await localDataSource.deleteLocalMusic(id);
    await fetchMusic(query: _currentQuery, refresh: true);
  }
}
