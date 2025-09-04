import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:spotify_b/core/constants/api_constants.dart';
import 'package:spotify_b/core/utils/auth_manager.dart';

class PlaylistService {
  static Future<Map<String, dynamic>> createPlaylist(String name) async {
    try {
      final token = await AuthManager.getToken();
      if (token == null) throw Exception('No authentication token found');

      final response = await http.post(
        Uri.parse(ApiConstants.playlists),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({'name': name}),
      );

      if (response.statusCode == 201) {
        return {'success': true, 'message': 'Playlist created successfully'};
      } else if (response.statusCode == 400) {
        final responseData = json.decode(response.body);
        return {
          'success': false,
          'message':
              responseData['message'] ??
              'Failed to create playlist (bad request)',
        };
      } else {
        throw Exception('Failed to create playlist');
      }
    } catch (e) {
      rethrow;
    }
  }

  static Future<List<dynamic>> getPlaylists() async {
    try {
      final token = await AuthManager.getToken();
      if (token == null) throw Exception('No authentication token found');

      final response = await http.get(
        Uri.parse(ApiConstants.playlists),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load playlists');
      }
    } catch (e) {
      rethrow;
    }
  }

  static Future<Map<String, dynamic>> addSongToPlaylist(
    String playlistId,
    String songId,
  ) async {
    final token = await AuthManager.getToken();
    if (token == null) throw Exception('No authentication token found');

    final url = Uri.parse("${ApiConstants.playlists}/$playlistId/songs");

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode({"songId": songId}),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      final error = jsonDecode(response.body);
      return {"message": error['message'] ?? "Failed to add song"};
    }
  }

  /// Xóa playlist
  static Future<bool> deletePlaylist(String playlistId) async {
    try {
      final token = await AuthManager.getToken();
      if (token == null) throw Exception('No authentication token found');

      final url = Uri.parse("${ApiConstants.playlists}/$playlistId");

      final response = await http.delete(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  /// Xóa bài hát khỏi playlist
  static Future<bool> removeSongFromPlaylist(
    String playlistId,
    String songId,
  ) async {
    try {
      final token = await AuthManager.getToken();
      if (token == null) throw Exception('No authentication token found');

      final url = Uri.parse(
        "${ApiConstants.playlists}/$playlistId/songs/$songId",
      );

      final response = await http.delete(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  /// Sửa tên playlist
  static Future<bool> updatePlaylistName(
    String playlistId,
    String newName,
  ) async {
    try {
      final token = await AuthManager.getToken();
      if (token == null) throw Exception('No authentication token found');

      final url = Uri.parse("${ApiConstants.playlists}/$playlistId");

      final response = await http.patch(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({'name': newName}),
      );

      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}
