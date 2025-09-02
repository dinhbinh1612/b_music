import 'package:spotify_b/data/models/song_model.dart';

class RecommendedSongsState {
  final List<Song> songs;
  final bool loading;
  final String? error;

  RecommendedSongsState({this.songs = const [], this.loading = false, this.error});

  RecommendedSongsState copyWith({List<Song>? songs, bool? loading, String? error}) {
    return RecommendedSongsState(
      songs: songs ?? this.songs,
      loading: loading ?? this.loading,
      error: error,
    );
  }
}