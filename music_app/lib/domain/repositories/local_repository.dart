import '../entities/song.dart';
import '../entities/playlist.dart';

abstract class LocalRepository {
  // Favorites
  Future<List<Song>> getFavorites();
  Future<void> toggleFavorite(Song song);
  Future<bool> isFavorite(int songId);

  // Playlists
  Future<List<Playlist>> getPlaylists();
  Future<void> createPlaylist(String name);
  Future<void> deletePlaylist(int id);
  Future<void> updatePlaylistName(int id, String newName);
  Future<void> addSongToPlaylist(int playlistId, Song song);
  Future<void> removeSongFromPlaylist(int playlistId, int songId);
  
  // Cache / Offline
  Future<void> cacheSongs(List<Song> songs);
  Future<List<Song>> getCachedSongs();

  // Search History
  Future<List<String>> getSearchHistory();
  Future<void> addSearchQuery(String query);
  Future<void> clearSearchHistory();
}
