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
  
  SessionData(this.durationSeconds, [this.audioFile]);
}

class _TimerScreenState extends State<TimerScreen> {
  bool _isCounting = false;
  final AudioPlayer _player = AudioPlayer();
  
  // Get the asset path prefix based on build mode
  String get _assetPrefix => kDebugMode ? 'debug/' : 'release/';
  
  // Define sessions with wait durations and optional audio files
  // Release mode: Production wait times (5 min, 1 min, 5 min, 1 min, 5 min, 2 min, 1 min)
  // Debug mode: Quick testing with 2 seconds each
  late final List<SessionData> _sessions = kDebugMode
      ? [
          SessionData(2, '${_assetPrefix}session1.mp3'),  // Debug: session 1 with audio
          SessionData(1),                                 // Debug: session break with no audio
          SessionData(2, '${_assetPrefix}session2.mp3'),  // Debug: session 3 with audio
        ]
      : [
          SessionData(300, '${_assetPrefix}ganzkoerperatmung.mp3'),
          SessionData(60,  '${_assetPrefix}atem-halten.mp3'),                                  // 1 min
          SessionData(300, '${_assetPrefix}ganzkoerperatmung.mp3'),
          SessionData(60,  '${_assetPrefix}atem-halten.mp3'),                                  // 1 min
          SessionData(300, '${_assetPrefix}ganzkoerperatmung.mp3'),
          SessionData(120, '${_assetPrefix}wellenatmen.mp3'),
          SessionData(60,  '${_assetPrefix}atem-halten.mp3'),                                  // 1 min
        ];

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  Future<void> _startTimer() async {
    setState(() {
      _isCounting = true;
    });

    for (SessionData session in _sessions) {
      // Play session audio if available (concurrent with timer)
      if (session.audioFile != null) {
        // Play session audio without waiting for it to finish
        await _player.play(AssetSource(session.audioFile!));
      }

      // Wait for the specified duration
      await Future.delayed(Duration(seconds: session.durationSeconds));

      // Create a completer to wait for audio completion
      final completer = Completer<void>();
      
      // Listen for when the audio finishes playing
      final subscription = _player.onPlayerComplete.listen((_) {
        completer.complete();
      });

      // Play gong sound at the end of the session
      await _player.play(AssetSource('gong.mp3'));

      // Wait for the sound to finish playing
      await completer.future;

      // Clean up the subscription
      await subscription.cancel();
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
