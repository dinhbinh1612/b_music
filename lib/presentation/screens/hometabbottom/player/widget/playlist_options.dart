import 'package:flutter/material.dart';
import 'package:spotify_b/data/models/song_model.dart';
import 'package:spotify_b/presentation/screens/hometabbottom/player/widget/create_playlist_dialog.dart';

class PlaylistOptions extends StatelessWidget {
  final Song currentSong;
  final bool expanded;
  final VoidCallback onToggleExpanded;
  final VoidCallback onExpandAfterCreate;

  const PlaylistOptions({
    super.key,
    required this.currentSong,
    required this.expanded,
    required this.onToggleExpanded,
    required this.onExpandAfterCreate,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildListTile(
          icon: Icons.add,
          title: 'Tạo playlist mới',
          onTap: () {
            showDialog(
              context: context,
              builder:
                  (_) => CreatePlaylistDialog(onCreated: onExpandAfterCreate),
            );
          },
        ),
        _buildListTile(
          icon: Icons.playlist_add,
          title: 'Thêm vào playlist',
          trailing: Icon(
            expanded ? Icons.expand_less : Icons.expand_more,
            color: Colors.white,
          ),
          onTap: onToggleExpanded,
        ),
      ],
    );
  }

  Widget _buildListTile({
    required IconData icon,
    required String title,
    Widget? trailing,
    required VoidCallback onTap,
  }) {
    return Column(
      children: [
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: Icon(icon, color: Colors.white, size: 28),
          title: Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          trailing: trailing,
          onTap: onTap,
        ),
        const Divider(color: Colors.grey, height: 1),
      ],
    );
  }
}
