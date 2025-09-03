import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify_b/blocs/favorire_song/liked_songs_state.dart';
import 'package:spotify_b/data/models/song_model.dart';
import 'package:dio/dio.dart';
import '../../core/constants/api_constants.dart';
import '../../core/utils/auth_manager.dart';

class LikedSongsCubit extends Cubit<LikedSongsState> {
  final Dio _dio = Dio();
  final int _limit;

  int _currentPage = 1;
  bool _hasMore = true;
  bool _isLoading = false;

  final List<Song> _songs = [];

  LikedSongsCubit({int limit = 20})
    : _limit = limit,
      super(LikedSongsInitial());

  Future<void> fetchLikedSongs({bool loadMore = false}) async {
    if (_isLoading || (!_hasMore && loadMore)) return;

    _isLoading = true;
    if (!loadMore) {
      emit(LikedSongsLoading());
      _currentPage = 1;
      _songs.clear();
      _hasMore = true;
    }

    try {
      final token = await AuthManager.getToken();
      if (token == null) throw Exception('Chưa đăng nhập');

      final response = await _dio.get(
        ApiConstants.likeSong,
        queryParameters: {'page': _currentPage, 'limit': _limit},
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200 && response.data['success'] == true) {
        final data = response.data['data'];
        final List<dynamic> liked = data['songs'] ?? [];
        final newSongs = liked.map((item) => Song.fromJson(item)).toList();

        _songs.addAll(newSongs);

        _currentPage++;
        _hasMore = _currentPage <= (data['totalPages'] ?? 1);

        emit(LikedSongsLoaded(songs: _songs, hasMore: _hasMore));
      } else {
        emit(LikedSongsError('Lỗi tải dữ liệu'));
      }
    } catch (e) {
      emit(LikedSongsError(e.toString()));
    } finally {
      _isLoading = false;
    }
  }

  void refresh() => fetchLikedSongs(loadMore: false);
}
