import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';
import '../model/music_item.dart';

class LocalDataSource {
  static Database? _database;
  static const String tableName = 'music';

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    if (kIsWeb) {
      databaseFactory = databaseFactoryFfiWeb;
      return await openDatabase(
        'music_app.db',
        version: 5,
        onCreate: _onCreate,
        onUpgrade: _onUpgrade,
      );
    } else {
      if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
        sqfliteFfiInit();
        databaseFactory = databaseFactoryFfi;
      }
      final dbPath = await getDatabasesPath();
      final path = join(dbPath, 'music_app.db');

      return await openDatabase(
        path,
        version: 5,
        onCreate: _onCreate,
        onUpgrade: _onUpgrade,
      );
    }
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $tableName (
        id INTEGER PRIMARY KEY,
        title TEXT,
        subtitle TEXT,
        description TEXT,
        imageUrl TEXT,
        isLocal INTEGER,
        previewUrl TEXT,
        durationMillis INTEGER
      )
    ''');
    
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT UNIQUE,
        password TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE playlists (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER,
        name TEXT,
        FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE
      )
    ''');

    await db.execute('''
      CREATE TABLE playlist_tracks (
        playlist_id INTEGER,
        track_id INTEGER,
        FOREIGN KEY (playlist_id) REFERENCES playlists (id) ON DELETE CASCADE,
        FOREIGN KEY (track_id) REFERENCES $tableName (id) ON DELETE CASCADE,
        PRIMARY KEY (playlist_id, track_id)
      )
    ''');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 5) {
      await db.execute('''
        CREATE TABLE users (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          username TEXT UNIQUE,
          password TEXT
        )
      ''');

      await db.execute('''
        CREATE TABLE playlists (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          user_id INTEGER,
          name TEXT,
          FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE
        )
      ''');

      await db.execute('''
        CREATE TABLE playlist_tracks (
          playlist_id INTEGER,
          track_id INTEGER,
          FOREIGN KEY (playlist_id) REFERENCES playlists (id) ON DELETE CASCADE,
          FOREIGN KEY (track_id) REFERENCES $tableName (id) ON DELETE CASCADE,
          PRIMARY KEY (playlist_id, track_id)
        )
      ''');
    }
  }

  Future<void> cacheMusicList(List<MusicItem> items) async {
    final db = await database;
    Batch batch = db.batch();
    for (var item in items) {
      if (!item.isLocal) { // Only cache API items, don't overwrite local user items blindly here
        batch.insert(
          tableName,
          item.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
    }
    await batch.commit(noResult: true);
  }

  Future<List<MusicItem>> getCachedMusic({int limit = 20, int offset = 0}) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      tableName,
      limit: limit,
      offset: offset,
    );
    return maps.map((map) => MusicItem.fromMap(map)).toList();
  }

  Future<List<MusicItem>> searchCachedMusic(String query, {int limit = 20, int offset = 0}) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      tableName,
      where: 'title LIKE ? OR subtitle LIKE ?',
      whereArgs: ['%$query%', '%$query%'],
      limit: limit,
      offset: offset,
    );
    return maps.map((map) => MusicItem.fromMap(map)).toList();
  }

  // CRUD Operations for local items
  Future<int> insertLocalMusic(MusicItem item) async {
    final db = await database;
    return await db.insert(
      tableName,
      item.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> updateLocalMusic(MusicItem item) async {
    final db = await database;
    return await db.update(
      tableName,
      item.toMap(),
      where: 'id = ?',
      whereArgs: [item.id],
    );
  }

  Future<int> deleteLocalMusic(int id) async {
    final db = await database;
    return await db.delete(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // --- USER AUTHENTICATION ---
  Future<int> registerUser(String username, String password) async {
    final db = await database;
    return await db.insert(
      'users',
      {'username': username, 'password': password},
      conflictAlgorithm: ConflictAlgorithm.abort,
    );
  }

  Future<Map<String, dynamic>?> loginUser(String username, String password) async {
    final db = await database;
    final List<Map<String, dynamic>> result = await db.query(
      'users',
      where: 'username = ? AND password = ?',
      whereArgs: [username, password],
    );
    if (result.isNotEmpty) {
      return result.first;
    }
    return null;
  }

  // --- PLAYLISTS ---
  Future<int> createPlaylist(int userId, String name) async {
    final db = await database;
    return await db.insert(
      'playlists',
      {'user_id': userId, 'name': name},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> getUserPlaylists(int userId) async {
    final db = await database;
    return await db.query(
      'playlists',
      where: 'user_id = ?',
      whereArgs: [userId],
    );
  }

  Future<void> deletePlaylist(int playlistId) async {
    final db = await database;
    await db.delete('playlists', where: 'id = ?', whereArgs: [playlistId]);
  }

  // --- PLAYLIST TRACKS ---
  Future<void> addTrackToPlaylist(int playlistId, int trackId) async {
    final db = await database;
    await db.insert(
      'playlist_tracks',
      {'playlist_id': playlistId, 'track_id': trackId},
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
  }

  Future<void> removeTrackFromPlaylist(int playlistId, int trackId) async {
    final db = await database;
    await db.delete(
      'playlist_tracks',
      where: 'playlist_id = ? AND track_id = ?',
      whereArgs: [playlistId, trackId],
    );
  }

  Future<List<MusicItem>> getPlaylistTracks(int playlistId) async {
    final db = await database;
    final List<Map<String, dynamic>> result = await db.rawQuery('''
      SELECT m.* 
      FROM $tableName m
      INNER JOIN playlist_tracks pt ON m.id = pt.track_id
      WHERE pt.playlist_id = ?
    ''', [playlistId]);
    return result.map((map) => MusicItem.fromMap(map)).toList();
  }
}
