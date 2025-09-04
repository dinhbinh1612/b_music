import 'package:flutter/material.dart';
import 'package:spotify_b/data/models/song_model.dart';
import 'package:spotify_b/data/providers/playlist_service.dart';

class PlaylistModal extends StatefulWidget {
  final Song currentSong;

  const PlaylistModal({super.key, required this.currentSong});

  @override
  State<PlaylistModal> createState() => _PlaylistModalState();
}

class _PlaylistModalState extends State<PlaylistModal> {
  bool _expanded = false;
  final TextEditingController _playlistNameController = TextEditingController();
  bool _isCreating = false;

  final List<String> _userPlaylists = [
    'My Favorites',
    'Chill Vibes',
    'Workout Mix',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF282828),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[600],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Song info
          ListTile(
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: Image.network(
                widget.currentSong.fullCoverUrl,
                width: 50,
                height: 50,
                fit: BoxFit.cover,
                errorBuilder:
                    (_, __, ___) => Container(
                      width: 50,
                      height: 50,
                      color: Colors.grey[800],
                      child: const Icon(Icons.music_note, color: Colors.white),
                    ),
              ),
            ),
            title: Text(
              widget.currentSong.title,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Text(
              widget.currentSong.artist,
              style: TextStyle(color: Colors.grey[400]),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const Divider(color: Colors.grey, height: 24),

          // Tạo playlist mới
          ListTile(
            leading: const Icon(Icons.add, color: Colors.white),
            title: const Text(
              'Tạo playlist mới',
              style: TextStyle(color: Colors.white),
            ),
            onTap: () => _showCreatePlaylistDialog(context),
          ),

          // Thêm vào playlist
          ListTile(
            leading: const Icon(Icons.playlist_add, color: Colors.white),
            title: const Text(
              'Thêm vào playlist',
              style: TextStyle(color: Colors.white),
            ),
            trailing: Icon(
              _expanded ? Icons.expand_less : Icons.expand_more,
              color: Colors.white,
            ),
            onTap: () => setState(() => _expanded = !_expanded),
          ),

          if (_expanded)
            SizedBox(
              height: 200,
              child: ListView.builder(
                itemCount: _userPlaylists.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: const Icon(Icons.queue_music, color: Colors.white),
                    title: Text(
                      _userPlaylists[index],
                      style: const TextStyle(color: Colors.white),
                    ),
                    onTap: () {
                      _addToPlaylist(_userPlaylists[index], widget.currentSong);
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Đã thêm vào ${_userPlaylists[index]}'),
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
        ],
      ),
    );
  }

  void _showCreatePlaylistDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: const Color(0xFF282828),
            title: const Text(
              'Tạo playlist mới',
              style: TextStyle(color: Colors.white),
            ),
            content: TextField(
              controller: _playlistNameController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Nhập tên playlist',
                hintStyle: TextStyle(color: Colors.grey[400]),
              ),
            ),
            actions: [
              TextButton(
                onPressed: _isCreating ? null : () => Navigator.pop(context),
                child: const Text('HỦY', style: TextStyle(color: Colors.white)),
              ),
              TextButton(
                onPressed:
                    _isCreating
                        ? null
                        : () async {
                          if (_playlistNameController.text.isNotEmpty) {
                            setState(() => _isCreating = true);
                            await _createPlaylist(_playlistNameController.text);
                            setState(() => _isCreating = false);

                            // Check if the widget is still mounted before using context
                            if (!mounted) return;
                            // ignore: use_build_context_synchronously
                            Navigator.pop(context);
                            // ignore: use_build_context_synchronously
                            Navigator.pop(context);
                            // ignore: use_build_context_synchronously
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Đã tạo playlist ${_playlistNameController.text} thành công',
                                ),
                                backgroundColor: Colors.grey,
                              ),
                            );
                          }
                        },
                child:
                    _isCreating
                        ? const CircularProgressIndicator()
                        : const Text(
                          'TẠO',
                          style: TextStyle(color: Colors.green),
                        ),
              ),
            ],
          ),
    );
  }

  Future<void> _createPlaylist(String name) async {
    try {
      final result = await PlaylistService.createPlaylist(name);
      if (!mounted) return;
      if (result['success'] != true && mounted) {
        // Show error message if needed
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['message'] ?? 'Có lỗi xảy ra'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Lỗi khi tạo playlist: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _addToPlaylist(String playlistName, Song song) {
    print('Adding ${song.title} to $playlistName');
  }
}
