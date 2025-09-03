import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:spotify_b/blocs/player/player_song_cubit.dart';
import 'package:spotify_b/data/models/song_model.dart';

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
              return IconButton(
                icon: const Icon(Icons.more_vert, color: Colors.white),
                onPressed: null,
              );
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
            return _PlayerContent(state: state);
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

// Add this new widget for the playlist modal
class PlaylistModal extends StatefulWidget {
  final Song currentSong;

  const PlaylistModal({super.key, required this.currentSong});

  @override
  State<PlaylistModal> createState() => _PlaylistModalState();
}

class _PlaylistModalState extends State<PlaylistModal> {
  bool _expanded = false;
  final TextEditingController _playlistNameController = TextEditingController();

  // This would typically come from your database or state management
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
            contentPadding: EdgeInsets.zero,
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: Image.network(
                widget.currentSong.fullCoverUrl,
                width: 50,
                height: 50,
                fit: BoxFit.cover,
                errorBuilder:
                    (context, error, stackTrace) => Container(
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
          // Create playlist option
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.add, color: Colors.white),
            title: const Text(
              'Tạo playlist mới',
              style: TextStyle(color: Colors.white),
            ),
            onTap: () {
              _showCreatePlaylistDialog(context);
            },
          ),
          // Add to playlist option
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.playlist_add, color: Colors.white),
            title: const Text(
              'Thêm vào playlist',
              style: TextStyle(color: Colors.white),
            ),
            trailing: Icon(
              _expanded ? Icons.expand_less : Icons.expand_more,
              color: Colors.white,
            ),
            onTap: () {
              setState(() {
                _expanded = !_expanded;
              });
            },
          ),
          // Playlist list (expanded)
          if (_expanded) ...[
            const SizedBox(height: 8),
            SizedBox(
              height: 200, // Fixed height for the list
              child: ListView.builder(
                itemCount: _userPlaylists.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    contentPadding: const EdgeInsets.only(left: 36),
                    leading: const Icon(Icons.queue_music, color: Colors.white),
                    title: Text(
                      _userPlaylists[index],
                      style: const TextStyle(color: Colors.white),
                    ),
                    onTap: () {
                      // Add song to this playlist
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
          const SizedBox(height: 16),
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
                enabledBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                focusedBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.green),
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('HỦY', style: TextStyle(color: Colors.white)),
              ),
              TextButton(
                onPressed: () {
                  if (_playlistNameController.text.isNotEmpty) {
                    _createPlaylist(_playlistNameController.text);
                    Navigator.pop(context);
                    Navigator.pop(context); // Also close the modal
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Đã tạo playlist ${_playlistNameController.text}',
                        ),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  }
                },
                child: const Text('TẠO', style: TextStyle(color: Colors.green)),
              ),
            ],
          ),
    );
  }

  void _createPlaylist(String name) {
    // Implement your create playlist logic here
    print('Creating playlist: $name');
    // Typically you would add this to your database or state management
  }

  void _addToPlaylist(String playlistName, Song song) {
    // Implement your add to playlist logic here
    print('Adding ${song.title} to $playlistName');
    // Typically you would update your database or state management
  }
}

class _PlayerContent extends StatefulWidget {
  final PlayerPlaying state;

  const _PlayerContent({required this.state});

  @override
  State<_PlayerContent> createState() => _PlayerContentState();
}

class _PlayerContentState extends State<_PlayerContent> {
  double? _dragValue;

  @override
  Widget build(BuildContext context) {
    final playerCubit = context.read<PlayerSongCubit>();
    final song = widget.state.currentSong;

    final position =
        _dragValue ?? widget.state.position.position.inSeconds.toDouble();
    final duration = widget.state.position.duration.inSeconds.toDouble();

    return SingleChildScrollView(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight:
              MediaQuery.of(context).size.height -
              AppBar().preferredSize.height -
              MediaQuery.of(context).padding.top,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 20),
            // Album Art
            Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.5),
                    blurRadius: 20,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  song.fullCoverUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey[800],
                      child: const Icon(
                        Icons.music_note,
                        color: Colors.white,
                        size: 64,
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 30),
            // Song Info
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                children: [
                  Text(
                    song.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    song.artist,
                    style: TextStyle(color: Colors.grey[400], fontSize: 18),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 27),
            // Like and list
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  BlocBuilder<PlayerSongCubit, PlayerSongState>(
                    builder: (context, state) {
                      if (state is! PlayerPlaying) {
                        return const SizedBox();
                      }
                      final song = state.currentSong;

                      return IconButton(
                        icon: Icon(
                          song.isLiked ? Icons.favorite : Icons.favorite_border,
                          color: song.isLiked ? Colors.red : Colors.white,
                          size: 28,
                        ),
                        onPressed: () {
                          context.read<PlayerSongCubit>().toggleLike();
                        },
                      );
                    },
                  ),

                  IconButton(
                    icon: const Icon(
                      Icons.playlist_play,
                      color: Colors.white,
                      size: 28,
                    ),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
            const SizedBox(height: 5),
            // Progress Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  SliderTheme(
                    data: SliderThemeData(
                      trackHeight: 4,
                      thumbShape: const RoundSliderThumbShape(
                        enabledThumbRadius: 8,
                      ),
                      overlayShape: const RoundSliderOverlayShape(
                        overlayRadius: 16,
                      ),
                      activeTrackColor: Colors.green,
                      inactiveTrackColor: Colors.grey,
                      thumbColor: Colors.white,
                    ),
                    child: Slider(
                      value: position.clamp(0, duration),
                      min: 0,
                      max: duration > 0 ? duration : 1,
                      onChanged: (value) {
                        setState(() {
                          _dragValue = value; // chỉ update tạm
                        });
                      },
                      onChangeStart: (_) {
                        // bắt đầu kéo → ngưng nhận update từ stream
                        setState(() {
                          _dragValue = position;
                        });
                      },
                      onChangeEnd: (value) {
                        // thả tay → gọi seek, reset drag
                        playerCubit.seek(Duration(seconds: value.toInt()));
                        setState(() {
                          _dragValue = null;
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _formatDuration(Duration(seconds: position.toInt())),
                        style: TextStyle(color: Colors.grey[400]),
                      ),
                      Text(
                        _formatDuration(Duration(seconds: duration.toInt())),
                        style: TextStyle(color: Colors.grey[400]),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            // Controls
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Shuffle
                  IconButton(
                    icon: Icon(
                      Icons.shuffle,
                      color:
                          widget.state.isShuffling
                              ? Colors.green
                              : Colors.white,
                      size: 28,
                    ),
                    onPressed: () => playerCubit.toggleShuffle(),
                  ),
                  // Previous
                  IconButton(
                    icon: const Icon(
                      Icons.skip_previous,
                      color: Colors.white,
                      size: 36,
                    ),
                    onPressed: () => playerCubit.previous(),
                  ),
                  // Play/Pause
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: IconButton(
                      icon: Icon(
                        widget.state.isPlaying ? Icons.pause : Icons.play_arrow,
                        color: Colors.black,
                        size: 36,
                      ),
                      onPressed: () {
                        if (widget.state.isPlaying) {
                          playerCubit.pause();
                        } else {
                          playerCubit.play();
                        }
                      },
                    ),
                  ),
                  // Next
                  IconButton(
                    icon: const Icon(
                      Icons.skip_next,
                      color: Colors.white,
                      size: 36,
                    ),
                    onPressed: () => playerCubit.next(),
                  ),
                  // lapw
                  IconButton(
                    icon: Icon(
                      _getRepeatIcon(widget.state.loopMode),
                      color: _getRepeatColor(widget.state.loopMode),
                      size: 28,
                    ),
                    onPressed: () => playerCubit.toggleLoopMode(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  // tinh thowif luongw
  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  IconData _getRepeatIcon(LoopMode loopMode) {
    switch (loopMode) {
      case LoopMode.off:
        return Icons.repeat;
      case LoopMode.one:
        return Icons.repeat_one;
      case LoopMode.all:
        return Icons.repeat;
    }
  }

  Color _getRepeatColor(LoopMode loopMode) {
    return loopMode == LoopMode.off
        ? Colors.white
        : const Color.fromARGB(255, 0, 72, 2);
  }
}
