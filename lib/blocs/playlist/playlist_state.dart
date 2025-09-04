class PlaylistState {
  final List<dynamic> playlists;
  final bool loading;
  final String? error;

  PlaylistState({
    required this.playlists,
    required this.loading,
    this.error,
  });

  PlaylistState copyWith({
    List<dynamic>? playlists,
    bool? loading,
    String? error,
  }) {
    return PlaylistState(
      playlists: playlists ?? this.playlists,
      loading: loading ?? this.loading,
      error: error,
    );
  }
}