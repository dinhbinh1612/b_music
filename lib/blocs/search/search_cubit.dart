import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify_b/data/models/song_model.dart';
import 'package:spotify_b/data/repositories/song_repository.dart';

class SearchState {
  final List<Song> results;
  final bool isLoading;
  final String? error;

  SearchState({
    this.results = const [],
    this.isLoading = false,
    this.error,
  });

  SearchState copyWith({
    List<Song>? results,
    bool? isLoading,
    String? error,
  }) {
    return SearchState(
      results: results ?? this.results,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class SearchCubit extends Cubit<SearchState> {
  final SongRepository repository;

  SearchCubit(this.repository) : super(SearchState());

  Future<void> search(String query) async {
    if (query.isEmpty) {
      emit(state.copyWith(results: [], isLoading: false, error: null));
      return;
    }

    emit(state.copyWith(isLoading: true, error: null));
    try {
      final songs = await repository.searchSongs(query);
      emit(state.copyWith(results: songs, isLoading: false));
    } catch (e) {
      emit(state.copyWith(
        error: e.toString(),
        isLoading: false,
      ));
    }
  }
}
