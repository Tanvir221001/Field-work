import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final settingsProvider = NotifierProvider<SettingsNotifier, SettingsState>(SettingsNotifier.new);

class SettingsState {
  final bool offlineMode;
  final bool highQualityAudio;
  final bool crossfade;

  SettingsState({
    this.offlineMode = false,
    this.highQualityAudio = true,
    this.crossfade = false,
  });

  SettingsState copyWith({
    bool? offlineMode,
    bool? highQualityAudio,
    bool? crossfade,
  }) {
    return SettingsState(
      offlineMode: offlineMode ?? this.offlineMode,
      highQualityAudio: highQualityAudio ?? this.highQualityAudio,
      crossfade: crossfade ?? this.crossfade,
    );
  }
}

class SettingsNotifier extends Notifier<SettingsState> {
  SharedPreferences? _prefs;

  @override
  SettingsState build() {
    _initPrefs();
    return SettingsState();
  }

  Future<void> _initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
    state = SettingsState(
      offlineMode: _prefs?.getBool('offlineMode') ?? false,
      highQualityAudio: _prefs?.getBool('highQualityAudio') ?? true,
      crossfade: _prefs?.getBool('crossfade') ?? false,
    );
  }

  Future<void> toggleOfflineMode(bool value) async {
    state = state.copyWith(offlineMode: value);
    await _prefs?.setBool('offlineMode', value);
  }

  Future<void> toggleHighQualityAudio(bool value) async {
    state = state.copyWith(highQualityAudio: value);
    await _prefs?.setBool('highQualityAudio', value);
  }

  Future<void> toggleCrossfade(bool value) async {
    state = state.copyWith(crossfade: value);
    await _prefs?.setBool('crossfade', value);
  }
}
