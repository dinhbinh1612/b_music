import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify_b/blocs/search/search_cubit.dart';
import 'package:spotify_b/data/repositories/song_repository.dart';
import 'package:spotify_b/core/utils/search_history_store.dart';
import 'package:spotify_b/presentation/screens/hometabbottom/home/widget/search_history_section.dart';
import 'package:spotify_b/presentation/screens/hometabbottom/home/widget/search_input.dart';
import 'package:spotify_b/presentation/screens/hometabbottom/home/widget/search_results.dart';

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
    if (q.trim().length < 2) return;
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

  // Hàm tìm kiếm luu lich su tim kiem
  void _onSearch(
    BuildContext context,
    String query, {
    bool saveHistory = true,
  }) {
    final q = query.trim();
    if (q.isEmpty) return;
    context.read<SearchCubit>().search(q);
    if (saveHistory) {
      _addToHistory(q); // chỉ lưu khi submit
    }
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Tìm kiếm",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          // Ồ tìm kiếm
          SearchInput(
            controller: _controller,
            debounce: _debounce,
            onSearch:
                (q, {saveHistory = true}) =>
                    _onSearch(context, q, saveHistory: saveHistory),
            onDebounceChanged: (t) => _debounce = t,
          ),

          // Kết quả hoặc lịch sử
          Expanded(
            child: BlocBuilder<SearchCubit, SearchState>(
              builder: (context, state) {
                if (_isQueryEmpty) {
                  return SearchHistorySection(
                    items: _history,
                    onTapItem: (q) {
                      _controller.text = q;
                      setState(() {});
                      _onSearch(context, q);
                    },
                    onRemoveItem: _removeFromHistory,
                    onClearAll: _clearHistory,
                  );
                }

                return SearchResults(state: state);
              },
            ),
          ),
        ],
      ),
    );
  }
}
