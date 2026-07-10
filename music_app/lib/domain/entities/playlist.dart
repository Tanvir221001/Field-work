import 'package:equatable/equatable.dart';
import 'song.dart';

class Playlist extends Equatable {
  final int id;
  final String name;
  final String? coverUrl;
  final int songCount;
  final List<Song> songs;

  const Playlist({
    required this.id,
    required this.name,
    this.coverUrl,
    this.songCount = 0,
    this.songs = const [],
  });

  Playlist copyWith({
    int? id,
    String? name,
    String? coverUrl,
    int? songCount,
    List<Song>? songs,
  }) {
    return Playlist(
      id: id ?? this.id,
      name: name ?? this.name,
      coverUrl: coverUrl ?? this.coverUrl,
      songCount: songCount ?? this.songCount,
      songs: songs ?? this.songs,
    );
  }

  @override
  List<Object?> get props => [id, name, coverUrl, songCount, songs];
}
