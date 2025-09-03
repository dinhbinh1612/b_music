import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify_b/blocs/history_state/history_state.dart';
import 'package:spotify_b/data/models/song_model.dart';
import 'package:dio/dio.dart';
import '../../core/constants/api_constants.dart';
import '../../core/utils/auth_manager.dart';


class HistoryCubit extends Cubit<HistoryState> {
  final Dio _dio = Dio();
  final int _limit;

  int _currentPage = 1;
  bool _hasMore = true;
  bool _isLoading = false;

  final List<Song> _songs = [];

  HistoryCubit({int limit = 20}) 
      : _limit = limit, 
        super(HistoryInitial());

  Future<void> fetchHistory({bool loadMore = false}) async {
    if (_isLoading || (!_hasMore && loadMore)) return;

    _isLoading = true;
    if (!loadMore) {
      emit(HistoryLoading());
      _currentPage = 1;
      _songs.clear();
      _hasMore = true;
    }

    try {
      final token = await AuthManager.getToken();
      if (token == null) throw Exception('Chưa đăng nhập');

      final response = await _dio.get(
        ApiConstants.history, // dùng hằng số
        queryParameters: {
          'page': _currentPage,
          'limit': _limit,
        },
        options: Options(headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        }),
      );

      if (response.statusCode == 200 && response.data['success'] == true) {
        final data = response.data['data'];
        final List<dynamic> history = data['history'] ?? [];

        final newSongs = history
            .map((item) => Song.fromJson(item['song']))
            .toList();

        _songs.addAll(newSongs);

        _currentPage++;
        _hasMore = _currentPage <= (data['totalPages'] ?? 1);

        emit(HistoryLoaded(
          songs: _songs,
          hasMore: _hasMore,
        ));
      } else {
        emit(HistoryError('Lỗi tải dữ liệu'));
      }
    } catch (e) {
      emit(HistoryError(e.toString()));
    } finally {
      _isLoading = false;
    }
  }

  void refresh() => fetchHistory(loadMore: false);
}
