import 'package:spotify_b/data/models/song_model.dart';

abstract class HistoryState {}

class HistoryInitial extends HistoryState {}

class HistoryLoading extends HistoryState {}

class HistoryLoaded extends HistoryState {
  final List<Song> songs;
  final bool hasMore;

  HistoryLoaded({
    required this.songs,
    required this.hasMore,
  });
}

class HistoryError extends HistoryState {
  final String message;

  HistoryError(this.message);
}
