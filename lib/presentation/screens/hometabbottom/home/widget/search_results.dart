import 'package:flutter/material.dart';
import 'package:spotify_b/data/models/song_model.dart';
import 'package:spotify_b/blocs/search/search_cubit.dart';
import 'package:spotify_b/presentation/screens/hometabbottom/player/music_player_screen.dart';

class SearchResults extends StatelessWidget {
  final SearchState state;

  const SearchResults({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    if (state.isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.white),
      );
    }

    if (state.error != null) {
      return Center(
        child: Text(
          "Lỗi: ${state.error}",
          style: const TextStyle(color: Colors.redAccent),
        ),
      );
    }

    if (state.results.isEmpty) {
      return const Center(
        child: Text(
          "Không có kết quả",
          style: TextStyle(color: Colors.white70),
        ),
      );
    }

    return ListView.builder(
      itemCount: state.results.length,
      itemBuilder: (context, index) {
        final Song song = state.results[index];
        return ListTile(
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              song.fullCoverUrl,
              width: 50,
              height: 50,
              fit: BoxFit.cover,
              errorBuilder:
                  (_, __, ___) =>
                      const Icon(Icons.music_note, color: Colors.white70),
            ),
          ),
          title: Text(song.title, style: const TextStyle(color: Colors.white)),
          subtitle: Text(
            song.artist,
            style: const TextStyle(color: Colors.white70),
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder:
                    (_) => MusicPlayerScreen(
                      playlist: state.results, 
                      initialIndex: index, 
                    ),
              ),
            );
          },
        );
      },
    );
  }
}
