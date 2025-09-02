import 'package:shared_preferences/shared_preferences.dart';

class SearchHistoryStore {
  static const String _key = 'search_history_v1';
  static const int maxItems = 20; // tối đa 20 truy vấn gần nhất

  /// Lấy toàn bộ lịch sử (mới nhất đứng đầu)
  static Future<List<String>> getAll() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_key) ?? [];
  }

  /// Thêm 1 truy vấn vào lịch sử (loại trùng, đưa lên đầu, cắt theo maxItems)
  static Future<void> add(String raw) async {
    final query = raw.trim();
    if (query.isEmpty) return;

    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_key) ?? [];

    // loại trùng không phân biệt hoa thường
    list.removeWhere((e) => e.toLowerCase() == query.toLowerCase());
    list.insert(0, query);

    // cắt bớt nếu quá dài
    if (list.length > maxItems) {
      list.removeRange(maxItems, list.length);
    }

    await prefs.setStringList(_key, list);
  }

  /// Xoá 1 mục khỏi lịch sử
  static Future<void> remove(String raw) async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_key) ?? [];
    list.removeWhere((e) => e.toLowerCase() == raw.trim().toLowerCase());
    await prefs.setStringList(_key, list);
  }

  /// Xoá toàn bộ lịch sử
  static Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}
