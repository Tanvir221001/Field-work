import 'package:flutter/foundation.dart';
import 'package:audioplayers/audioplayers.dart';
import 'audio_player_stub.dart' if (dart.library.html) 'audio_player_web.dart';

class AudioHelper {
  final AudioPlayer _nativePlayer = AudioPlayer();
  WebAudioPlayer? _webPlayer;

  AudioHelper() {
    if (kIsWeb) {
      _webPlayer = WebAudioPlayer();
    }
  }

  Future<void> play(String url) async {
    if (kIsWeb) {
      _webPlayer?.play(url);
    } else {
      await _nativePlayer.play(UrlSource(url));
    }
  }

  Future<void> pause() async {
    if (kIsWeb) {
      _webPlayer?.pause();
    } else {
      await _nativePlayer.pause();
    }
  }

  void dispose() {
    _nativePlayer.dispose();
    _webPlayer?.dispose();
  }
}
