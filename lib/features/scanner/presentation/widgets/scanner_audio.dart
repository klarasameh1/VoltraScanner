import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';

class ScannerAudio {
  final AudioPlayer _player = AudioPlayer();

  Future<void> initAudio() async {
    try {
      await _player.setSource(AssetSource('sounds/success.mp3'));
      await _player.setSource(AssetSource('sounds/failed.mp3'));
    } catch (e) {
      debugPrint('Audio init error: $e');
    }
  }

  Future<void> playFeedback(bool success) async {
    try {
      await _player.stop();
      await _player.play(AssetSource(success ? 'sounds/success.mp3' : 'sounds/failed.mp3'));
    } catch (e) {
      debugPrint('Audio playback error: $e');
    }
  }

  void dispose() => _player.dispose();
}