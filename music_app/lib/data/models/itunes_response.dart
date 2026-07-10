import '../../domain/entities/song.dart';

class ItunesResponse {
  final int resultCount;
  final List<ItunesTrack> results;

  ItunesResponse({
    this.resultCount = 0,
    this.results = const [],
  });

  factory ItunesResponse.fromJson(Map<String, dynamic> json) {
    return ItunesResponse(
      resultCount: json['resultCount'] as int? ?? 0,
      results: (json['results'] as List<dynamic>?)
              ?.map((e) => ItunesTrack.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );
  }
}

class ItunesTrack {
  final int? trackId;
  final String? trackName;
  final String? artistName;
  final String? collectionName;
  final String? artworkUrl100;
  final String? primaryGenreName;
  final int? trackTimeMillis;
  final String? previewUrl;

  ItunesTrack({
    this.trackId,
    this.trackName,
    this.artistName,
    this.collectionName,
    this.artworkUrl100,
    this.primaryGenreName,
    this.trackTimeMillis,
    this.previewUrl,
  });

  factory ItunesTrack.fromJson(Map<String, dynamic> json) {
    return ItunesTrack(
      trackId: json['trackId'] as int?,
      trackName: json['trackName'] as String?,
      artistName: json['artistName'] as String?,
      collectionName: json['collectionName'] as String?,
      artworkUrl100: json['artworkUrl100'] as String?,
      primaryGenreName: json['primaryGenreName'] as String?,
      trackTimeMillis: json['trackTimeMillis'] as int?,
      previewUrl: json['previewUrl'] as String?,
    );
  }

  Song toEntity() {
    return Song(
      id: trackId ?? 0,
      title: trackName ?? 'Unknown Title',
      artist: artistName ?? 'Unknown Artist',
      album: collectionName,
      coverUrl: artworkUrl100?.replaceAll('100x100bb', '600x600bb'), // Get high-res artwork
      genre: primaryGenreName,
      durationMillis: trackTimeMillis,
      previewUrl: previewUrl,
    );
  }
}
