import 'dart:async';
import 'package:flutter/material.dart';

class SearchInput extends StatelessWidget {
  final TextEditingController controller;
  final Timer? debounce;
  final void Function(String query, {bool saveHistory}) onSearch;
  final ValueChanged<Timer?> onDebounceChanged;

  const SearchInput({
    super.key,
    required this.controller,
    required this.debounce,
    required this.onSearch,
    required this.onDebounceChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 12, right: 12, top: 12),
      child: TextField(
        controller: controller,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: "Nhập tên bài hát hoặc ca sĩ...",
          hintStyle: TextStyle(color: Colors.grey.shade400),
          prefixIcon: const Icon(Icons.search, color: Colors.white70),
          filled: true,
          fillColor: Colors.grey.shade900,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(
            vertical: 0,
            horizontal: 16,
          ),
          suffixIcon:
              controller.text.isNotEmpty
                  ? IconButton(
                    icon: const Icon(Icons.close, color: Colors.white70),
                    onPressed: () {
                      controller.clear();
                      (context as Element).markNeedsBuild();
                    },
                  )
                  : null,
        ),
        onChanged: (value) {
          (context as Element).markNeedsBuild();
          if (debounce?.isActive ?? false) debounce!.cancel();
          onDebounceChanged(
            Timer(const Duration(milliseconds: 500), () {
              // Gọi search nhưng không lưu lịch sử
              onSearch(value, saveHistory: false);
            }),
          );
        },
        onSubmitted: (value) => onSearch(value, saveHistory: true),
        textInputAction: TextInputAction.search,
      ),
    );
  }
}
