import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart';
import 'package:spotify_b/data/models/song_model.dart';
import 'package:spotify_b/data/providers/analytics_api.dart';
import 'package:spotify_b/data/providers/like_api.dart';

part 'player_song_state.dart';

class PlayerSongCubit extends Cubit<PlayerSongState> {
  final AudioPlayer _audioPlayer;
  List<Song> _playlist = [];
  int _currentIndex = 0;
  bool _isShuffling = false;
  LoopMode _loopMode = LoopMode.off;
  StreamSubscription? _positionSubscription;
  StreamSubscription? _playerStateSubscription;

  // Biến kiểm tra lượt nghe đã gửi hay chưa
  final Map<String, bool> _songPlayTracked = {};

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
            // Tính % bài hát đã nghe
            final currentSong = (state as PlayerPlaying).currentSong;
            final songId = currentSong.id;

            if (!_songPlayTracked.containsKey(songId)) {
              _songPlayTracked[songId] = false;
            }

            // Gửi lượt nghe nếu chưa gửi và đã nghe hơn 30%
            if (!_songPlayTracked[songId]! &&
                position.duration.inSeconds > 0 &&
                position.position.inSeconds / position.duration.inSeconds >=
                    0.3) {
              final duration = currentSong.duration;
              AnalyticsApi.trackPlay(songId: songId, duration: duration);
              _songPlayTracked[songId] = true; // Đánh dấu là đã gửi
            }
          }
        });

    _playerStateSubscription = _audioPlayer.playerStateStream.listen((
      playerState,
    ) {
      final isPlaying = playerState.playing;
      if (state is PlayerPlaying && !isClosed) {
        emit((state as PlayerPlaying).copyWith(isPlaying: isPlaying));
      }
    });

    _audioPlayer.currentIndexStream.listen((index) {
      if (index != null && index >= 0 && index < _playlist.length) {
        _currentIndex = index;
        final newSong = _playlist[_currentIndex];

        emit(
          PlayerPlaying(
            currentSong: newSong,
            position: const PlayerPosition(
              position: Duration.zero,
              duration: Duration.zero,
            ),
            isPlaying: _audioPlayer.playing,
            isShuffling: _isShuffling,
            loopMode: _loopMode,
          ),
        );
      }
    });
  }

  Future<void> initPlayer(List<Song> playlist, {int initialIndex = 0}) async {
    _playlist = playlist;
    _currentIndex = initialIndex;
    _songPlayTracked.clear();

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
      if (_audioPlayer.hasNext) {
        await _audioPlayer.seekToNext();
      }
    } catch (e) {
      emit(PlayerError(e.toString()));
    }
  }

  Future<void> previous() async {
    try {
      if (_audioPlayer.hasPrevious) {
        await _audioPlayer.seekToPrevious();
        // Không emit ở đây nữa
      } else {
        // Nếu ở đầu playlist, chỉ reset position
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
      final songId = currentSong.id;

      try {
        final response = await LikeApi.toggleLike(songId);
        final data = response['data'];

        // Lấy danh sách likedSongs mới từ API
        final updatedLikedSongs = List<String>.from(data['likedSongs'] ?? []);

        // Map lại song với isLiked = true/false dựa vào likedSongs
        final updatedSong = Song.fromJson(
          data['song'],
          likedSongs: updatedLikedSongs,
        );

        // Cập nhật playlist
        _playlist[_currentIndex] = updatedSong;

        // Emit state với currentSong mới
        emit((state as PlayerPlaying).copyWith(currentSong: updatedSong));
      } catch (e) {
        emit(PlayerError("Like failed: $e"));
      }
    }
  }

  @override
  Future<void> close() async {
    _songPlayTracked.clear();
    await _positionSubscription?.cancel();
    await _playerStateSubscription?.cancel();
    await _audioPlayer.dispose();
    return super.close();
  }
}
