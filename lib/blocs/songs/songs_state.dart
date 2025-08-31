import 'package:spotify_b/data/models/song_model.dart';

class SongState {
  final List<Song> songs;
  final bool loading;
  final String? error;

  SongState({this.songs = const [], this.loading = false, this.error});

  SongState copyWith({List<Song>? songs, bool? loading, String? error}) {
    return SongState(
      songs: songs ?? this.songs,
      loading: loading ?? this.loading,
      error: error,
    );
  }
}