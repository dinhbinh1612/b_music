// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify_b/blocs/songs/trending_cubit.dart';
import 'package:spotify_b/core/constants/api_constants.dart';
import 'package:spotify_b/data/models/song_model.dart';

class TrendingSongsSection extends StatelessWidget {
  const TrendingSongsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TrendingCubit()..loadTrendingSongs(),
      child: BlocBuilder<TrendingCubit, TrendingState>(
        builder: (context, state) {
          if (state is TrendingLoading) {
            return _buildLoading();
          } else if (state is TrendingLoaded) {
            return _buildTrendingContent(state.songs);
          } else if (state is TrendingError) {
            return _buildError(state.message);
          } else {
            return const SizedBox();
          }
        },
      ),
    );
  }

  Widget _buildLoading() {
    return SizedBox(
      height: 220,
      child: Center(
        child: CircularProgressIndicator(color: Colors.white.withOpacity(0.7)),
      ),
    );
  }

  Widget _buildError(String message) {
    return SizedBox(
      height: 220,
      child: Center(
        child: Text(
          'Lỗi: $message',
          style: TextStyle(color: Colors.white.withOpacity(0.7)),
        ),
      ),
    );
  }

  Widget _buildTrendingContent(List<Song> songs) {
    if (songs.isEmpty) {
      return SizedBox(
        height: 200,
        child: Center(
          child: Text(
            'Không có bài hát',
            style: TextStyle(color: Colors.white.withOpacity(0.7)),
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // DANH SÁCH Dọc
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 10),
          itemCount: songs.length,
          itemBuilder: (context, index) {
            final song = songs[index];
            return _buildVerticalSongItem(song);
          },
        ),
      ],
    );
  }

  Widget _buildVerticalSongItem(Song song) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          // ẢNH COVER
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                '${ApiConstants.baseUrl}/${song.coverUrl}',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[800],
                    child: const Icon(
                      Icons.music_note,
                      color: Colors.white,
                      size: 24,
                    ),
                  );
                },
              ),
            ),
          ),

          const SizedBox(width: 12),

          // THÔNG TIN BÀI HÁT
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  song.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
                const SizedBox(height: 4),
                Text(
                  song.artist, // Added duration placeholder
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 14,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ],
            ),
          ),

          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_vert, color: Colors.white, size: 24),
          ),
        ],
      ),
    );
  }
}
