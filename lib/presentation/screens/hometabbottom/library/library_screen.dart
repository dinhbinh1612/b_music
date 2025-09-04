import 'package:flutter/material.dart';
import 'package:spotify_b/presentation/screens/hometabbottom/library/favorite_screen.dart';
import 'package:spotify_b/presentation/screens/hometabbottom/library/history_screen.dart';
import 'package:spotify_b/presentation/screens/hometabbottom/library/widget/library_category_item.dart';
import 'package:spotify_b/presentation/screens/hometabbottom/player/widget/user_playlist_list.dart';

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
          LibraryCategoryItem(
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
          LibraryCategoryItem(
            icon: Icons.history,
            title: 'Lịch sử nghe nhạc',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const HistoryScreen()),
              );
            },
          ),
          const SizedBox(height: 16),

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

          // Danh sách playlist thực tế
          const UserPlaylistList(),
        ],
      ),
    );
  }
}
