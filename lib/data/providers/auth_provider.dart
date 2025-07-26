import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:spotify_b/core/constants/api_constants.dart';
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

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      final error = json.decode(response.body);
      throw Exception(error['message'] ?? 'Đăng nhập thất bại');
    }
  }
}
