import '../entities/song.dart';

abstract class MusicRepository {
  Future<List<Song>> searchSongs(String query, {int limit = 50});
  Future<List<Song>> getTrendingSongs(); // For home screen
  Future<List<Song>> getNewReleases();   // For home screen
}
