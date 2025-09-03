import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:spotify_b/core/constants/api_constants.dart';
import 'package:spotify_b/core/utils/auth_manager.dart';

class AnalyticsApi {
  // Gửi lượt nghe
  static Future<void> trackPlay({
    required String songId,
    required int duration,
  }) async {
    try {
      final token = await AuthManager.getToken(); // lấy token đã lưu
      final url = Uri.parse(ApiConstants.trackPlay);

      final body = jsonEncode({"songId": songId, "duration": duration});

      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: body,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data["success"] == true) {
          debugPrint("Play tracked: ${data["data"]}");
        } else {
          debugPrint("Failed to track play: ${data["message"]}");
        }
      } else {
        debugPrint("HTTP Error ${response.statusCode}: ${response.body}");
      }
    } catch (e) {
      debugPrint("Error tracking play: $e");
    }
  }
}
