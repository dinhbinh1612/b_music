import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:spotify_b/core/constants/api_constants.dart';
import 'package:spotify_b/core/utils/auth_manager.dart';

class PlaylistService {
  static Future<Map<String, dynamic>> createPlaylist(String name) async {
    try {
      final token = await AuthManager.getToken();
      if (token == null) {
        throw Exception('No authentication token found');
      }

      final response = await http.post(
        Uri.parse(ApiConstants.createPlaylist),
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
        if (responseData['message'] ==
            'You already have a playlist with this name') {
          return {'success': false, 'message': responseData['message']};
        }
        throw Exception('Failed to create playlist');
      } else {
        throw Exception('Failed to create playlist');
      }
    } catch (e) {
      rethrow;
    }
  }
}
