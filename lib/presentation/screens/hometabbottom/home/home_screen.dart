import 'package:flutter/material.dart';
import 'package:spotify_b/core/configs/app_routes.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: const Text(
          "Music BKL",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        actions: [
          Icon(Icons.search, color: Colors.white),
          SizedBox(width: 12),
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, AppRoutes.account);
            },
            child: const Icon(Icons.account_circle, color: Colors.white),
          ),
          SizedBox(width: 8),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Tab bar ngang (fake, chưa có chức năng)
          SizedBox(
            height: 52,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: const [
                _TabItem(label: "Đề xuất"),
                _TabItem(label: "Bảng xếp hạng"),
                _TabItem(label: "Thể loại"),
                _TabItem(label: "Album"),
                _TabItem(label: "Nghệ sĩ"),
              ],
            ),
          ),
          const Divider(color: Colors.white24, height: 1),

          /// Nội dung chính: danh sách playlist
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(12),
              children: [
                const _SectionTitle(title: "Dành cho bạn"),
                const SizedBox(height: 12),
                _PlaylistGrid(
                  items: List.generate(6, (i) => "Playlist ${i + 1}"),
                ),
                const SizedBox(height: 24),

                const _SectionTitle(title: "Xu hướng"),
                const SizedBox(height: 12),
                _PlaylistGrid(
                  items: List.generate(6, (i) => "Xu hướng ${i + 1}"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Widget cho TabItem
class _TabItem extends StatelessWidget {
  final String label;
  const _TabItem({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(label, style: const TextStyle(color: Colors.white)),
    );
  }
}

/// Widget cho tiêu đề section
class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

/// Grid playlist
class _PlaylistGrid extends StatelessWidget {
  final List<String> items;
  const _PlaylistGrid({required this.items});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: items.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1,
      ),
      itemBuilder: (context, index) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white10,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[800],
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(12),
                    ),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.music_note,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  items[index],
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
