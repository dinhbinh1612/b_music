import 'package:flutter/material.dart';
import 'package:spotify_b/data/providers/playlist_service.dart';
import 'package:spotify_b/presentation/screens/hometabbottom/library/widget/playlist_detail_screen.dart';
import 'package:spotify_b/presentation/screens/hometabbottom/library/widget/playlist_item.dart';

class UserPlaylistList extends StatefulWidget {
  final Function(Map<String, dynamic> playlist)? onPlaylistTap;

  const UserPlaylistList({super.key, this.onPlaylistTap});

  @override
  State<UserPlaylistList> createState() => _UserPlaylistListState();
}

class _UserPlaylistListState extends State<UserPlaylistList> {
  List<dynamic> _userPlaylists = [];
  bool _loading = true;

  static const List<Color> _colorPalette = [
    Color(0xFF1DB954), // Spotify green
    Color(0xFFFF4D4D), // Red
    Color(0xFF4D94FF), // Blue
    Color(0xFFFFCC00), // Yellow
    Color(0xFF9933FF), // Purple
    Color(0xFFFF6600), // Orange
    Color(0xFF00CCCC), // Teal
    Color(0xFFCC0066), // Pink
    Color(0xFF66CC00), // Light green
    Color(0xFF0066CC), // Dark blue
  ];

  @override
  void initState() {
    super.initState();
    _fetchPlaylists();
  }

  Future<void> _fetchPlaylists() async {
    try {
      final playlists = await PlaylistService.getPlaylists();
      setState(() {
        _userPlaylists = playlists;
        _loading = false;
      });
    } catch (e) {
      setState(() => _loading = false);
    }
  }

  Color _getColorFromName(String name) {
    if (name.isEmpty) return _colorPalette[0];
    final hash = name.hashCode;
    final index = hash % _colorPalette.length;
    return _colorPalette[index.abs()];
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
        ),
      );
    }

    if (_userPlaylists.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.playlist_add, size: 50, color: Colors.grey[600]),
            const SizedBox(height: 16),
            Text(
              'Chưa có playlist nào',
              style: TextStyle(color: Colors.grey[500]),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _userPlaylists.length,
      itemBuilder: (context, index) {
        final playlist = _userPlaylists[index];
        final name = playlist['name'] ?? '';
        final color = _getColorFromName(name);

        return PlaylistItem(
          title: name,
          songCount: (playlist['songCount'] ?? 0) as int,
          color: color,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder:
                    (_) => PlaylistDetailScreen(playlistId: playlist['id']),
              ),
            );
          },
          playlistId: '',
        );
      },
    );
  }
}
