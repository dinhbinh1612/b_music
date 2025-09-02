import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify_b/blocs/songs/recommended_songs_state.dart';
import 'package:spotify_b/data/repositories/song_repository.dart';

class RecommendedSongCubit extends Cubit<RecommendedSongsState> {
  final SongRepository repository;

  RecommendedSongCubit(this.repository) : super(RecommendedSongsState());

  Future<void> loadRecommendedSongs() async {
    emit(state.copyWith(loading: true, error: null));
    try {
      final songs = await repository.fetchRecommendedSongs();
      emit(state.copyWith(songs: songs, loading: false));
    } catch (e) {
      // print("Lỗi load songs: $e");
      // emit(state.copyWith(error: e.toString(), loading: false));
    }
  }
}
