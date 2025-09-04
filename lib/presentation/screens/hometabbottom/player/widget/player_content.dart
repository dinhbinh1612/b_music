import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:spotify_b/blocs/player/player_song_cubit.dart';

class PlayerContent extends StatefulWidget {
  final PlayerPlaying state;

  const PlayerContent({super.key, required this.state});

  @override
  State<PlayerContent> createState() => _PlayerContentState();
}

class _PlayerContentState extends State<PlayerContent> {
  double? _dragValue;

  @override
  Widget build(BuildContext context) {
    final playerCubit = context.read<PlayerSongCubit>();
    final song = widget.state.currentSong;

    final position =
        _dragValue ?? widget.state.position.position.inSeconds.toDouble();
    final duration = widget.state.position.duration.inSeconds.toDouble();

    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 20),
          // Ảnh bìa
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
                song.fullCoverUrl,
                fit: BoxFit.cover,
                errorBuilder:
                    (_, __, ___) => Container(
                      color: Colors.grey[800],
                      child: const Icon(
                        Icons.music_note,
                        color: Colors.white,
                        size: 64,
                      ),
                    ),
              ),
            ),
          ),
          const SizedBox(height: 30),

          // Thông tin bài hát
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

          // Like + danh sách
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                BlocBuilder<PlayerSongCubit, PlayerSongState>(
                  builder: (context, state) {
                    if (state is! PlayerPlaying) return const SizedBox();
                    final song = state.currentSong;

                    return IconButton(
                      icon: Icon(
                        song.isLiked ? Icons.favorite : Icons.favorite_border,
                        color: song.isLiked ? Colors.red : Colors.white,
                        size: 28,
                      ),
                      onPressed:
                          () => context.read<PlayerSongCubit>().toggleLike(),
                    );
                  },
                ),
                const Icon(Icons.playlist_play, color: Colors.white, size: 28),
              ],
            ),
          ),
          const SizedBox(height: 5),

          // Thanh tiến trình
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
                    inactiveTrackColor: Colors.grey,
                    thumbColor: Colors.white,
                  ),
                  child: Slider(
                    value: position.clamp(0, duration),
                    min: 0,
                    max: duration > 0 ? duration : 1,
                    onChanged: (value) => setState(() => _dragValue = value),
                    onChangeStart: (_) => setState(() => _dragValue = position),
                    onChangeEnd: (value) {
                      playerCubit.seek(Duration(seconds: value.toInt()));
                      setState(() => _dragValue = null);
                    },
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _formatDuration(Duration(seconds: position.toInt())),
                      style: TextStyle(color: Colors.grey[400]),
                    ),
                    Text(
                      _formatDuration(Duration(seconds: duration.toInt())),
                      style: TextStyle(color: Colors.grey[400]),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),

          // Điều khiển
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(
                    Icons.shuffle,
                    color:
                        widget.state.isShuffling ? Colors.green : Colors.white,
                  ),
                  onPressed: () => playerCubit.toggleShuffle(),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.skip_previous,
                    color: Colors.white,
                    size: 36,
                  ),
                  onPressed: () => playerCubit.previous(),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: IconButton(
                    icon: Icon(
                      widget.state.isPlaying ? Icons.pause : Icons.play_arrow,
                      color: Colors.black,
                      size: 36,
                    ),
                    onPressed: () {
                      if (widget.state.isPlaying) {
                        playerCubit.pause();
                      } else {
                        playerCubit.play();
                      }
                    },
                  ),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.skip_next,
                    color: Colors.white,
                    size: 36,
                  ),
                  onPressed: () => playerCubit.next(),
                ),
                IconButton(
                  icon: Icon(
                    _getRepeatIcon(widget.state.loopMode),
                    color: _getRepeatColor(widget.state.loopMode),
                  ),
                  onPressed: () => playerCubit.toggleLoopMode(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

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
