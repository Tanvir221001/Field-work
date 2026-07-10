import '../../domain/entities/song.dart';
import '../../domain/repositories/music_repository.dart';
import '../datasource/remote/itunes_remote_datasource.dart';

class MusicRepositoryImpl implements MusicRepository {
  final ItunesRemoteDatasource remoteDatasource;

  MusicRepositoryImpl(this.remoteDatasource);

  @override
  Future<List<Song>> searchSongs(String query, {int limit = 50}) async {
    final response = await remoteDatasource.searchSongs(query, limit: limit);
    return response.results.map((track) => track.toEntity()).toList();
  }

  @override
  Future<List<Song>> getTrendingSongs() async {
    final futures = [
      remoteDatasource.searchSongs('pop hits', limit: 200),
      remoteDatasource.searchSongs('billboard', limit: 200),
      remoteDatasource.searchSongs('top 100', limit: 200),
    ];
    final responses = await Future.wait(futures);
    final allTracks = responses.expand((r) => r.results).toList();
    final unique = {for (var t in allTracks) t.trackId: t}.values;
    return unique.map((track) => track.toEntity()).toList();
  }

  @override
  Future<List<Song>> getNewReleases() async {
    final futures = [
      remoteDatasource.searchSongs('new release', limit: 200),
      remoteDatasource.searchSongs('latest trending', limit: 200),
    ];
    final responses = await Future.wait(futures);
    final allTracks = responses.expand((r) => r.results).toList();
    final unique = {for (var t in allTracks) t.trackId: t}.values;
    return unique.map((track) => track.toEntity()).toList();
  }
}
