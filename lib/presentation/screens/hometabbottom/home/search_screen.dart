import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify_b/blocs/search/search_cubit.dart';
import 'package:spotify_b/data/models/song_model.dart';
import 'package:spotify_b/data/repositories/song_repository.dart';
import 'package:spotify_b/core/utils/search_history_store.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SearchCubit(SongRepository()),
      child: const _SearchView(),
    );
  }
}

class _SearchView extends StatefulWidget {
  const _SearchView();

  @override
  State<_SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<_SearchView> {
  final TextEditingController _controller = TextEditingController();
  Timer? _debounce;

  List<String> _history = [];

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    final list = await SearchHistoryStore.getAll();
    if (!mounted) return;
    setState(() => _history = list);
  }

  Future<void> _addToHistory(String q) async {
    if (q.trim().length < 2) return; // không lưu query quá ngắn
    await SearchHistoryStore.add(q);
    await _loadHistory();
  }

  Future<void> _removeFromHistory(String q) async {
    await SearchHistoryStore.remove(q);
    await _loadHistory();
  }

  Future<void> _clearHistory() async {
    await SearchHistoryStore.clear();
    await _loadHistory();
  }

  void _onSearch(BuildContext context, String query) {
    final q = query.trim();
    if (q.isEmpty) return;
    context.read<SearchCubit>().search(q);
    _addToHistory(q); // lưu lịch sử khi thực sự gọi search
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  bool get _isQueryEmpty => _controller.text.trim().isEmpty;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: const Text(
          "Tìm kiếm",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          // Ô nhập
          Padding(
            padding: const EdgeInsets.only(left: 12, right: 12, top: 12),
            child: TextField(
              controller: _controller,
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
                // nút clear nhanh
                suffixIcon:
                    _controller.text.isNotEmpty
                        ? IconButton(
                          icon: const Icon(Icons.close, color: Colors.white70),
                          onPressed: () {
                            _controller.clear();
                            setState(
                              () {},
                            ); // cập nhật suffixIcon & hiển thị history
                          },
                        )
                        : null,
              ),
              onChanged: (value) {
                setState(() {}); // để cập nhật suffixIcon và điều kiện hiển thị
                if (_debounce?.isActive ?? false) _debounce!.cancel();
                _debounce = Timer(const Duration(milliseconds: 500), () {
                  _onSearch(context, value);
                });
              },
              onSubmitted: (value) => _onSearch(context, value),
              textInputAction: TextInputAction.search,
            ),
          ),

          // Kết quả hoặc lịch sử
          Expanded(
            child: BlocBuilder<SearchCubit, SearchState>(
              builder: (context, state) {
                // Nếu chưa gõ gì hoặc đang xoá hết -> hiển thị lịch sử
                if (_isQueryEmpty) {
                  return _HistorySection(
                    items: _history,
                    onTapItem: (q) {
                      _controller.text = q;
                      setState(() {}); // cập nhật UI
                      _onSearch(context, q);
                    },
                    onRemoveItem: _removeFromHistory,
                    onClearAll: _clearHistory,
                  );
                }

                // Loading
                if (state.isLoading) {
                  return const Center(
                    child: CircularProgressIndicator(color: Colors.white),
                  );
                }

                // Lỗi
                if (state.error != null) {
                  return Center(
                    child: Text(
                      "Lỗi: ${state.error}",
                      style: const TextStyle(color: Colors.redAccent),
                    ),
                  );
                }

                // Không có kết quả
                if (state.results.isEmpty) {
                  return const Center(
                    child: Text(
                      "Không có kết quả",
                      style: TextStyle(color: Colors.white70),
                    ),
                  );
                }

                // Danh sách kết quả
                return ListView.builder(
                  itemCount: state.results.length,
                  itemBuilder: (context, index) {
                    final Song song = state.results[index];
                    return ListTile(
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          song.fullCoverUrl,
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                          errorBuilder:
                              (_, __, ___) => const Icon(
                                Icons.music_note,
                                color: Colors.white70,
                              ),
                        ),
                      ),
                      title: Text(
                        song.title,
                        style: const TextStyle(color: Colors.white),
                      ),
                      subtitle: Text(
                        song.artist,
                        style: const TextStyle(color: Colors.white70),
                      ),
                      trailing: const Icon(
                        Icons.more_vert,
                        color: Colors.white,
                      ),
                      onTap: () {
                        // TODO: mở player
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

/// Section hiển thị lịch sử tìm kiếm (dark)
class _HistorySection extends StatelessWidget {
  final List<String> items;
  final ValueChanged<String> onTapItem;
  final ValueChanged<String> onRemoveItem;
  final VoidCallback onClearAll;

  const _HistorySection({
    required this.items,
    required this.onTapItem,
    required this.onRemoveItem,
    required this.onClearAll,
  });

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return const Center(
        child: Text(
          "Chưa có lịch sử tìm kiếm",
          style: TextStyle(color: Colors.white70),
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [

            TextButton(
              onPressed: onClearAll,
              child: const Text(
                "Xoá tất cả",
                style: TextStyle(color: Colors.white70, fontSize: 12),
              ),
            ),
          ],
        ),
        // lịch sử tìm kiếm
        Column(
          children:
              items.map((q) {
                return ListTile(
                  leading: const Icon(Icons.history, color: Colors.white70),
                  title: Text(q, style: const TextStyle(color: Colors.white)),
                  trailing: IconButton(
                    icon: const Icon(Icons.close, color: Colors.white70),
                    onPressed: () => onRemoveItem(q),
                  ),
                );
              }).toList(),
        ),
      ],
    );
  }
}
