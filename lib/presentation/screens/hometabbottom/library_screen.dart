import 'package:flutter/material.dart';

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
        padding: const EdgeInsets.all(16),
        children: [
          // Danh mục Bài hát đã thích
          _LibraryCategory(
            icon: Icons.favorite,
            title: 'Bài hát đã thích',
            count: 125,
            onTap: () {
              // TODO: Điều hướng đến trang bài hát đã thích
            },
          ),
          const SizedBox(height: 16),
          
          // Danh mục Lịch sử nghe
          _LibraryCategory(
            icon: Icons.history,
            title: 'Lịch sử nghe nhạc',
            count: 89,
            onTap: () {
              // TODO: Điều hướng đến trang lịch sử nghe
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Tạo playlist mới
        },
        backgroundColor: const Color(0xFF1DB954),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

class _LibraryCategory extends StatelessWidget {
  final IconData icon;
  final String title;
  final int count;
  final VoidCallback onTap;

  const _LibraryCategory({
    required this.icon,
    required this.title,
    required this.count,
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
          decoration: BoxDecoration(
            color: const Color(0xFF1DB954).withOpacity(0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: const Color(0xFF1DB954)),
        ),
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          '$count bài hát',
          style: TextStyle(color: Colors.white.withOpacity(0.7)),
        ),
        trailing: Icon(Icons.arrow_forward, color: Colors.white.withOpacity(0.7)),
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
      margin: const EdgeInsets.only(bottom: 12),
      color: Colors.white10,
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