import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify_b/blocs/favorire_song/liked_songs_cubit.dart';
import 'package:spotify_b/blocs/favorire_song/liked_songs_state.dart';
import 'package:spotify_b/presentation/screens/hometabbottom/library/widget/favorite_song_item.dart';
import 'package:spotify_b/presentation/screens/hometabbottom/player/music_player_screen.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    context.read<LikedSongsCubit>().fetchLikedSongs();

    _scrollController.addListener(() {
      final cubit = context.read<LikedSongsCubit>();
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent * 0.7 &&
          cubit.state is LikedSongsLoaded &&
          (cubit.state as LikedSongsLoaded).hasMore) {
        cubit.fetchLikedSongs(loadMore: true);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Bài hát yêu thích',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: BlocBuilder<LikedSongsCubit, LikedSongsState>(
        builder: (context, state) {
          if (state is LikedSongsLoading && state is! LikedSongsLoaded) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF1DB954)),
              ),
            );
          }

          if (state is LikedSongsError) {
            return _buildError(state.message);
          }

          if (state is LikedSongsLoaded) {
            final songs = state.songs;
            if (songs.isEmpty) return _buildEmpty();

            return RefreshIndicator(
              onRefresh:
                  () async => context.read<LikedSongsCubit>().fetchLikedSongs(),
              backgroundColor: const Color(0xFF1DB954),
              color: Colors.white,
              child: ListView.separated(
                controller: _scrollController,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                itemCount: songs.length + (state.hasMore ? 1 : 0),
                separatorBuilder:
                    (context, index) =>
                        const Divider(color: Colors.white24, height: 1),
                itemBuilder: (context, index) {
                  if (index >= songs.length) {
                    return const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white70,
                          ),
                        ),
                      ),
                    );
                  }

                  final song = songs[index];
                  return FavoriteSongItem(
                    song: song,
                    index: index,
                    onTap:
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (_) => MusicPlayerScreen(
                                  playlist: songs,
                                  initialIndex: index,
                                ),
                          ),
                        ),
                  );
                },
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildError(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, color: Colors.red, size: 48),
          const SizedBox(height: 16),
          Text(
            'Đã xảy ra lỗi: $message',
            style: const TextStyle(color: Colors.white70),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => context.read<LikedSongsCubit>().fetchLikedSongs(),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1DB954),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: const Text("Thử lại", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _buildEmpty() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.favorite_border, color: Colors.white70, size: 64),
          SizedBox(height: 16),
          Text(
            'Chưa có bài hát yêu thích',
            style: TextStyle(color: Colors.white70, fontSize: 18),
          ),
        ],
      ),
    );
  }
}
