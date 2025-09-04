import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify_b/blocs/playlist/playlist_cubit.dart';
import 'package:spotify_b/blocs/playlist/playlist_state.dart';
import 'package:spotify_b/core/constants/api_constants.dart';
import 'package:spotify_b/data/models/song_model.dart';
import 'package:spotify_b/presentation/screens/hometabbottom/player/music_player_screen.dart';

class PlaylistDetailScreen extends StatelessWidget {
  final String playlistId;

  const PlaylistDetailScreen({super.key, required this.playlistId});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PlaylistCubit, PlaylistState>(
      builder: (context, state) {
        // Find the current playlist
        final playlist = state.playlists.firstWhere(
          (p) => p['id'] == playlistId,
          orElse: () => null,
        );

        if (playlist == null) {
          return Scaffold(
            backgroundColor: const Color(0xFF121212),
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
                onPressed: () => Navigator.of(context).pop(),
              ),
              title: const Text(
                'Playlist không tồn tại',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            body: Center(
              child: Text(
                'Playlist không tồn tại hoặc đã bị xóa',
                style: TextStyle(color: Colors.grey[400], fontSize: 16),
              ),
            ),
          );
        }

        final songs = playlist['songs'] ?? [];
        final playlistName = playlist['name'] ?? '';

        return Scaffold(
          backgroundColor: const Color(0xFF121212),
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
              onPressed: () => Navigator.of(context).pop(),
            ),
            title: Text(
              playlistName,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          body: _buildBody(context, songs, playlistId, playlistName),
        );
      },
    );
  }

  Widget _buildBody(
    BuildContext context,
    List<dynamic> songs,
    String playlistId,
    String playlistName,
  ) {
    return songs.isEmpty
        ? Center(
          child: Text(
            'Chưa có bài hát nào trong playlist này',
            style: TextStyle(color: Colors.grey[400], fontSize: 16),
          ),
        )
        : ListView.separated(
          padding: const EdgeInsets.all(12),
          itemCount: songs.length,
          separatorBuilder: (_, __) => const Divider(color: Colors.grey),
          itemBuilder: (context, index) {
            final song = songs[index];
            return ListTile(
              contentPadding: EdgeInsets.zero,
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: Image.network(
                  song['coverUrl'] != null
                      ? "${ApiConstants.baseUrl}/${song['coverUrl']}"
                      : "https://via.placeholder.com/150",
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                  errorBuilder:
                      (_, __, ___) => Container(
                        width: 50,
                        height: 50,
                        color: Colors.grey[800],
                        child: const Icon(
                          Icons.music_note,
                          color: Colors.white,
                        ),
                      ),
                ),
              ),
              title: Text(
                song['title'] ?? '',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
              subtitle: Text(
                song['artist'] ?? '',
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
              trailing: IconButton(
                icon: const Icon(Icons.more_vert, color: Colors.white),
                onPressed: () {
                  _showSongOptions(
                    context,
                    playlistId,
                    song['id'],
                    song['title'] ?? 'Bài hát',
                  );
                },
              ),
              onTap: () {
                final songModels =
                    songs.map<Song>((e) => Song.fromJson(e)).toList();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => MusicPlayerScreen(
                          playlist: songModels,
                          initialIndex: index,
                        ),
                  ),
                );
              },
            );
          },
        );
  }

  void _showSongOptions(
    BuildContext context,
    String playlistId,
    String songId,
    String songTitle,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1E1E1E),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title: const Text(
                  'Xoá khỏi playlist',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {
                  Navigator.pop(context); // đóng modal
                  _confirmDeleteSong(context, playlistId, songId, songTitle);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _confirmDeleteSong(
    BuildContext context,
    String playlistId,
    String songId,
    String songTitle,
  ) {
    showDialog(
      context: context,
      builder:
          (ctx) => AlertDialog(
            backgroundColor: const Color(0xFF1E1E1E),
            title: const Text(
              "Xác nhận",
              style: TextStyle(color: Colors.white),
            ),
            content: Text(
              "Bạn có chắc chắn muốn xoá bài \"$songTitle\" khỏi playlist không?",
              style: const TextStyle(color: Colors.white70),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text("Huỷ", style: TextStyle(color: Colors.grey)),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                onPressed: () async {
                  Navigator.pop(ctx); // đóng dialog
                  final success = await BlocProvider.of<PlaylistCubit>(
                    context,
                  ).removeSong(playlistId, songId);

                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          success
                              ? "Đã xoá khỏi playlist"
                              : "Xoá thất bại, vui lòng thử lại",
                        ),
                      ),
                    );
                  }
                },
                child: const Text("Xoá", style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
    );
  }
}
