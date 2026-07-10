import 'package:sqflite/sqflite.dart';
import '../../domain/entities/song.dart';
import '../../domain/entities/playlist.dart';
import '../../domain/repositories/local_repository.dart';
import '../datasource/local/sqlite_database_helper.dart';

class LocalRepositoryImpl implements LocalRepository {
  final SqliteDatabaseHelper dbHelper;

  LocalRepositoryImpl(this.dbHelper);

  // --- Favorites ---

  @override
  Future<List<Song>> getFavorites() async {
    final db = await dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('favorites');
    
    return maps.map((map) => Song(
      id: map['id'],
      title: map['title'],
      artist: map['artist'],
      album: map['album'],
      coverUrl: map['coverUrl'],
      genre: map['genre'],
      durationMillis: map['durationMillis'],
      previewUrl: map['previewUrl'],
      isFavorite: true,
    )).toList();
  }

  @override
  Future<void> toggleFavorite(Song song) async {
    final db = await dbHelper.database;
    final isFav = await isFavorite(song.id);
    
    if (isFav) {
      await db.delete('favorites', where: 'id = ?', whereArgs: [song.id]);
    } else {
      await db.insert('favorites', {
        'id': song.id,
        'title': song.title,
        'artist': song.artist,
        'album': song.album,
        'coverUrl': song.coverUrl,
        'genre': song.genre,
        'durationMillis': song.durationMillis,
        'previewUrl': song.previewUrl,
      }, conflictAlgorithm: ConflictAlgorithm.replace);
    }
  }

  @override
  Future<bool> isFavorite(int songId) async {
    final db = await dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'favorites',
      columns: ['id'],
      where: 'id = ?',
      whereArgs: [songId],
    );
    return maps.isNotEmpty;
  }

  // --- Playlists ---

  @override
  Future<List<Playlist>> getPlaylists() async {
    final db = await dbHelper.database;
    final List<Map<String, dynamic>> playlistMaps = await db.query('playlists');
    
    List<Playlist> playlists = [];
    for (var pMap in playlistMaps) {
      final int pId = pMap['id'];
      // Get songs for this playlist
      final List<Map<String, dynamic>> songMaps = await db.query(
        'playlist_songs',
        where: 'playlist_id = ?',
        whereArgs: [pId],
      );
      
      List<Song> songs = songMaps.map((map) => Song(
        id: map['song_id'],
        title: map['title'],
        artist: map['artist'],
        album: map['album'],
        coverUrl: map['coverUrl'],
        durationMillis: map['durationMillis'],
        previewUrl: map['previewUrl'],
      )).toList();
      
      playlists.add(Playlist(
        id: pId,
        name: pMap['name'],
        coverUrl: pMap['coverUrl'],
        songCount: songs.length,
        songs: songs,
      ));
    }
    return playlists;
  }

  @override
  Future<void> createPlaylist(String name) async {
    final db = await dbHelper.database;
    await db.insert('playlists', {
      'name': name,
    });
  }

  @override
  Future<void> deletePlaylist(int id) async {
    final db = await dbHelper.database;
    await db.delete('playlists', where: 'id = ?', whereArgs: [id]);
    // Note: ON DELETE CASCADE will handle removing songs
  }

  @override
  Future<void> updatePlaylistName(int id, String newName) async {
    final db = await dbHelper.database;
    await db.update(
      'playlists',
      {'name': newName},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  @override
  Future<void> addSongToPlaylist(int playlistId, Song song) async {
    final db = await dbHelper.database;
    // Check if song already exists in playlist
    final existing = await db.query(
      'playlist_songs',
      where: 'playlist_id = ? AND song_id = ?',
      whereArgs: [playlistId, song.id],
    );
    if (existing.isNotEmpty) return; // already in playlist
    
    await db.insert('playlist_songs', {
      'playlist_id': playlistId,
      'song_id': song.id,
      'title': song.title,
      'artist': song.artist,
      'album': song.album,
      'coverUrl': song.coverUrl,
      'durationMillis': song.durationMillis,
      'previewUrl': song.previewUrl,
    });
    
    // Update playlist cover with the latest added song cover
    await db.update(
      'playlists',
      {'coverUrl': song.coverUrl},
      where: 'id = ?',
      whereArgs: [playlistId],
    );
  }

  @override
  Future<void> removeSongFromPlaylist(int playlistId, int songId) async {
    final db = await dbHelper.database;
    await db.delete(
      'playlist_songs',
      where: 'playlist_id = ? AND song_id = ?',
      whereArgs: [playlistId, songId],
    );
  }

  // --- Search History & Cache (Stubbed for now, simple implementation) ---

  @override
  Future<void> cacheSongs(List<Song> songs) async {
    // Advanced caching logic would go here
  }

  @override
  Future<List<Song>> getCachedSongs() async {
    return [];
  }

  @override
  Future<List<String>> getSearchHistory() async {
    final db = await dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'search_history',
      orderBy: 'timestamp DESC',
      limit: 10,
    );
    return maps.map((e) => e['query'] as String).toList();
  }

  @override
  Future<void> addSearchQuery(String query) async {
    if (query.trim().isEmpty) return;
    final db = await dbHelper.database;
    
    // Delete if exists to avoid duplicates
    await db.delete('search_history', where: 'query = ?', whereArgs: [query]);
    
    // Insert new
    await db.insert('search_history', {
      'query': query,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    });
  }

  @override
  Future<void> clearSearchHistory() async {
    final db = await dbHelper.database;
    await db.delete('search_history');
  }
}
