import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify_b/blocs/songs/songs_state.dart';
import 'package:spotify_b/data/repositories/song_repository.dart';

class SongCubit extends Cubit<SongState> {
  final SongRepository repository;

  SongCubit(this.repository) : super(SongState());

  Future<void> loadRecommendedSongs() async {
    emit(state.copyWith(loading: true, error: null));
    try {
      final songs = await repository.fetchRecommendedSongs();
      // print("✅ Đã load ${songs.length} bài hát");
      // for (var song in songs) {
      //   // print("🎵 ${song.title} - ${song.artist}");
      // }

      emit(state.copyWith(songs: songs, loading: false));
    } catch (e) {
      // print("❌ Lỗi load songs: $e");
      // emit(state.copyWith(error: e.toString(), loading: false));
    }
  }
}
