import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:async';

void main() {
  runApp(const MultiTimerApp());
}

class MultiTimerApp extends StatelessWidget {
  const MultiTimerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Multi Timer',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const TimerScreen(),
    );
  }
}

class TimerScreen extends StatefulWidget {
  const TimerScreen({super.key});

  @override
  State<TimerScreen> createState() => _TimerScreenState();
}

// Session data class to hold duration and optional audio file
class SessionData {
  final int durationSeconds;
  final String? audioFile;  // Optional audio file to play before the session
  final int audioDurationMs;  // Duration of the audio file in milliseconds
  
  SessionData(this.durationSeconds, [this.audioFile, this.audioDurationMs = 0]);
}

class _TimerScreenState extends State<TimerScreen> {
  bool _isCounting = false;
  final AudioPlayer _player = AudioPlayer();
  
  // Get the asset path prefix based on build mode
  String get _assetPrefix => kDebugMode ? 'debug/' : 'release/';
  
  // Define sessions with wait durations and optional audio files
  late final List<SessionData> _sessions = kDebugMode
      ? [
          SessionData(5, '${_assetPrefix}session1.mp3', 2300),
          SessionData(1),
          SessionData(2, '${_assetPrefix}session2.mp3', 860),
        ]
      : [
          SessionData(300, '${_assetPrefix}ganzkoerperatmung.mp3', 8000),
          SessionData(60,  '${_assetPrefix}atem-halten.mp3', 8700),
          SessionData(300, '${_assetPrefix}ganzkoerperatmung.mp3', 8000),
          SessionData(60,  '${_assetPrefix}atem-halten.mp3', 8700),
          SessionData(300, '${_assetPrefix}ganzkoerperatmung.mp3', 8000),
          SessionData(120, '${_assetPrefix}wellenatmen.mp3', 9000),
          SessionData(60,  '${_assetPrefix}atem-halten.mp3', 8700),
        ];

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  Future<void> _playAudioAndWait(String audioPath) async {
    final completer = Completer<void>();
    final subscription = _player.onPlayerComplete.listen((_) {
      completer.complete();
    });
    await _player.play(AssetSource(audioPath));
    await completer.future;
    await subscription.cancel();
  }

  Future<void> _startTimer() async {
    setState(() {
      _isCounting = true;
    });

    for (SessionData session in _sessions) {
      if (session.audioFile != null) {
        await _playAudioAndWait(session.audioFile!);
      }

      // Calculate remaining timer duration after audio playback
      final totalDurationMs = session.durationSeconds * 1000;
      final remainingDurationMs = totalDurationMs - session.audioDurationMs;
      
      if (remainingDurationMs > 0) {
        await Future.delayed(Duration(milliseconds: remainingDurationMs));
      }

      await _playAudioAndWait('gong.mp3');
    }

    setState(() {
      _isCounting = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isCounting) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: SizedBox.shrink(),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Multi Timer'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: _startTimer,
          child: const Text('Start'),
        ),
      ),
    );
  }
}
