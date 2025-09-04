import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify_b/blocs/player/player_song_cubit.dart';
import 'package:spotify_b/data/models/song_model.dart';
import 'widget/playlist_modal.dart';
import 'widget/player_content.dart';

class MusicPlayerScreen extends StatelessWidget {
  final List<Song> playlist;
  final int initialIndex;
  final bool shouldInit;

  const MusicPlayerScreen({
    super.key,
    required this.playlist,
    required this.initialIndex,
    this.shouldInit = true,
  });

  @override
  Widget build(BuildContext context) {
    final playerCubit = context.read<PlayerSongCubit>();
    if (shouldInit) {
      playerCubit.initPlayer(playlist, initialIndex: initialIndex);
    }
    return Scaffold(
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
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          BlocBuilder<PlayerSongCubit, PlayerSongState>(
            builder: (context, state) {
              if (state is PlayerPlaying) {
                return IconButton(
                  icon: const Icon(Icons.more_vert, color: Colors.white),
                  onPressed: () {
                    _showPlaylistModal(context, state.currentSong);
                  },
                );
              }
              return const SizedBox.shrink();
            },
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
            return PlayerContent(state: state);
          } else if (state is PlayerError) {
            return Center(child: Text('Error: ${state.message}'));
          } else {
            return const Center(child: Text('Không có bài hát'));
          }
        },
      ),
    );
  }

  void _showPlaylistModal(BuildContext context, Song currentSong) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => PlaylistModal(currentSong: currentSong),
    );
  }
}
