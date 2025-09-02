import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify_b/blocs/songs/trending_cubit.dart';
import 'package:spotify_b/core/constants/api_constants.dart';
import 'package:spotify_b/data/models/song_model.dart';

class TrendingSongsSection extends StatefulWidget {
  const TrendingSongsSection({super.key});

  @override
  State<TrendingSongsSection> createState() => _TrendingSongsSectionState();
}

class _TrendingSongsSectionState extends State<TrendingSongsSection> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // _scrollController.addListener(_onScroll);

    // Load dữ liệu ban đầu sau khi build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TrendingCubit>().loadTrendingSongs();
    });
  }


  @override
  void dispose() {
    // _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TrendingCubit, TrendingState>(
      listener: (context, state) {
        if (state is TrendingError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Lỗi: ${state.message}')));
        }
      },
      builder: (context, state) {
        if (state is TrendingLoading) {
          return _buildLoading();
        } else if (state is TrendingLoaded) {
          debugPrint(
            'Building trending content: ${state.songs.length} songs, hasMore: ${state.hasMore}',
          );
          return _buildTrendingContent(state.songs, state.hasMore);
        } else if (state is TrendingError) {
          return _buildError(state.message);
        } else {
          return const SizedBox();
        }
      },
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Lỗi: $message',
              style: TextStyle(color: Colors.white.withOpacity(0.7)),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed:
                  () => context.read<TrendingCubit>().loadTrendingSongs(),
              child: const Text('Thử lại'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTrendingContent(List<Song> songs, bool hasMore) {
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

    return NotificationListener<ScrollNotification>(
      onNotification: (scrollNotification) {
        if (scrollNotification is ScrollEndNotification) {
          final metrics = scrollNotification.metrics;
          final cubit = context.read<TrendingCubit>();
          if (metrics.pixels >=
                  metrics.maxScrollExtent * 0.7 && // Giảm ngưỡng xuống 70%
              cubit.hasMore &&
              !cubit.isLoadingMore) {
            debugPrint('Triggering load more via NotificationListener...');
            cubit.loadTrendingSongs(loadMore: true);
          }
        }
        return false;
      },
      child: SizedBox(
        height: 400, // Giới hạn chiều cao để ListView.builder cuộn độc lập
        child: ListView.builder(
          controller: _scrollController,
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 10),
          itemCount: songs.length + (hasMore ? 1 : 0),
          itemBuilder: (context, index) {
            if (index >= songs.length) {
              debugPrint('Showing load more indicator');
              return _buildLoadMoreIndicator();
            }
            final song = songs[index];
            return _buildVerticalSongItem(song);
          },
        ),
      ),
    );
  }

  Widget _buildLoadMoreIndicator() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Center(
        child: CircularProgressIndicator(color: Colors.white.withOpacity(0.7)),
      ),
    );
  }

  Widget _buildVerticalSongItem(Song song) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
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
                  song.artist,
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
