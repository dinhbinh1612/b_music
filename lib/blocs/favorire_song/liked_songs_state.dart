import 'package:spotify_b/data/models/song_model.dart';

abstract class LikedSongsState {}

class LikedSongsInitial extends LikedSongsState {}

class LikedSongsLoading extends LikedSongsState {}

class LikedSongsLoaded extends LikedSongsState {
  final List<Song> songs;
  final bool hasMore;

  LikedSongsLoaded({required this.songs, required this.hasMore});
}

class LikedSongsError extends LikedSongsState {
  final String message;
  LikedSongsError(this.message);
}
