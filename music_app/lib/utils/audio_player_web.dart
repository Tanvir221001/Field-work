import 'dart:html' as html;

class WebAudioPlayer {
  html.AudioElement? _audio;

  void play(String url) {
    if (_audio == null) {
      _audio = html.AudioElement(url);
    } else {
      _audio!.src = url;
    }
    _audio!.play();
  }

  void pause() {
    _audio?.pause();
  }

  void stop() {
    _audio?.pause();
    _audio?.currentTime = 0;
  }

  void dispose() {
    _audio?.remove();
  }
}
