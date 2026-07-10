// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'itunes_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ItunesResponse {

 int get resultCount; List<ItunesTrack> get results;
/// Create a copy of ItunesResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ItunesResponseCopyWith<ItunesResponse> get copyWith => _$ItunesResponseCopyWithImpl<ItunesResponse>(this as ItunesResponse, _$identity);

  /// Serializes this ItunesResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ItunesResponse&&(identical(other.resultCount, resultCount) || other.resultCount == resultCount)&&const DeepCollectionEquality().equals(other.results, results));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,resultCount,const DeepCollectionEquality().hash(results));

@override
String toString() {
  return 'ItunesResponse(resultCount: $resultCount, results: $results)';
}


}

/// @nodoc
abstract mixin class $ItunesResponseCopyWith<$Res>  {
  factory $ItunesResponseCopyWith(ItunesResponse value, $Res Function(ItunesResponse) _then) = _$ItunesResponseCopyWithImpl;
@useResult
$Res call({
 int resultCount, List<ItunesTrack> results
});




}
/// @nodoc
class _$ItunesResponseCopyWithImpl<$Res>
    implements $ItunesResponseCopyWith<$Res> {
  _$ItunesResponseCopyWithImpl(this._self, this._then);

  final ItunesResponse _self;
  final $Res Function(ItunesResponse) _then;

/// Create a copy of ItunesResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? resultCount = null,Object? results = null,}) {
  return _then(_self.copyWith(
resultCount: null == resultCount ? _self.resultCount : resultCount // ignore: cast_nullable_to_non_nullable
as int,results: null == results ? _self.results : results // ignore: cast_nullable_to_non_nullable
as List<ItunesTrack>,
  ));
}

}


/// Adds pattern-matching-related methods to [ItunesResponse].
extension ItunesResponsePatterns on ItunesResponse {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ItunesResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ItunesResponse() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ItunesResponse value)  $default,){
final _that = this;
switch (_that) {
case _ItunesResponse():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ItunesResponse value)?  $default,){
final _that = this;
switch (_that) {
case _ItunesResponse() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int resultCount,  List<ItunesTrack> results)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ItunesResponse() when $default != null:
return $default(_that.resultCount,_that.results);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int resultCount,  List<ItunesTrack> results)  $default,) {final _that = this;
switch (_that) {
case _ItunesResponse():
return $default(_that.resultCount,_that.results);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int resultCount,  List<ItunesTrack> results)?  $default,) {final _that = this;
switch (_that) {
case _ItunesResponse() when $default != null:
return $default(_that.resultCount,_that.results);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ItunesResponse implements ItunesResponse {
  const _ItunesResponse({this.resultCount = 0, final  List<ItunesTrack> results = const []}): _results = results;
  factory _ItunesResponse.fromJson(Map<String, dynamic> json) => _$ItunesResponseFromJson(json);

@override@JsonKey() final  int resultCount;
 final  List<ItunesTrack> _results;
@override@JsonKey() List<ItunesTrack> get results {
  if (_results is EqualUnmodifiableListView) return _results;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_results);
}


/// Create a copy of ItunesResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ItunesResponseCopyWith<_ItunesResponse> get copyWith => __$ItunesResponseCopyWithImpl<_ItunesResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ItunesResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ItunesResponse&&(identical(other.resultCount, resultCount) || other.resultCount == resultCount)&&const DeepCollectionEquality().equals(other._results, _results));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,resultCount,const DeepCollectionEquality().hash(_results));

@override
String toString() {
  return 'ItunesResponse(resultCount: $resultCount, results: $results)';
}


}

/// @nodoc
abstract mixin class _$ItunesResponseCopyWith<$Res> implements $ItunesResponseCopyWith<$Res> {
  factory _$ItunesResponseCopyWith(_ItunesResponse value, $Res Function(_ItunesResponse) _then) = __$ItunesResponseCopyWithImpl;
@override @useResult
$Res call({
 int resultCount, List<ItunesTrack> results
});




}
/// @nodoc
class __$ItunesResponseCopyWithImpl<$Res>
    implements _$ItunesResponseCopyWith<$Res> {
  __$ItunesResponseCopyWithImpl(this._self, this._then);

  final _ItunesResponse _self;
  final $Res Function(_ItunesResponse) _then;

/// Create a copy of ItunesResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? resultCount = null,Object? results = null,}) {
  return _then(_ItunesResponse(
resultCount: null == resultCount ? _self.resultCount : resultCount // ignore: cast_nullable_to_non_nullable
as int,results: null == results ? _self._results : results // ignore: cast_nullable_to_non_nullable
as List<ItunesTrack>,
  ));
}


}


/// @nodoc
mixin _$ItunesTrack {

 int? get trackId; String? get trackName; String? get artistName; String? get collectionName; String? get artworkUrl100; String? get primaryGenreName; int? get trackTimeMillis; String? get previewUrl;
/// Create a copy of ItunesTrack
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ItunesTrackCopyWith<ItunesTrack> get copyWith => _$ItunesTrackCopyWithImpl<ItunesTrack>(this as ItunesTrack, _$identity);

  /// Serializes this ItunesTrack to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ItunesTrack&&(identical(other.trackId, trackId) || other.trackId == trackId)&&(identical(other.trackName, trackName) || other.trackName == trackName)&&(identical(other.artistName, artistName) || other.artistName == artistName)&&(identical(other.collectionName, collectionName) || other.collectionName == collectionName)&&(identical(other.artworkUrl100, artworkUrl100) || other.artworkUrl100 == artworkUrl100)&&(identical(other.primaryGenreName, primaryGenreName) || other.primaryGenreName == primaryGenreName)&&(identical(other.trackTimeMillis, trackTimeMillis) || other.trackTimeMillis == trackTimeMillis)&&(identical(other.previewUrl, previewUrl) || other.previewUrl == previewUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,trackId,trackName,artistName,collectionName,artworkUrl100,primaryGenreName,trackTimeMillis,previewUrl);

@override
String toString() {
  return 'ItunesTrack(trackId: $trackId, trackName: $trackName, artistName: $artistName, collectionName: $collectionName, artworkUrl100: $artworkUrl100, primaryGenreName: $primaryGenreName, trackTimeMillis: $trackTimeMillis, previewUrl: $previewUrl)';
}


}

/// @nodoc
abstract mixin class $ItunesTrackCopyWith<$Res>  {
  factory $ItunesTrackCopyWith(ItunesTrack value, $Res Function(ItunesTrack) _then) = _$ItunesTrackCopyWithImpl;
@useResult
$Res call({
 int? trackId, String? trackName, String? artistName, String? collectionName, String? artworkUrl100, String? primaryGenreName, int? trackTimeMillis, String? previewUrl
});




}
/// @nodoc
class _$ItunesTrackCopyWithImpl<$Res>
    implements $ItunesTrackCopyWith<$Res> {
  _$ItunesTrackCopyWithImpl(this._self, this._then);

  final ItunesTrack _self;
  final $Res Function(ItunesTrack) _then;

/// Create a copy of ItunesTrack
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? trackId = freezed,Object? trackName = freezed,Object? artistName = freezed,Object? collectionName = freezed,Object? artworkUrl100 = freezed,Object? primaryGenreName = freezed,Object? trackTimeMillis = freezed,Object? previewUrl = freezed,}) {
  return _then(_self.copyWith(
trackId: freezed == trackId ? _self.trackId : trackId // ignore: cast_nullable_to_non_nullable
as int?,trackName: freezed == trackName ? _self.trackName : trackName // ignore: cast_nullable_to_non_nullable
as String?,artistName: freezed == artistName ? _self.artistName : artistName // ignore: cast_nullable_to_non_nullable
as String?,collectionName: freezed == collectionName ? _self.collectionName : collectionName // ignore: cast_nullable_to_non_nullable
as String?,artworkUrl100: freezed == artworkUrl100 ? _self.artworkUrl100 : artworkUrl100 // ignore: cast_nullable_to_non_nullable
as String?,primaryGenreName: freezed == primaryGenreName ? _self.primaryGenreName : primaryGenreName // ignore: cast_nullable_to_non_nullable
as String?,trackTimeMillis: freezed == trackTimeMillis ? _self.trackTimeMillis : trackTimeMillis // ignore: cast_nullable_to_non_nullable
as int?,previewUrl: freezed == previewUrl ? _self.previewUrl : previewUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ItunesTrack].
extension ItunesTrackPatterns on ItunesTrack {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ItunesTrack value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ItunesTrack() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ItunesTrack value)  $default,){
final _that = this;
switch (_that) {
case _ItunesTrack():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ItunesTrack value)?  $default,){
final _that = this;
switch (_that) {
case _ItunesTrack() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int? trackId,  String? trackName,  String? artistName,  String? collectionName,  String? artworkUrl100,  String? primaryGenreName,  int? trackTimeMillis,  String? previewUrl)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ItunesTrack() when $default != null:
return $default(_that.trackId,_that.trackName,_that.artistName,_that.collectionName,_that.artworkUrl100,_that.primaryGenreName,_that.trackTimeMillis,_that.previewUrl);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int? trackId,  String? trackName,  String? artistName,  String? collectionName,  String? artworkUrl100,  String? primaryGenreName,  int? trackTimeMillis,  String? previewUrl)  $default,) {final _that = this;
switch (_that) {
case _ItunesTrack():
return $default(_that.trackId,_that.trackName,_that.artistName,_that.collectionName,_that.artworkUrl100,_that.primaryGenreName,_that.trackTimeMillis,_that.previewUrl);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int? trackId,  String? trackName,  String? artistName,  String? collectionName,  String? artworkUrl100,  String? primaryGenreName,  int? trackTimeMillis,  String? previewUrl)?  $default,) {final _that = this;
switch (_that) {
case _ItunesTrack() when $default != null:
return $default(_that.trackId,_that.trackName,_that.artistName,_that.collectionName,_that.artworkUrl100,_that.primaryGenreName,_that.trackTimeMillis,_that.previewUrl);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ItunesTrack extends ItunesTrack {
  const _ItunesTrack({this.trackId, this.trackName, this.artistName, this.collectionName, this.artworkUrl100, this.primaryGenreName, this.trackTimeMillis, this.previewUrl}): super._();
  factory _ItunesTrack.fromJson(Map<String, dynamic> json) => _$ItunesTrackFromJson(json);

@override final  int? trackId;
@override final  String? trackName;
@override final  String? artistName;
@override final  String? collectionName;
@override final  String? artworkUrl100;
@override final  String? primaryGenreName;
@override final  int? trackTimeMillis;
@override final  String? previewUrl;

/// Create a copy of ItunesTrack
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ItunesTrackCopyWith<_ItunesTrack> get copyWith => __$ItunesTrackCopyWithImpl<_ItunesTrack>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ItunesTrackToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ItunesTrack&&(identical(other.trackId, trackId) || other.trackId == trackId)&&(identical(other.trackName, trackName) || other.trackName == trackName)&&(identical(other.artistName, artistName) || other.artistName == artistName)&&(identical(other.collectionName, collectionName) || other.collectionName == collectionName)&&(identical(other.artworkUrl100, artworkUrl100) || other.artworkUrl100 == artworkUrl100)&&(identical(other.primaryGenreName, primaryGenreName) || other.primaryGenreName == primaryGenreName)&&(identical(other.trackTimeMillis, trackTimeMillis) || other.trackTimeMillis == trackTimeMillis)&&(identical(other.previewUrl, previewUrl) || other.previewUrl == previewUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,trackId,trackName,artistName,collectionName,artworkUrl100,primaryGenreName,trackTimeMillis,previewUrl);

@override
String toString() {
  return 'ItunesTrack(trackId: $trackId, trackName: $trackName, artistName: $artistName, collectionName: $collectionName, artworkUrl100: $artworkUrl100, primaryGenreName: $primaryGenreName, trackTimeMillis: $trackTimeMillis, previewUrl: $previewUrl)';
}


}

/// @nodoc
abstract mixin class _$ItunesTrackCopyWith<$Res> implements $ItunesTrackCopyWith<$Res> {
  factory _$ItunesTrackCopyWith(_ItunesTrack value, $Res Function(_ItunesTrack) _then) = __$ItunesTrackCopyWithImpl;
@override @useResult
$Res call({
 int? trackId, String? trackName, String? artistName, String? collectionName, String? artworkUrl100, String? primaryGenreName, int? trackTimeMillis, String? previewUrl
});




}
/// @nodoc
class __$ItunesTrackCopyWithImpl<$Res>
    implements _$ItunesTrackCopyWith<$Res> {
  __$ItunesTrackCopyWithImpl(this._self, this._then);

  final _ItunesTrack _self;
  final $Res Function(_ItunesTrack) _then;

/// Create a copy of ItunesTrack
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? trackId = freezed,Object? trackName = freezed,Object? artistName = freezed,Object? collectionName = freezed,Object? artworkUrl100 = freezed,Object? primaryGenreName = freezed,Object? trackTimeMillis = freezed,Object? previewUrl = freezed,}) {
  return _then(_ItunesTrack(
trackId: freezed == trackId ? _self.trackId : trackId // ignore: cast_nullable_to_non_nullable
as int?,trackName: freezed == trackName ? _self.trackName : trackName // ignore: cast_nullable_to_non_nullable
as String?,artistName: freezed == artistName ? _self.artistName : artistName // ignore: cast_nullable_to_non_nullable
as String?,collectionName: freezed == collectionName ? _self.collectionName : collectionName // ignore: cast_nullable_to_non_nullable
as String?,artworkUrl100: freezed == artworkUrl100 ? _self.artworkUrl100 : artworkUrl100 // ignore: cast_nullable_to_non_nullable
as String?,primaryGenreName: freezed == primaryGenreName ? _self.primaryGenreName : primaryGenreName // ignore: cast_nullable_to_non_nullable
as String?,trackTimeMillis: freezed == trackTimeMillis ? _self.trackTimeMillis : trackTimeMillis // ignore: cast_nullable_to_non_nullable
as int?,previewUrl: freezed == previewUrl ? _self.previewUrl : previewUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
