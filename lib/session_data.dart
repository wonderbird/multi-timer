class SessionData {
  final int durationMs;
  final String? audioFile;
  final int audioDurationMs;

  SessionData(this.durationMs, [this.audioFile, this.audioDurationMs = 0]);
}
