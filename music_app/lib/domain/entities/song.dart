import 'package:equatable/equatable.dart';

class Song extends Equatable {
  final int id;
  final String title;
  final String artist;
  final String? album;
  final String? coverUrl;
  final String? genre;
  final int? durationMillis;
  final String? previewUrl;
  final bool isFavorite;

  const Song({
    required this.id,
    required this.title,
    required this.artist,
    this.album,
    this.coverUrl,
    this.genre,
    this.durationMillis,
    this.previewUrl,
    this.isFavorite = false,
  });

  Song copyWith({
    int? id,
    String? title,
    String? artist,
    String? album,
    String? coverUrl,
    String? genre,
    int? durationMillis,
    String? previewUrl,
    bool? isFavorite,
  }) {
    return Song(
      id: id ?? this.id,
      title: title ?? this.title,
      artist: artist ?? this.artist,
      album: album ?? this.album,
      coverUrl: coverUrl ?? this.coverUrl,
      genre: genre ?? this.genre,
      durationMillis: durationMillis ?? this.durationMillis,
      previewUrl: previewUrl ?? this.previewUrl,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  @override
  List<Object?> get props => [
        id,
        title,
        artist,
        album,
        coverUrl,
        genre,
        durationMillis,
        previewUrl,
        isFavorite,
      ];
}
