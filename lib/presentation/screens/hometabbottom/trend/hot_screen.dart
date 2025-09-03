import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify_b/blocs/hot/hot_cubit.dart';
import 'package:spotify_b/blocs/hot/hot_state.dart';
import 'package:spotify_b/data/repositories/song_repository.dart';
import 'package:spotify_b/data/models/song_model.dart';
import 'package:spotify_b/presentation/screens/hometabbottom/player/music_player_screen.dart';

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
          // Header với time range selector
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Bài hát thịnh hành',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                BlocBuilder<HotCubit, HotState>(
                  builder: (context, state) {
                    return Row(
                      children: [
                        _RangeChip(
                          label: 'Tuần',
                          isSelected: state.range == 'week',
                          onTap: () => context.read<HotCubit>().changeRange('week'),
                        ),
                        const SizedBox(width: 8),
                        _RangeChip(
                          label: 'Tháng',
                          isSelected: state.range == 'month',
                          onTap: () => context.read<HotCubit>().changeRange('month'),
                        ),
                        const SizedBox(width: 8),
                        _RangeChip(
                          label: 'Năm',
                          isSelected: state.range == 'year',
                          onTap: () => context.read<HotCubit>().changeRange('year'),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Danh sách bài hát
          Expanded(
            child: BlocConsumer<HotCubit, HotState>(
              listener: (context, state) {
                // Xử lý khi có lỗi
                if (state.error != null && state.songs.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Lỗi: ${state.error}'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              builder: (context, state) {
                if (state.isLoading && state.songs.isEmpty) {
                  return const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF1DB954)),
                    ),
                  );
                }

                if (state.error != null && state.songs.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error_outline, color: Colors.red, size: 48),
                        const SizedBox(height: 16),
                        Text(
                          "Đã xảy ra lỗi: ${state.error}",
                          style: const TextStyle(color: Colors.white70),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () => context.read<HotCubit>().fetchHot(),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1DB954),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: const Text(
                            "Thử lại",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  );
                }

                if (state.songs.isEmpty) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.music_off, color: Colors.white70, size: 48),
                        SizedBox(height: 16),
                        Text(
                          "Không có bài hát nào",
                          style: TextStyle(color: Colors.white70),
                        ),
                      ],
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: () async {
                    context.read<HotCubit>().fetchHot(page: 1);
                  },
                  backgroundColor: const Color(0xFF1DB954),
                  color: Colors.white,
                  child: ListView.separated(
                    controller: _scrollController,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: state.songs.length + (state.hasMore ? 1 : 0),
                    separatorBuilder: (context, index) => const Divider(
                      color: Colors.white24,
                      height: 1,
                    ),
                    itemBuilder: (context, index) {
                      if (index >= state.songs.length) {
                        return Padding(
                          padding: const EdgeInsets.all(16),
                          child: Center(
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white.withOpacity(0.7)),
                            ),
                          ),
                        );
                      }

                      final Song song = state.songs[index];
                      return _SongListItem(
                        song: song,
                        rank: index + 1,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) => MusicPlayerScreen(
                                    playlist: state.songs,
                                    initialIndex: index,
                                  ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _RangeChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _RangeChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF1DB954) : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? const Color(0xFF1DB954) : Colors.white54,
            width: 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.black : Colors.white70,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class _SongListItem extends StatelessWidget {
  final Song song;
  final int rank;
  final VoidCallback onTap;

  const _SongListItem({
    required this.song,
    required this.rank,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      splashColor: const Color(0xFF1DB954).withOpacity(0.3),
      highlightColor: Colors.white.withOpacity(0.1),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        height: 70,
        child: Row(
          children: [
            // Rank number
            SizedBox(
              width: 30,
              child: Text(
                '$rank',
                style: TextStyle(
                  color: rank <= 3
                      ? const Color(0xFF1DB954)
                      : Colors.white.withOpacity(0.7),
                  fontSize: 16,
                  fontWeight: rank <= 3 ? FontWeight.bold : FontWeight.normal,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(width: 12),
            // Album art
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: Image.network(
                song.fullCoverUrl,
                width: 54,
                height: 54,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  width: 54,
                  height: 54,
                  color: Colors.grey[800],
                  child: const Icon(Icons.music_note, color: Colors.white70),
                ),
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    width: 54,
                    height: 54,
                    color: Colors.grey[800],
                    child: const Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white70),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(width: 16),
            // Song info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    song.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    song.artist,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 14,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            // Play count indicator for hot songs
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Row(
                children: [
                  const Icon(Icons.play_arrow, color: Colors.white70, size: 16),
                  const SizedBox(width: 4),
                  Text(
                    '${song.playCount}',
                    style: const TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ],
              ),
            ),
            // Action buttons
            IconButton(
              icon: const Icon(Icons.favorite_border, color: Colors.white70),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}