import 'package:flutter/material.dart';
import '../data/datasource/local_datasource.dart';
import '../data/model/playlist.dart';
import '../data/model/music_item.dart';

class PlaylistProvider extends ChangeNotifier {
  final LocalDataSource localDataSource = LocalDataSource();
  
  List<Playlist> _playlists = [];
  bool _isLoading = false;
  String _error = '';

  List<Playlist> get playlists => _playlists;
  bool get isLoading => _isLoading;
  String get error => _error;

  Future<void> loadPlaylists(int userId) async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      final maps = await localDataSource.getUserPlaylists(userId);
      _playlists = maps.map((map) => Playlist.fromMap(map)).toList();
    } catch (e) {
      _error = 'Failed to load playlists: $e';
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> createPlaylist(int userId, String name) async {
    try {
      await localDataSource.createPlaylist(userId, name);
      await loadPlaylists(userId);
    } catch (e) {
      _error = 'Failed to create playlist: $e';
      notifyListeners();
    }
  }

  Future<void> deletePlaylist(int userId, int playlistId) async {
    try {
      await localDataSource.deletePlaylist(playlistId);
      await loadPlaylists(userId);
    } catch (e) {
      _error = 'Failed to delete playlist: $e';
      notifyListeners();
    }
  }

  Future<void> addTrackToPlaylist(int playlistId, int trackId) async {
    try {
      await localDataSource.addTrackToPlaylist(playlistId, trackId);
    } catch (e) {
      // Ignored for now, usually duplicate entry
    }
  }

  Future<void> removeTrackFromPlaylist(int playlistId, int trackId) async {
    try {
      await localDataSource.removeTrackFromPlaylist(playlistId, trackId);
    } catch (e) {
      // Ignored
    }
  }

  Future<List<MusicItem>> getPlaylistTracks(int playlistId) async {
    try {
      return await localDataSource.getPlaylistTracks(playlistId);
    } catch (e) {
      return [];
    }
  }
}
