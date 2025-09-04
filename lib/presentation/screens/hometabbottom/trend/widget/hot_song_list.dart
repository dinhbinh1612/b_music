import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify_b/blocs/hot/hot_cubit.dart';
import 'package:spotify_b/blocs/hot/hot_state.dart';
import 'package:spotify_b/data/models/song_model.dart';
import 'package:spotify_b/presentation/screens/hometabbottom/player/music_player_screen.dart';
import 'song_list_item.dart';

class HotSongList extends StatelessWidget {
  final ScrollController scrollController;
  const HotSongList({super.key, required this.scrollController});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HotCubit, HotState>(
      listener: (context, state) {
        if (state.error != null && state.songs.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Lỗi: ${state.error}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      builder: (context, state) {
        if (state.isLoading && state.songs.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF1DB954)),
            ),
          );
        }

        if (state.error != null && state.songs.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, color: Colors.red, size: 48),
                const SizedBox(height: 16),
                Text(
                  "Đã xảy ra lỗi: ${state.error}",
                  style: const TextStyle(color: Colors.white70),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => context.read<HotCubit>().fetchHot(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1DB954),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text(
                    "Thử lại",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          );
        }

        if (state.songs.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.music_off, color: Colors.white70, size: 48),
                SizedBox(height: 16),
                Text(
                  "Không có bài hát nào",
                  style: TextStyle(color: Colors.white70),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () async {
            context.read<HotCubit>().fetchHot(page: 1);
          },
          backgroundColor: const Color(0xFF1DB954),
          color: Colors.white,
          child: ListView.separated(
            controller: scrollController,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: state.songs.length + (state.hasMore ? 1 : 0),
            separatorBuilder: (context, index) => const Divider(
              color: Colors.white24,
              height: 1,
            ),
            itemBuilder: (context, index) {
              if (index >= state.songs.length) {
                return Padding(
                  padding: const EdgeInsets.all(16),
                  child: Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                          Colors.white.withOpacity(0.7)),
                    ),
                  ),
                );
              }

              final Song song = state.songs[index];
              return SongListItem(
                song: song,
                rank: index + 1,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MusicPlayerScreen(
                        playlist: state.songs,
                        initialIndex: index,
                      ),
                    ),
                  );
                },
              );
            },
          ),
        );
      },
    );
  }
}
