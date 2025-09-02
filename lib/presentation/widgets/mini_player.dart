import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify_b/blocs/player/player_song_cubit.dart';
import 'package:spotify_b/presentation/screens/hometabbottom/player/music_player_screen.dart';

class MiniPlayer extends StatelessWidget {
  const MiniPlayer({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PlayerSongCubit, PlayerSongState>(
      builder: (context, state) {
        if (state is! PlayerPlaying) {
          return const SizedBox.shrink(); // không có nhạc thì ẩn mini
        }

        final song = state.currentSong;
        final playerCubit = context.read<PlayerSongCubit>();

        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => MusicPlayerScreen(
                  playlist: [song],
                  initialIndex: 0,
                  shouldInit: false,
                ),
              ),
            );
          },
          child: Container(
            color: Colors.black87,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: [
                // Ảnh cover
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: Image.network(
                    song.fullCoverUrl,
                    width: 48,
                    height: 48,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 12),
                // Tên bài
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        song.title,
                        style: const TextStyle(color: Colors.white, fontSize: 16),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        song.artist,
                        style: const TextStyle(color: Colors.grey, fontSize: 14),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                // Nút play/pause
                IconButton(
                  icon: Icon(
                    state.isPlaying ? Icons.pause : Icons.play_arrow,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    if (state.isPlaying) {
                      playerCubit.pause();
                    } else {
                      playerCubit.play();
                    }
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
