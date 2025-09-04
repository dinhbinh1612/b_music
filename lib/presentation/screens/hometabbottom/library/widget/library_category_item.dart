import 'package:flutter/material.dart';

class LibraryCategoryItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const LibraryCategoryItem({super.key, 
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
        title: Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        trailing: Icon(Icons.arrow_forward, color: Colors.white.withOpacity(0.7)),
        onTap: onTap,
      ),
    );
  }
}
