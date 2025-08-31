import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify_b/blocs/songs/songs_cubit.dart';
import 'package:spotify_b/blocs/songs/songs_state.dart';
import 'package:spotify_b/core/constants/api_constants.dart';
import 'package:spotify_b/data/models/song_model.dart';

class RecommendedSongsSection extends StatelessWidget {
  const RecommendedSongsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SongCubit, SongState>(
      builder: (context, state) {
        if (state.loading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state.error != null) {
          return Center(
            child: Text(
              'Lỗi: ${state.error}',
              style: const TextStyle(color: Colors.red),
            ),
          );
        }
        if (state.songs.isEmpty) {
          return const Center(
            child: Text('Không có bài hát', style: TextStyle(color: Colors.white)),
          );
        }

        // Chia danh sách thành các page 9 bài
        final pages = <List<Song>>[];
        for (var i = 0; i < state.songs.length; i += 9) {
          pages.add(state.songs.sublist(
            i,
            i + 9 > state.songs.length ? state.songs.length : i + 9,
          ));
        }

        return SizedBox(
          height: 400,
          child: PageView.builder(
            controller: PageController(viewportFraction: 1),
            itemCount: pages.length,
            itemBuilder: (context, pageIndex) {
              final songs = pages[pageIndex];
              return GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                padding: const EdgeInsets.all(8),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemCount: songs.length,
                itemBuilder: (context, index) {
                  final song = songs[index];
                  return GestureDetector(
                    onTap: () {
                    },
                    child: Column(
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              '${ApiConstants.baseUrl}/${song.coverUrl}',
                              fit: BoxFit.cover,
                              width: double.infinity,
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          song.title,
                          style: const TextStyle(color: Colors.white, fontSize: 12),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
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
