import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class AudioPlayerUtil {
  static final AudioPlayer _player = AudioPlayer();
  static bool _isPlaying = false;
  static String? _currentAudio;

  static bool get isPlaying => _isPlaying;
  static String? get currentAudio => _currentAudio;

  static Future<void> play(String audioPath) async {
    try {
      if (_isPlaying && _currentAudio == audioPath) {
        await stop();
        return;
      }

      await stop();
      await _player.play(AssetSource(audioPath));
      _isPlaying = true;
      _currentAudio = audioPath;
    } catch (e) {
      debugPrint('Error playing audio: $e');
    }
  }

  static Future<void> stop() async {
    try {
      await _player.stop();
      _isPlaying = false;
      _currentAudio = null;
    } catch (e) {
      debugPrint('Error stopping audio: $e');
    }
  }

  static Future<void> pause() async {
    try {
      await _player.pause();
      _isPlaying = false;
    } catch (e) {
      debugPrint('Error pausing audio: $e');
    }
  }

  static Future<void> resume() async {
    try {
      await _player.resume();
      _isPlaying = true;
    } catch (e) {
      debugPrint('Error resuming audio: $e');
    }
  }

  static void dispose() {
    _player.dispose();
  }

  static Stream<PlayerState> get onPlayerStateChanged => _player.onPlayerStateChanged;
  static Stream<Duration> get onDurationChanged => _player.onDurationChanged;
  static Stream<Duration> get onPositionChanged => _player.onPositionChanged;
}