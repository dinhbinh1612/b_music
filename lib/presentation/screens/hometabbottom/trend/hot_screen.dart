import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify_b/blocs/hot/hot_cubit.dart';
import 'package:spotify_b/data/repositories/song_repository.dart';
import 'package:spotify_b/presentation/screens/hometabbottom/trend/widget/hot_header.dart';
import 'package:spotify_b/presentation/screens/hometabbottom/trend/widget/hot_song_list.dart';

class HotScreen extends StatelessWidget {
  const HotScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HotCubit(SongRepository())..fetchHot(),
      child: const _HotView(),
    );
  }
}

class _HotView extends StatefulWidget {
  const _HotView();

  @override
  State<_HotView> createState() => _HotViewState();
}

class _HotViewState extends State<_HotView> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<HotCubit>().loadMore();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Xu hướng',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const HotHeader(),
          const SizedBox(height: 16),
          Expanded(
            child: HotSongList(scrollController: _scrollController),
          ),
        ],
      ),
    );
  }
}
