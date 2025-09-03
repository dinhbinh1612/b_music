import 'package:spotify_b/data/models/song_model.dart';

class HotState {
  final List<Song> songs;
  final bool isLoading;
  final String? error;
  final int page;
  final int totalPages;
  final bool hasMore;
  final String range; // week/month/year

  HotState({
    this.songs = const [],
    this.isLoading = false,
    this.error,
    this.page = 1,
    this.totalPages = 1,
    this.hasMore = true,
    this.range = 'week',
  });

  HotState copyWith({
    List<Song>? songs,
    bool? isLoading,
    String? error,
    int? page,
    int? totalPages,
    bool? hasMore,
    String? range,
  }) {
    return HotState(
      songs: songs ?? this.songs,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      page: page ?? this.page,
      totalPages: totalPages ?? this.totalPages,
      hasMore: hasMore ?? this.hasMore,
      range: range ?? this.range,
    );
  }
}
