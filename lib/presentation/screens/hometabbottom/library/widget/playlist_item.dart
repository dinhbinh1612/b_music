import 'package:flutter/material.dart';

class PlaylistItem extends StatelessWidget {
  final String title;
  final int songCount;
  final Color color;
  final VoidCallback onTap;

  const PlaylistItem({
    super.key,
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
