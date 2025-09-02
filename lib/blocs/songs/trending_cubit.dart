import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify_b/data/repositories/song_repository.dart';
import 'package:spotify_b/data/models/song_model.dart';
part 'trending_state.dart';

class TrendingCubit extends Cubit<TrendingState> {
  final SongRepository _songRepository;
  int _page = 1;
  bool _isLoadingMore = false;
  bool _hasMore = true;

  TrendingCubit({SongRepository? songRepository})
    : _songRepository = songRepository ?? SongRepository(),
      super(TrendingInitial());

  bool get hasMore => _hasMore;
  bool get isLoadingMore => _isLoadingMore;
  Future<void> loadTrendingSongs({bool loadMore = false}) async {
    if (_isLoadingMore) {
      debugPrint('Already loading, skipping...');
      return;
    }
    if (loadMore && !_hasMore) {
      debugPrint('No more data to load');
      return;
    }

    debugPrint('Loading trending songs, page: $_page, loadMore: $loadMore');

    if (!loadMore) {
      emit(TrendingLoading());
      _page = 1;
    } else {
      _isLoadingMore = true;
      _page++;
    }

    try {
      final result = await _songRepository.getTrendingSongs(
        page: _page,
        limit: 20,
      );

      debugPrint(
        'API result: ${result['songs'].length} songs, hasMore: ${result['hasMore']}',
      );

      final List<Song> newSongs = result['songs'];
      _hasMore = result['hasMore'];

      if (state is TrendingLoaded && loadMore) {
        final currentSongs = (state as TrendingLoaded).songs;
        emit(TrendingLoaded([...currentSongs, ...newSongs], hasMore: _hasMore));
      } else {
        emit(TrendingLoaded(newSongs, hasMore: _hasMore));
      }

      _isLoadingMore = false;
    } catch (e) {
      debugPrint('Error loading trending songs: $e');
      if (loadMore) {
        _page--;
      }
      emit(TrendingError(e.toString()));
      _isLoadingMore = false;
    }
  }
}
