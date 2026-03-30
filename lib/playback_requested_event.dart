import 'package:multi_timer/timer_event.dart';

class PlaybackRequestedEvent extends TimerEvent {
  final String audioFile;

  const PlaybackRequestedEvent({
    required super.offsetMs,
    required this.audioFile,
  });

  @override
  List<Object?> get props => [offsetMs, audioFile];
}
