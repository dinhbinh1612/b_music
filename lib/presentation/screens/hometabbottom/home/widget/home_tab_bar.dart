import 'package:flutter/material.dart';

class HomeTabBar extends StatelessWidget {
  const HomeTabBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
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
    );
  }
}

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
