import 'package:flutter/material.dart';
import 'package:spotify_b/data/providers/playlist_service.dart';

class CreatePlaylistDialog extends StatefulWidget {
  final VoidCallback? onCreated;

  const CreatePlaylistDialog({super.key, this.onCreated});

  @override
  State<CreatePlaylistDialog> createState() => _CreatePlaylistDialogState();
}

class _CreatePlaylistDialogState extends State<CreatePlaylistDialog> {
  final TextEditingController _playlistNameController = TextEditingController();
  bool _isCreating = false;

  Future<void> _createPlaylist() async {
    if (_playlistNameController.text.isEmpty) return;

    setState(() => _isCreating = true);
    try {
      final result = await PlaylistService.createPlaylist(
        _playlistNameController.text,
      );

      if (result['success'] == true) {
        if (mounted) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Đã tạo playlist ${_playlistNameController.text}'),
              backgroundColor: Colors.green,
            ),
          );
          widget.onCreated?.call();
        }
      } else {
        SnackBar(
          content: Text(result['message'] ?? 'Có lỗi xảy ra'),
          backgroundColor: Colors.red,
        );
      }
    } catch (_) {
      const SnackBar(
        content: Text('Lỗi khi tạo playlist'),
        backgroundColor: Colors.red,
      );
    } finally {
      if (mounted) setState(() => _isCreating = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color(0xFF282828),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      title: const Text(
        'Tạo playlist mới',
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      content: TextField(
        controller: _playlistNameController,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: 'Nhập tên playlist',
          hintStyle: TextStyle(color: Colors.grey[400]),
          filled: true,
          fillColor: Colors.grey[900],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isCreating ? null : () => Navigator.pop(context),
          child: Text('HỦY', style: TextStyle(color: Colors.grey[400])),
        ),
        ElevatedButton(
          onPressed: _isCreating ? null : _createPlaylist,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          child:
              _isCreating
                  ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                  : const Text('TẠO'),
        ),
      ],
    );
  }
}
