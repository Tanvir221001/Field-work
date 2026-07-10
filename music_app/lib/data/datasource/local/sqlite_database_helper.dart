import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class SqliteDatabaseHelper {
  static final SqliteDatabaseHelper instance = SqliteDatabaseHelper._init();
  static Database? _database;

  SqliteDatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('music_app.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT';
    const intType = 'INTEGER';
    const boolType = 'BOOLEAN';

    // Favorites table
    await db.execute('''
CREATE TABLE favorites (
  id $intType PRIMARY KEY,
  title $textType NOT NULL,
  artist $textType NOT NULL,
  album $textType,
  coverUrl $textType,
  genre $textType,
  durationMillis $intType,
  previewUrl $textType
)
''');

    // Playlists table
    await db.execute('''
CREATE TABLE playlists (
  id $idType,
  name $textType NOT NULL,
  coverUrl $textType
)
''');

    // Playlist_Songs map table
    await db.execute('''
CREATE TABLE playlist_songs (
  playlist_id $intType,
  song_id $intType,
  title $textType,
  artist $textType,
  album $textType,
  coverUrl $textType,
  durationMillis $intType,
  previewUrl $textType,
  FOREIGN KEY (playlist_id) REFERENCES playlists (id) ON DELETE CASCADE
)
''');

    // Search History table
    await db.execute('''
CREATE TABLE search_history (
  id $idType,
  query $textType NOT NULL,
  timestamp $intType NOT NULL
)
''');
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
