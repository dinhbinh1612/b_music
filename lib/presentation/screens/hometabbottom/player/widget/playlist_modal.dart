import 'package:flutter/material.dart';
import 'package:spotify_b/data/models/song_model.dart';
import 'package:spotify_b/presentation/screens/hometabbottom/player/widget/playlist_header.dart';
import 'package:spotify_b/presentation/screens/hometabbottom/player/widget/playlist_options.dart';
import 'package:spotify_b/presentation/screens/hometabbottom/player/widget/playlist_selector.dart';

class PlaylistModal extends StatefulWidget {
  final Song currentSong;

  const PlaylistModal({super.key, required this.currentSong});

  @override
  State<PlaylistModal> createState() => _PlaylistModalState();
}

class _PlaylistModalState extends State<PlaylistModal> {
  bool _expanded = false;

  void _toggleExpanded() {
    setState(() => _expanded = !_expanded);
  }

  void _expandAfterCreate() {
    setState(() => _expanded = true);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF282828),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle bar
          Center(
            child: Container(
              width: 60,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey[600],
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Song info
          PlaylistHeader(song: widget.currentSong),

          const SizedBox(height: 24),
          const Divider(color: Colors.grey, height: 1),

          // Options
          PlaylistOptions(
            currentSong: widget.currentSong,
            expanded: _expanded,
            onToggleExpanded: _toggleExpanded,
            onExpandAfterCreate: _expandAfterCreate,
          ),

          // Playlist selector
          if (_expanded) ...[
            const SizedBox(height: 16),
            Text(
              'CHỌN PLAYLIST',
              style: TextStyle(
                color: Colors.grey[500],
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 250,
              child: PlaylistSelector(currentSong: widget.currentSong),
            ),
          ],
        ],
      ),
    );
  }
}
