// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'itunes_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ItunesResponse _$ItunesResponseFromJson(Map<String, dynamic> json) =>
    _ItunesResponse(
      resultCount: (json['resultCount'] as num?)?.toInt() ?? 0,
      results:
          (json['results'] as List<dynamic>?)
              ?.map((e) => ItunesTrack.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$ItunesResponseToJson(_ItunesResponse instance) =>
    <String, dynamic>{
      'resultCount': instance.resultCount,
      'results': instance.results,
    };

_ItunesTrack _$ItunesTrackFromJson(Map<String, dynamic> json) => _ItunesTrack(
  trackId: (json['trackId'] as num?)?.toInt(),
  trackName: json['trackName'] as String?,
  artistName: json['artistName'] as String?,
  collectionName: json['collectionName'] as String?,
  artworkUrl100: json['artworkUrl100'] as String?,
  primaryGenreName: json['primaryGenreName'] as String?,
  trackTimeMillis: (json['trackTimeMillis'] as num?)?.toInt(),
  previewUrl: json['previewUrl'] as String?,
);

Map<String, dynamic> _$ItunesTrackToJson(_ItunesTrack instance) =>
    <String, dynamic>{
      'trackId': instance.trackId,
      'trackName': instance.trackName,
      'artistName': instance.artistName,
      'collectionName': instance.collectionName,
      'artworkUrl100': instance.artworkUrl100,
      'primaryGenreName': instance.primaryGenreName,
      'trackTimeMillis': instance.trackTimeMillis,
      'previewUrl': instance.previewUrl,
    };
