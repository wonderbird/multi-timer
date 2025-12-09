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

class _TimerScreenState extends State<TimerScreen> {
  bool _isCounting = false;
  final AudioPlayer _player = AudioPlayer();

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  Future<void> _startTimer() async {
    setState(() {
      _isCounting = true;
    });

    // Wait for 5 seconds
    await Future.delayed(const Duration(seconds: 5));

    // Play sound
    await _player.play(AssetSource('gong.mp3'));

    // Wait for 3 seconds while sound plays
    await Future.delayed(const Duration(seconds: 3));

    // Stop sound
    await _player.stop();

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
