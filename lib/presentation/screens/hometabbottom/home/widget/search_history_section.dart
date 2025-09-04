import 'package:flutter/material.dart';

class SearchHistorySection extends StatelessWidget {
  final List<String> items;
  final ValueChanged<String> onTapItem;
  final ValueChanged<String> onRemoveItem;
  final VoidCallback onClearAll;

  const SearchHistorySection({
    super.key,
    required this.items,
    required this.onTapItem,
    required this.onRemoveItem,
    required this.onClearAll,
  });

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return const Center(
        child: Text("Chưa có lịch sử tìm kiếm",
            style: TextStyle(color: Colors.white70)),
      );
    }

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      children: [
        Column(
          children: items.map((q) {
            return ListTile(
              leading: const Icon(Icons.history, color: Colors.white70),
              title: Text(q, style: const TextStyle(color: Colors.white)),
              trailing: IconButton(
                icon: const Icon(Icons.close, color: Colors.white70),
                onPressed: () => onRemoveItem(q),
              ),
              onTap: () => onTapItem(q),
            );
          }).toList(),
        ),
        TextButton(
          onPressed: () async {
            final confirm = await showDialog<bool>(
              context: context,
              builder: (context) => AlertDialog(
                backgroundColor: Colors.grey.shade900,
                title: const Text('Xác nhận',
                    style: TextStyle(color: Colors.white)),
                content: const Text(
                  'Bạn có chắc muốn xoá tất cả lịch sử tìm kiếm?',
                  style: TextStyle(color: Colors.white70),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: const Text('Hủy',
                        style: TextStyle(color: Colors.white70)),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context, true),
                    child: const Text('Xoá',
                        style: TextStyle(color: Colors.redAccent)),
                  ),
                ],
              ),
            );
            if (confirm == true) onClearAll();
          },
          child: const Text("Xoá tất cả",
              style: TextStyle(color: Colors.white70, fontSize: 16)),
        ),
      ],
    );
  }
}
