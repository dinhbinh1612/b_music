import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart';
import 'package:spotify_b/data/models/song_model.dart';

part 'player_song_state.dart';

class PlayerSongCubit extends Cubit<PlayerSongState> {
  final AudioPlayer _audioPlayer;
  List<Song> _playlist = [];
  int _currentIndex = 0;
  bool _isShuffling = false;
  LoopMode _loopMode = LoopMode.off;
  StreamSubscription? _positionSubscription;
  StreamSubscription? _playerStateSubscription;

  PlayerSongCubit() : _audioPlayer = AudioPlayer(), super(PlayerInitial()) {
    _setupListeners();
  }

  void _setupListeners() {
    _positionSubscription =
        Rx.combineLatest2<Duration, Duration?, PlayerPosition>(
          _audioPlayer.positionStream,
          _audioPlayer.durationStream,
          (position, duration) => PlayerPosition(
            position: position,
            duration: duration ?? Duration.zero,
          ),
        ).listen((position) {
          if (state is PlayerPlaying) {
            emit((state as PlayerPlaying).copyWith(position: position));
          }
        });

    _playerStateSubscription = _audioPlayer.playerStateStream.listen((
      playerState,
    ) {
      final isPlaying = playerState.playing;

      if (state is PlayerPlaying && !isClosed) {
        emit((state as PlayerPlaying).copyWith(isPlaying: isPlaying));
      }

      if (playerState.processingState == ProcessingState.completed) {
        if (_loopMode == LoopMode.one) {
          _audioPlayer.seek(Duration.zero);
          _audioPlayer.play();
        } else {
          next();
        }
      }
    });
  }

  Future<void> initPlayer(List<Song> playlist, {int initialIndex = 0}) async {
    _playlist = playlist;
    _currentIndex = initialIndex;

    try {
      emit(PlayerLoading());
      await _audioPlayer.setAudioSource(
        ConcatenatingAudioSource(
          children:
              playlist
                  .map((song) => AudioSource.uri(Uri.parse(song.streamUrl)))
                  .toList(),
        ),
        initialIndex: initialIndex,
      );

      // phát nhạc khi nhấn vào item
      _audioPlayer.play();

      final currentSong = _playlist[_currentIndex];
      emit(
        PlayerPlaying(
          currentSong: currentSong,
          position: const PlayerPosition(
            position: Duration.zero,
            duration: Duration.zero,
          ),
          isPlaying: true,
          isShuffling: _isShuffling,
          loopMode: _loopMode,
        ),
      );
    } catch (e) {
      emit(PlayerError(e.toString()));
    }
  }

  Future<void> play() async {
    try {
      await _audioPlayer.play();
      if (state is PlayerPlaying) {
        emit((state as PlayerPlaying).copyWith(isPlaying: true));
      }
    } catch (e) {
      emit(PlayerError(e.toString()));
    }
  }

  Future<void> pause() async {
    try {
      await _audioPlayer.pause();
      if (state is PlayerPlaying) {
        emit((state as PlayerPlaying).copyWith(isPlaying: false));
      }
    } catch (e) {
      emit(PlayerError(e.toString()));
    }
  }

  Future<void> seek(Duration position) async {
    try {
      await _audioPlayer.seek(position);
    } catch (e) {
      emit(PlayerError(e.toString()));
    }
  }

  Future<void> next() async {
    try {
      final hasNext = _audioPlayer.hasNext;
      if (hasNext) {
        await _audioPlayer.seekToNext();
        _currentIndex = (_currentIndex + 1) % _playlist.length;

        if (state is PlayerPlaying) {
          emit(
            (state as PlayerPlaying).copyWith(
              currentSong: _playlist[_currentIndex],
            ),
          );
        }
      }
    } catch (e) {
      emit(PlayerError(e.toString()));
    }
  }

  Future<void> previous() async {
    try {
      final hasPrevious = _audioPlayer.hasPrevious;
      if (hasPrevious) {
        await _audioPlayer.seekToPrevious();
        _currentIndex = (_currentIndex - 1) % _playlist.length;
        if (_currentIndex < 0) _currentIndex = _playlist.length - 1;

        if (state is PlayerPlaying) {
          emit(
            (state as PlayerPlaying).copyWith(
              currentSong: _playlist[_currentIndex],
            ),
          );
        }
      } else {
        await _audioPlayer.seek(Duration.zero);
      }
    } catch (e) {
      emit(PlayerError(e.toString()));
    }
  }

  Future<void> toggleShuffle() async {
    try {
      _isShuffling = !_isShuffling;
      await _audioPlayer.setShuffleModeEnabled(_isShuffling);

      if (state is PlayerPlaying) {
        emit((state as PlayerPlaying).copyWith(isShuffling: _isShuffling));
      }
    } catch (e) {
      emit(PlayerError(e.toString()));
    }
  }

  Future<void> toggleLoopMode() async {
    try {
      final modes = [LoopMode.off, LoopMode.one, LoopMode.all];
      final currentIndex = modes.indexOf(_loopMode);
      _loopMode = modes[(currentIndex + 1) % modes.length];

      await _audioPlayer.setLoopMode(_loopMode);

      if (state is PlayerPlaying) {
        emit((state as PlayerPlaying).copyWith(loopMode: _loopMode));
      }
    } catch (e) {
      emit(PlayerError(e.toString()));
    }
  }

  Future<void> toggleLike() async {
    if (state is PlayerPlaying) {
      final currentSong = (state as PlayerPlaying).currentSong;
      debugPrint('Toggling like for song: ${currentSong.title}');
    }
  }

  @override
  Future<void> close() async {
    await _positionSubscription?.cancel();
    await _playerStateSubscription?.cancel();
    await _audioPlayer.dispose();
    return super.close();
  }
}
