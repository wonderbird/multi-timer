import 'package:flutter/material.dart';
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

// ...existing code...
class _TimerScreenState extends State<TimerScreen> {
  bool _isCounting = false;
  final AudioPlayer _player = AudioPlayer();
  
  // Define wait durations for each cycle (in seconds)
  // Here: 5 min, 1 min, 5 min, 1 min, 5 min, 2 min, 1 min
  final List<int> _waitDurations = [300, 60, 300, 60, 300, 120, 60];

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  Future<void> _startTimer() async {
    setState(() {
      _isCounting = true;
    });

    for (int duration in _waitDurations) {
      // Wait for the specified duration
      await Future.delayed(Duration(seconds: duration));

      // Create a completer to wait for audio completion
      final completer = Completer<void>();
      
      // Listen for when the audio finishes playing
      final subscription = _player.onPlayerComplete.listen((_) {
        completer.complete();
      });

      // Play sound
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
