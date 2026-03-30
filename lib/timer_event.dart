import 'package:equatable/equatable.dart';

abstract class TimerEvent extends Equatable {
  final int offsetMs;

  const TimerEvent({required this.offsetMs});

  @override
  List<Object?> get props => [offsetMs];
}
