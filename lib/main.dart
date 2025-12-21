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

const int kGongDurationMs = 6080;

class _TimerScreenState extends State<TimerScreen> {
  bool _isCounting = false;
  final AudioPlayer _player = AudioPlayer();
  double _progress = 0.0;  // Progress from 0.0 to 1.0
  Timer? _progressTimer;
  
  // Get the asset path prefix based on build mode
  String get _assetPrefix => kDebugMode ? 'debug/' : 'release/';
  
  // Define sessions with wait durations and optional audio files
  late final List<SessionData> _sessions = kDebugMode
      ? [
          SessionData(9, '${_assetPrefix}session1.mp3', 2300),
          SessionData(1),
          SessionData(8, '${_assetPrefix}session2.mp3', 860),
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
    _progressTimer?.cancel();
    _player.dispose();
    super.dispose();
  }
  
  int _calculateTotalDuration() {
    return _sessions.fold(0, (sum, session) {
      return sum + session.durationSeconds * 1000;
    });
  }

  Future<void> _playAudioAndWait(String audioPath) async {
    // CRITICAL FIX: Stop any previous playback to ensure clean state
    await _player.stop();
    
    final completer = Completer<void>();
    
    // Set up listener BEFORE playing to avoid race condition
    final subscription = _player.onPlayerComplete.listen((_) {
      if (!completer.isCompleted) {
        completer.complete();
      }
    });
    
    try {
      await _player.play(AssetSource(audioPath));
    } catch (e) {
      await subscription.cancel();
      rethrow;
    }
    
    await completer.future;
    await subscription.cancel();
  }

  Future<void> _startTimer() async {
    setState(() {
      _isCounting = true;
      _progress = 0.0;
    });

    final totalDuration = _calculateTotalDuration();
    debugPrint('Total duration: ${totalDuration}ms (${(totalDuration / 1000).toStringAsFixed(1)}s)');
    final startTime = DateTime.now();
    
    // Update progress every 100ms
    _progressTimer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      final elapsed = DateTime.now().difference(startTime).inMilliseconds;
      setState(() {
        _progress = (elapsed / totalDuration).clamp(0.0, 1.0);
        final elapsedSec = (elapsed / 1000).toStringAsFixed(3).padLeft(7, ' ');
        final totalSec = (totalDuration / 1000).toStringAsFixed(3).padLeft(7, ' ');
        debugPrint('Elapsed: ${elapsedSec}s, Total: ${totalSec}s');
        debugPrint('Progress: ${_progress.toStringAsFixed(2)}');
      });
      
      if (_progress >= 1.0) {
        timer.cancel();
      }
    });

    for (int i = 0; i < _sessions.length; i++) {
      SessionData session = _sessions[i];
      
      int remainingDurationMs = session.durationSeconds * 1000 - kGongDurationMs;

      if (session.audioFile != null) {
        remainingDurationMs -= session.audioDurationMs;
        await _playAudioAndWait(session.audioFile!);
      }
      
      if (remainingDurationMs > 0) {
        await Future.delayed(Duration(milliseconds: remainingDurationMs));
      }

      await _playAudioAndWait('gong.mp3');
    }

    _progressTimer?.cancel();
    setState(() {
      _isCounting = false;
      _progress = 0.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isCounting) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            // Progress bar that fills from bottom to top
            Align(
              alignment: Alignment.bottomCenter,
              child: FractionallySizedBox(
                heightFactor: _progress,
                widthFactor: 1.0,
                child: Container(
                  color: Colors.deepPurple.withOpacity(0.3),
                ),
              ),
            ),
          ],
        ),
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
