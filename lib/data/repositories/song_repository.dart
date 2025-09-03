import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'package:spotify_b/data/models/song_model.dart';
import '../../core/constants/api_constants.dart';
import '../../core/utils/auth_manager.dart';

class SongRepository {
  final Dio dio = Dio();
  Future<List<Song>> fetchRecommendedSongs() async {
    try {
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

        // Sửa ở đây: data['data'] là object, không phải array
        if (data['success'] == true && data['data'] != null) {
          final responseData = data['data'];
          final List<dynamic> songsJson = responseData['songs'] ?? [];

          return songsJson.map((e) => Song.fromJson(e)).toList();
        } else {
          throw Exception('API response format error');
        }
      } else {
        throw Exception('API error: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error in fetchRecommendedSongs: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getTrendingSongs({
    int page = 1,
    int limit = 20,
  }) async {
    try {
      debugPrint('Fetching trending songs page $page, limit $limit');

      final response = await dio.get(
        '${ApiConstants.baseUrl}/analytics/trending?page=$page&limit=$limit',
      );

      debugPrint('API response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        // debugPrint('Trending API response: ${response.data}');

        if (response.data['success'] == true && response.data['data'] != null) {
          final responseData = response.data['data'];
          final List<dynamic> songsJson = responseData['songs'] ?? [];

          final List<Song> songs =
              songsJson.map((json) => Song.fromJson(json)).toList();
          final int currentPage = responseData['page'];
          final int totalPages = responseData['totalPages'];

          // debugPrint(
          //   'Found ${songs.length} trending songs, page $currentPage/$totalPages',
          // );

          return {
            'songs': songs,
            'currentPage': currentPage,
            'totalPages': totalPages,
            'hasMore': currentPage < totalPages,
          };
        } else {
          throw Exception(
            'Invalid API response format: missing data or success flag',
          );
        }
      } else {
        throw Exception(
          'Failed to load trending songs: ${response.statusCode}',
        );
      }
    } catch (e) {
      debugPrint('Error in getTrendingSongs: $e');
      rethrow;
    }
  }

  Future<List<Song>> searchSongs(String query) async {
    try {
      final token = await AuthManager.getToken();

      final response = await dio.get(
        ApiConstants.searchSongs,
        queryParameters: {'q': query},
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200 &&
          response.data['success'] == true &&
          response.data['data'] != null) {
        final responseData = response.data['data'];
        final List<dynamic> songsJson = responseData['songs'] ?? [];

        return songsJson.map((e) => Song.fromJson(e)).toList();
      } else {
        throw Exception('Lỗi dữ liệu API không hợp lệ');
      }
    } catch (e) {
      debugPrint('Error in searchSongs: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getHotSongs({
    String range = 'week',
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final token = await AuthManager.getToken();
      if (token == null) {
        throw Exception('Chưa đăng nhập');
      }

      debugPrint(
        'Fetching hot songs with range: $range, page: $page, limit: $limit',
      );

      final response = await dio.get(
        '${ApiConstants.baseUrl}/analytics/hot',
        queryParameters: {
          'range': range,
          'page': page.toString(),
          'limit': limit.toString(),
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      debugPrint('Hot API response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        // debugPrint('Hot API response: ${response.data}');

        if (response.data['success'] == true && response.data['data'] != null) {
          final responseData = response.data['data'];
          final List<dynamic> songsJson = responseData['songs'] ?? [];

          final List<Song> songs =
              songsJson.map((json) => Song.fromJson(json)).toList();
          final int currentPage = responseData['page'];
          final int totalPages = responseData['totalPages'];

          debugPrint(
            'Found ${songs.length} hot songs, page $currentPage/$totalPages',
          );

          return {
            'songs': songs,
            'currentPage': currentPage,
            'totalPages': totalPages,
            'hasMore': currentPage < totalPages,
          };
        } else {
          throw Exception(
            'Invalid API response format: missing data or success flag',
          );
        }
      } else {
        throw Exception('Failed to load hot songs: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error in getHotSongs: $e');
      rethrow;
    }
  }
}
