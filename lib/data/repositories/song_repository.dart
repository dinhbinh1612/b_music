import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:spotify_b/data/models/song_model.dart';
import '../../core/constants/api_constants.dart';
import '../../core/utils/auth_manager.dart'; // Thêm import này

class SongRepository {
  Future<List<Song>> fetchRecommendedSongs() async {
    try {
      // Lấy token từ AuthManager
      final token = await AuthManager.getToken();
      
      if (token == null) {
        throw Exception('Chưa đăng nhập');
      }

      final response = await http.get(
        Uri.parse(ApiConstants.recommendSongs),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<dynamic> songsJson = (data['data'] ?? []) as List;
        return songsJson.map((e) => Song.fromJson(e)).toList();
      } else {
        throw Exception('API error: ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }
}