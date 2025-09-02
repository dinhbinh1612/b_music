import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:spotify_b/blocs/player/player_song_cubit.dart';
import 'package:spotify_b/core/constants/api_constants.dart';
import 'package:spotify_b/data/models/song_model.dart';

class MusicPlayerScreen extends StatelessWidget {
  final List<Song> playlist;
  final int initialIndex;

  const MusicPlayerScreen({
    super.key,
    required this.playlist,
    required this.initialIndex,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) =>
              PlayerSongCubit()
                ..initPlayer(playlist, initialIndex: initialIndex),
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text(
            'Bài Hát',
            style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.more_vert, color: Colors.white),
              onPressed: () {},
            ),
          ],
        ),
        body: BlocConsumer<PlayerSongCubit, PlayerSongState>(
          listener: (context, state) {
            if (state is PlayerError) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.message)));
            }
          },
          builder: (context, state) {
            if (state is PlayerLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is PlayerPlaying) {
              return _PlayerContent(state: state);
            } else if (state is PlayerError) {
              return Center(child: Text('Error: ${state.message}'));
            } else {
              return const Center(child: Text('Không có bài hát'));
            }
          },
        ),
      ),
    );
  }
}

class _PlayerContent extends StatelessWidget {
  final PlayerPlaying state;

  const _PlayerContent({required this.state});

  @override
  Widget build(BuildContext context) {
    final playerCubit = context.read<PlayerSongCubit>();
    final song = state.currentSong;

    return Column(
      children: [
        const SizedBox(height: 20),
        // Album Art
        Container(
          width: 300,
          height: 300,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.5),
                blurRadius: 20,
                spreadRadius: 2,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(
              '${ApiConstants.baseUrl}/${song.coverUrl}',
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Colors.grey[800],
                  child: const Icon(
                    Icons.music_note,
                    color: Colors.white,
                    size: 64,
                  ),
                );
              },
            ),
          ),
        ),
        const SizedBox(height: 30),
        // Song Info
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            children: [
              Text(
                song.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Text(
                song.artist,
                style: TextStyle(color: Colors.grey[400], fontSize: 18),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        const SizedBox(height: 27),
        // Like and list
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: Icon(
                  Icons.favorite,
                  color: song.isLiked ? Colors.green : Colors.white,
                  size: 28,
                ),
                onPressed: () => playerCubit.toggleLike(),
              ),
              IconButton(
                icon: const Icon(
                  Icons.playlist_play,
                  color: Colors.white,
                  size: 28,
                ),
                onPressed: () {},
              ),
            ],
          ),
        ),
        const SizedBox(height: 5),
        // Progress Bar
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              SliderTheme(
                data: SliderThemeData(
                  trackHeight: 4,
                  thumbShape: const RoundSliderThumbShape(
                    enabledThumbRadius: 8,
                  ),
                  overlayShape: const RoundSliderOverlayShape(
                    overlayRadius: 16,
                  ),
                  activeTrackColor: Colors.green,
                  inactiveTrackColor: Colors.grey[700],
                  thumbColor: Colors.white,
                ),
                child: Slider(
                  value: state.position.position.inSeconds.toDouble(),
                  min: 0,
                  max: state.position.duration.inSeconds.toDouble(),
                  onChanged: (value) {
                    playerCubit.seek(Duration(seconds: value.toInt()));
                  },
                ),
              ),
              const SizedBox(height: 4),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _formatDuration(state.position.position),
                      style: TextStyle(color: Colors.grey[400]),
                    ),
                    Text(
                      _formatDuration(state.position.duration),
                      style: TextStyle(color: Colors.grey[400]),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        // Controls
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Shuffle
              IconButton(
                icon: Icon(
                  Icons.shuffle,
                  color: state.isShuffling ? Colors.green : Colors.white,
                  size: 28,
                ),
                onPressed: () => playerCubit.toggleShuffle(),
              ),
              // Previous
              IconButton(
                icon: const Icon(
                  Icons.skip_previous,
                  color: Colors.white,
                  size: 36,
                ),
                onPressed: () => playerCubit.previous(),
              ),
              // Play/Pause
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: IconButton(
                  icon: Icon(
                    state.isPlaying ? Icons.pause : Icons.play_arrow,
                    color: Colors.black,
                    size: 36,
                  ),
                  onPressed: () {
                    if (state.isPlaying) {
                      playerCubit.pause();
                    } else {
                      playerCubit.play();
                    }
                  },
                ),
              ),
              // Next
              IconButton(
                icon: const Icon(
                  Icons.skip_next,
                  color: Colors.white,
                  size: 36,
                ),
                onPressed: () => playerCubit.next(),
              ),
              // lapw
              IconButton(
                icon: Icon(
                  _getRepeatIcon(state.loopMode),
                  color: _getRepeatColor(state.loopMode),
                  size: 28,
                ),
                onPressed: () => playerCubit.toggleLoopMode(),
              ),
            ],
          ),
        ),
        const SizedBox(height: 30),
      ],
    );
  }

  // tinh thowif luongw
  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  IconData _getRepeatIcon(LoopMode loopMode) {
    switch (loopMode) {
      case LoopMode.off:
        return Icons.repeat;
      case LoopMode.one:
        return Icons.repeat_one;
      case LoopMode.all:
        return Icons.repeat;
    }
  }

  Color _getRepeatColor(LoopMode loopMode) {
    return loopMode == LoopMode.off
        ? Colors.white
        : const Color.fromARGB(255, 0, 72, 2);
  }
}
