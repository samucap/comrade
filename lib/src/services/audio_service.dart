import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';

/// Audio playback service for recorded audio and AI responses
class AudioService {
  final AudioPlayer _player = AudioPlayer();
  
  bool _isPlaying = false;
  String? _currentPath;
  
  /// Get current playing state
  bool get isPlaying => _isPlaying;
  
  /// Get current audio path
  String? get currentPath => _currentPath;

  /// Play audio from file path
  Future<void> playAudio(String filePath) async {
    try {
      _currentPath = filePath;
      _isPlaying = true;
      
      await _player.play(DeviceFileSource(filePath));
      
      // Listen for completion
      _player.onPlayerComplete.listen((_) {
        _isPlaying = false;
        _currentPath = null;
      });
    } catch (e) {
      debugPrint('Error playing audio: $e');
      _isPlaying = false;
      _currentPath = null;
    }
  }

  /// Stop current playback
  Future<void> stop() async {
    try {
      await _player.stop();
      _isPlaying = false;
      _currentPath = null;
    } catch (e) {
      debugPrint('Error stopping audio: $e');
    }
  }

  /// Pause current playback
  Future<void> pause() async {
    try {
      await _player.pause();
      _isPlaying = false;
    } catch (e) {
      debugPrint('Error pausing audio: $e');
    }
  }

  /// Resume paused playback
  Future<void> resume() async {
    try {
      await _player.resume();
      _isPlaying = true;
    } catch (e) {
      debugPrint('Error resuming audio: $e');
    }
  }

  /// Set volume (0.0 to 1.0)
  Future<void> setVolume(double volume) async {
    try {
      await _player.setVolume(volume.clamp(0.0, 1.0));
    } catch (e) {
      debugPrint('Error setting volume: $e');
    }
  }

  /// Get current playback position
  Future<Duration?> getPosition() async {
    try {
      return await _player.getCurrentPosition();
    } catch (e) {
      debugPrint('Error getting position: $e');
      return null;
    }
  }

  /// Get audio duration
  Future<Duration?> getDuration() async {
    try {
      return await _player.getDuration();
    } catch (e) {
      debugPrint('Error getting duration: $e');
      return null;
    }
  }

  /// Seek to position
  Future<void> seek(Duration position) async {
    try {
      await _player.seek(position);
    } catch (e) {
      debugPrint('Error seeking: $e');
    }
  }

  /// Dispose resources
  void dispose() {
    _player.dispose();
  }
}

/// Audio playback queue for managing multiple audio files
class AudioQueue {
  final AudioService _audioService = AudioService();
  final List<String> _queue = [];
  int _currentIndex = -1;
  
  /// Add audio file to queue
  void add(String filePath) {
    _queue.add(filePath);
  }

  /// Add multiple audio files to queue
  void addAll(List<String> filePaths) {
    _queue.addAll(filePaths);
  }

  /// Play next audio in queue
  Future<void> playNext() async {
    if (_currentIndex < _queue.length - 1) {
      _currentIndex++;
      await _audioService.playAudio(_queue[_currentIndex]);
    }
  }

  /// Play previous audio in queue
  Future<void> playPrevious() async {
    if (_currentIndex > 0) {
      _currentIndex--;
      await _audioService.playAudio(_queue[_currentIndex]);
    }
  }

  /// Play audio at specific index
  Future<void> playAt(int index) async {
    if (index >= 0 && index < _queue.length) {
      _currentIndex = index;
      await _audioService.playAudio(_queue[index]);
    }
  }

  /// Clear the queue
  void clear() {
    _queue.clear();
    _currentIndex = -1;
  }

  /// Get queue length
  int get length => _queue.length;
  
  /// Get current index
  int get currentIndex => _currentIndex;
  
  /// Check if queue is empty
  bool get isEmpty => _queue.isEmpty;
  
  /// Check if queue has next item
  bool get hasNext => _currentIndex < _queue.length - 1;
  
  /// Check if queue has previous item
  bool get hasPrevious => _currentIndex > 0;

  /// Dispose resources
  void dispose() {
    _audioService.dispose();
  }
}


