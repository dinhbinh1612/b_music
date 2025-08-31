import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'package:spotify_b/data/models/song_model.dart';
import '../../core/constants/api_constants.dart';
import '../../core/utils/auth_manager.dart';

class SongRepository {
  final Dio dio = Dio();
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

  Future<List<Song>> getTrendingSongs() async {
    try {
      final response = await dio.get(
        '${ApiConstants.baseUrl}/analytics/trending?limit=20',
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'] ?? [];
        return data.map((json) => Song.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load trending songs');
      }
    } catch (e) {
      throw Exception('Error loading trending songs: $e');
    }
  }
}
