import 'package:flutter/material.dart';
import 'package:spotify_b/presentation/screens/hometabbottom/history/favorite_screen.dart';
import 'package:spotify_b/presentation/screens/hometabbottom/history/history_screen.dart';

class LibraryScreen extends StatelessWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Thư viện',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(10),
        children: [
          // Danh mục Bài hát đã thích
          _LibraryCategory(
            icon: Icons.favorite,
            title: 'Bài hát đã thích',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const FavoriteScreen()),
              );
            },
          ),
          const SizedBox(height: 5),

          // Danh mục Lịch sử nghe
          _LibraryCategory(
            icon: Icons.history,
            title: 'Lịch sử nghe nhạc',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => HistoryScreen()),
              );
            },
          ),
          const SizedBox(height: 16),

          // Tiêu đề Playlist
          const Padding(
            padding: EdgeInsets.only(bottom: 16),
            child: Text(
              'Playlist của bạn',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          // Danh sách Playlist
          _PlaylistItem(
            title: 'Workout Mix',
            songCount: 25,
            color: Colors.purple[800]!,
            onTap: () {
              // TODO: Mở playlist
            },
          ),
          _PlaylistItem(
            title: 'Chill Vibes',
            songCount: 42,
            color: Colors.blue[800]!,
            onTap: () {
              // TODO: Mở playlist
            },
          ),
          _PlaylistItem(
            title: 'Party Time',
            songCount: 38,
            color: Colors.red[800]!,
            onTap: () {
              // TODO: Mở playlist
            },
          ),
          _PlaylistItem(
            title: 'Focus Mode',
            songCount: 31,
            color: Colors.green[800]!,
            onTap: () {
              // TODO: Mở playlist
            },
          ),
          _PlaylistItem(
            title: 'Road Trip',
            songCount: 47,
            color: Colors.orange[800]!,
            onTap: () {
              // TODO: Mở playlist
            },
          ),
          
        ],
      ),
    );
  }
}

class _LibraryCategory extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _LibraryCategory({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white10,
      child: ListTile(
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
          child: Icon(icon, color: const Color(0xFF1DB954)),
        ),
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),

        trailing: Icon(
          Icons.arrow_forward,
          color: Colors.white.withOpacity(0.7),
        ),
        onTap: onTap,
      ),
    );
  }
}

class _PlaylistItem extends StatelessWidget {
  final String title;
  final int songCount;
  final Color color;
  final VoidCallback onTap;

  const _PlaylistItem({
    required this.title,
    required this.songCount,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color.fromARGB(26, 234, 212, 212),
      child: ListTile(
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
          child: const Icon(Icons.music_note, color: Colors.white),
        ),
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Text(
          '$songCount bài hát',
          style: TextStyle(color: Colors.white.withOpacity(0.7)),
        ),
        trailing: IconButton(
          icon: Icon(Icons.more_vert, color: Colors.white.withOpacity(0.7)),
          onPressed: () {
            // TODO: Hiển thị menu tùy chọn
          },
        ),
        onTap: onTap,
      ),
    );
  }
}
