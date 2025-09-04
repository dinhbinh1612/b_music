import 'package:flutter/material.dart';
import 'package:spotify_b/data/models/song_model.dart';

class SongListItem extends StatelessWidget {
  final Song song;
  final int rank;
  final VoidCallback onTap;

  const SongListItem({
    super.key,
    required this.song,
    required this.rank,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      splashColor: const Color(0xFF1DB954).withOpacity(0.3),
      highlightColor: Colors.white.withOpacity(0.1),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        height: 70,
        child: Row(
          children: [
            SizedBox(
              width: 30,
              child: Text(
                '$rank',
                style: TextStyle(
                  color: rank <= 3
                      ? const Color(0xFF1DB954)
                      : Colors.white.withOpacity(0.7),
                  fontSize: 16,
                  fontWeight: rank <= 3 ? FontWeight.bold : FontWeight.normal,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(width: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: Image.network(
                song.fullCoverUrl,
                width: 54,
                height: 54,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  width: 54,
                  height: 54,
                  color: Colors.grey[800],
                  child: const Icon(Icons.music_note, color: Colors.white70),
                ),
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    width: 54,
                    height: 54,
                    color: Colors.grey[800],
                    child: const Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white70),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    song.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    song.artist,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 14,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Row(
                children: [
                  const Icon(Icons.play_arrow, color: Colors.white70, size: 16),
                  const SizedBox(width: 4),
                  Text(
                    '${song.playCount}',
                    style: const TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.favorite_border, color: Colors.white70),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
