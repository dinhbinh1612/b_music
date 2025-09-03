import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:spotify_b/core/constants/api_constants.dart';
import 'package:spotify_b/core/utils/auth_manager.dart';
import 'package:spotify_b/data/models/profile_model.dart';
import 'package:spotify_b/data/models/user_login_model.dart';
import 'package:spotify_b/data/models/user_register_model.dart';

class AuthProvider {
  // Hàm đăng ký người dùng
  Future<void> registerUser(UserRegisterModel user) async {
    final uri = Uri.parse(ApiConstants.register);
    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(user.toJson()),
    );
    final json = jsonDecode(response.body);
    if (response.statusCode != 200 && response.statusCode != 201) {
      // Chỉ ném message gốc, không ném cả Exception
      throw json["message"] ?? "Đăng ký thất bại";
    }
    return;
  }

  // Hàm đăng nhập
  Future<Map<String, dynamic>> login(UserLoginModel user) async {
    final response = await http.post(
      Uri.parse(ApiConstants.login),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(user.toJson()),
    );

    final responseBody = json.decode(response.body);
    if (response.statusCode == 200) {
      return responseBody;
    } else {
      throw Exception(responseBody['message'] ?? 'Đăng nhập thất bại');
    }
  }

  // Hàm lấy profile
  Future<Profile> getProfile(String token) async {
    final response = await http.get(
      Uri.parse(ApiConstants.profile),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return Profile.fromJson(json.decode(response.body));
    } else if (response.statusCode == 401) {
      // Token hết hạn hoặc không hợp lệ
      await AuthManager.clearToken();
      throw Exception("Token hết hạn, vui lòng đăng nhập lại");
    } else {
      throw Exception("Lấy profile thất bại");
    }
  }

  // Upload avatar
  Future<void> uploadAvatar(String token, File avatarFile) async {
    final uri = Uri.parse(ApiConstants.uploadAvatar);

    final request =
        http.MultipartRequest("POST", uri)
          ..headers['Authorization'] = 'Bearer $token'
          ..files.add(
            await http.MultipartFile.fromPath('avatar', avatarFile.path),
          );

    final response = await request.send();

    if (response.statusCode != 200 && response.statusCode != 201) {
      final respStr = await response.stream.bytesToString();
      throw Exception("Upload thất bại: $respStr");
    }
  }
}
