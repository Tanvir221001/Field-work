import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:audioplayers/audioplayers.dart';
import '../../domain/entities/song.dart';

final audioPlayerProvider = Provider<AudioPlayer>((ref) {
  final player = AudioPlayer();
  ref.onDispose(() => player.dispose());
  return player;
});

final playerStateProvider = NotifierProvider<PlayerStateNotifier, PlayerStateData>(PlayerStateNotifier.new);

class PlayerStateData {
  final Song? currentSong;
  final bool isPlaying;
  final Duration position;
  final Duration duration;

  PlayerStateData({
    this.currentSong,
    this.isPlaying = false,
    this.position = Duration.zero,
    this.duration = Duration.zero,
  });

  PlayerStateData copyWith({
    Song? currentSong,
    bool? isPlaying,
    Duration? position,
    Duration? duration,
  }) {
    return PlayerStateData(
      currentSong: currentSong ?? this.currentSong,
      isPlaying: isPlaying ?? this.isPlaying,
      position: position ?? this.position,
      duration: duration ?? this.duration,
    );
  }
}

class PlayerStateNotifier extends Notifier<PlayerStateData> {
  late final AudioPlayer _player;

  @override
  PlayerStateData build() {
    _player = ref.watch(audioPlayerProvider);
    _initStreams();
    return PlayerStateData();
  }

  void _initStreams() {
    _player.onPlayerStateChanged.listen((pState) {
      state = state.copyWith(isPlaying: pState == PlayerState.playing);
    });
    
    _player.onPositionChanged.listen((position) {
      state = state.copyWith(position: position);
    });

    _player.onDurationChanged.listen((duration) {
      state = state.copyWith(duration: duration);
    });
    
    _player.onPlayerComplete.listen((_) {
      state = state.copyWith(isPlaying: false, position: Duration.zero);
    });
  }

  Future<void> playSong(Song song) async {
    if (song.previewUrl == null) return;
    
    if (state.currentSong?.id != song.id) {
      // Stop current if new song
      await _player.stop();
      state = state.copyWith(currentSong: song, position: Duration.zero);
      await _player.play(UrlSource(song.previewUrl!));
    } else {
      // Toggle play/pause if same song
      if (state.isPlaying) {
        await _player.pause();
      } else {
        await _player.resume();
      }
    }
  }

  Future<void> pause() async {
    await _player.pause();
  }

  Future<void> resume() async {
    await _player.resume();
  }
  
  Future<void> seek(Duration position) async {
    await _player.seek(position);
  }
}
