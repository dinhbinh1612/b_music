import 'package:flutter/material.dart';
import 'package:spotify_b/data/models/song_model.dart';
import 'package:spotify_b/data/providers/playlist_service.dart';
import 'package:spotify_b/presentation/screens/hometabbottom/library/widget/user_playlist_list.dart';

class PlaylistSelector extends StatelessWidget {
  final Song currentSong;

  const PlaylistSelector({super.key, required this.currentSong});

  Future<void> _addToPlaylist(
    BuildContext context,
    String playlistId,
    Song song,
  ) async {
    try {
      final result = await PlaylistService.addSongToPlaylist(
        playlistId,
        song.id,
      );

      if (result['message'] == 'Song already exists in this playlist') {
        const SnackBar(
          content: Text('Bài hát đã có trong playlist này'),
          backgroundColor: Colors.orange,
        );
      } else {
        const SnackBar(
          content: Text('Đã thêm bài hát vào playlist'),
          backgroundColor: Colors.green,
        );
      }
      // ignore: use_build_context_synchronously
      Navigator.pop(context); // đóng modal sau khi chọn
    } catch (e) {
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(
      //     content: Text('Lỗi khi thêm bài hát: $e'),
      //     backgroundColor: Colors.red,
      //   ),
      // );
    }
  }

  @override
  Widget build(BuildContext context) {
    return UserPlaylistList(
      onPlaylistTap: (playlist) {
        _addToPlaylist(context, playlist['id'], currentSong);
      },
    );
  }
}
