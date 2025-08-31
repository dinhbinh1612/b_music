import 'package:shared_preferences/shared_preferences.dart';

class AuthManager {
  static const String _isLoggedInKey = 'isLoggedIn';
  static const String _tokenKey = 'authToken';

  // Lưu trạng thái đăng nhập
  static Future<void> setLoggedIn(bool isLoggedIn) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isLoggedInKey, isLoggedIn);
  }

  // Kiểm tra trạng thái đăng nhập
  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isLoggedInKey) ?? false;
  }

  // Xóa trạng thái đăng nhập (dùng khi đăng xuất)
  static Future<void> clearLogin() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_isLoggedInKey);
    await prefs.remove(_tokenKey);
  }

  // Lưu Token
  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  // Lấy Token
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }
}
