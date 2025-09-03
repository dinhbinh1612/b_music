import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify_b/data/repositories/song_repository.dart';
import 'hot_state.dart';
import '../../data/models/song_model.dart';

class HotCubit extends Cubit<HotState> {
  final SongRepository repository;

  HotCubit(this.repository) : super(HotState());

  Future<void> fetchHot({String? range, int page = 1}) async {
    if (state.isLoading) return;

    try {
      final currentRange = range ?? state.range;
      emit(
        state.copyWith(
          isLoading: true,
          error: null,
          range: currentRange,
          // Reset songs when changing range or loading first page
          songs: page == 1 ? [] : state.songs,
        ),
      );

      // Gọi API hot
      final response = await repository.getHotSongs(
        range: currentRange,
        page: page,
        limit: 20,
      );

      final List<Song> newSongs = response['songs'];
      final bool hasMore = response['hasMore'];
      final int currentPage = response['currentPage'];
      final int totalPages = response['totalPages'];

      final allSongs = page == 1 ? newSongs : [...state.songs, ...newSongs];

      emit(
        state.copyWith(
          songs: allSongs,
          page: currentPage,
          totalPages: totalPages,
          hasMore: hasMore,
          isLoading: false,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          error: e.toString(),
          // Keep existing songs if we're loading more and get an error
          songs: page == 1 ? [] : state.songs,
        ),
      );
    }
  }

  Future<void> loadMore() async {
    if (!state.hasMore || state.isLoading) return;
    await fetchHot(page: state.page + 1);
  }

  void changeRange(String newRange) {
    if (state.range != newRange) {
      fetchHot(range: newRange, page: 1);
    }
  }
}
