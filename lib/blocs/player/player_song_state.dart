part of 'player_song_cubit.dart';

abstract class PlayerSongState {
  const PlayerSongState();
}

class PlayerInitial extends PlayerSongState {}

class PlayerLoading extends PlayerSongState {}

class PlayerPlaying extends PlayerSongState {
  final Song currentSong;
  final PlayerPosition position;
  final bool isPlaying;
  final bool isShuffling;
  final LoopMode loopMode;

  const PlayerPlaying({
    required this.currentSong,
    required this.position,
    required this.isPlaying,
    required this.isShuffling,
    required this.loopMode,
  });

  PlayerPlaying copyWith({
    Song? currentSong,
    PlayerPosition? position,
    bool? isPlaying,
    bool? isShuffling,
    LoopMode? loopMode,
  }) {
    return PlayerPlaying(
      currentSong: currentSong ?? this.currentSong,
      position: position ?? this.position,
      isPlaying: isPlaying ?? this.isPlaying,
      isShuffling: isShuffling ?? this.isShuffling,
      loopMode: loopMode ?? this.loopMode,
    );
  }
}

class PlayerError extends PlayerSongState {
  final String message;

  const PlayerError(this.message);
}

class PlayerPosition {
  final Duration position;
  final Duration duration;

  const PlayerPosition({
    required this.position,
    required this.duration,
  });

  double get progress {
    if (duration.inSeconds == 0) return 0;
    return position.inSeconds / duration.inSeconds;
  }
}