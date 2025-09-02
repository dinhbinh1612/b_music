class ApiConstants {
  static const String baseUrl = 'http://192.168.1.191:3000';

  static const String register = '$baseUrl/auth/register';
  static const String login = '$baseUrl/auth/login';
  static const String profile = '$baseUrl/auth/profile';
  static const String uploadAvatar = '$baseUrl/users/me/avatar';

  static const String allSongs = '$baseUrl/songs';
  static const String recommendSongs = '$baseUrl/analytics/recommendations?limit=18';
  static const String trendingSongs = '$baseUrl/analytics/trending';
  static const String historySongs = '$baseUrl/analytics/history';
  static const String searchSongs = '$baseUrl/songs/search';
}