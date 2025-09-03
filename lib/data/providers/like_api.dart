import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:spotify_b/core/constants/api_constants.dart';
import 'package:spotify_b/core/utils/auth_manager.dart';

class LikeApi {
  static Future<Map<String, dynamic>> toggleLike(String songId) async {
    final token = await AuthManager.getToken();

    if (token == null) {
      throw Exception("Chưa đăng nhập (no token)");
    }

    final url = Uri.parse("${ApiConstants.baseUrl}/users/songs/$songId/like");

    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception(
        "Failed to toggle like: ${response.statusCode} - ${response.body}",
      );
    }
  }
}
