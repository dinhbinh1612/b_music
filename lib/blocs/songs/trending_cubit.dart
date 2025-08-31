import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify_b/data/repositories/song_repository.dart';
import 'package:spotify_b/data/models/song_model.dart';

part 'trending_state.dart';

class TrendingCubit extends Cubit<TrendingState> {
  final SongRepository _songRepository;

  TrendingCubit({SongRepository? songRepository})
      : _songRepository = songRepository ?? SongRepository(),
        super(TrendingInitial());

  Future<void> loadTrendingSongs() async {
    emit(TrendingLoading());
    try {
      final songs = await _songRepository.getTrendingSongs();
      emit(TrendingLoaded(songs));
    } catch (e) {
      emit(TrendingError(e.toString()));
    }
  }
}