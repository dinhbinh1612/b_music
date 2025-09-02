import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify_b/blocs/profile/profile_cubit.dart';
import 'package:spotify_b/blocs/songs/recommended_songs_cubit.dart';
import 'package:spotify_b/blocs/songs/trending_cubit.dart';
import 'package:spotify_b/core/configs/app_routes.dart';
import 'package:spotify_b/core/constants/api_constants.dart';
import 'package:spotify_b/data/repositories/song_repository.dart';
import 'package:spotify_b/presentation/widgets/recommended_songs.dart';
import 'package:spotify_b/presentation/widgets/trending_song.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: const Text(
          "Music BKL",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        actions: [
          Icon(Icons.search, color: Colors.white),
          SizedBox(width: 12),
          BlocConsumer<ProfileCubit, ProfileState>(
            listener: (context, state) {},
            builder: (context, state) {
              String avatarUrl = "";
              bool hasAvatar = false;

              if (state is ProfileLoaded) {
                avatarUrl = state.profile.avatar;
                hasAvatar = avatarUrl.isNotEmpty;
              }

              return GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, AppRoutes.account);
                },
                child: hasAvatar
                    ? CircleAvatar(
                        radius: 16,
                        backgroundImage: NetworkImage(
                          "${ApiConstants.baseUrl}$avatarUrl",
                        ),
                      )
                    : const Icon(
                        Icons.account_circle,
                        color: Colors.white,
                        size: 28,
                      ),
              );
            },
          ),
          SizedBox(width: 8),
        ],
      ),
      body: BlocProvider(
        create: (_) =>
            RecommendedSongCubit(SongRepository())..loadRecommendedSongs(),
        child: CustomScrollView(
          slivers: [
            // Tab bar ngang
            SliverToBoxAdapter(
              child: SizedBox(
                height: 52,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: const [
                    _TabItem(label: "Đề xuất"),
                    _TabItem(label: "Bảng xếp hạng"),
                    _TabItem(label: "Thể loại"),
                    _TabItem(label: "Album"),
                    _TabItem(label: "Nghệ sĩ"),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: const Divider(color: Colors.white24, height: 1),
            ),
            // Dành cho bạn
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const _SectionTitle(title: "Dành cho bạn"),
                    const SizedBox(height: 12),
                    RecommendedSongsSection(),
                  ],
                ),
              ),
            ),
            // Nhạc Hot
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const _SectionTitle(title: "Nhạc Hot"),
                    const SizedBox(height: 12),
                    BlocProvider(
                      create: (context) => TrendingCubit(),
                      child: const TrendingSongsSection(),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Widget cho TabItem
class _TabItem extends StatelessWidget {
  final String label;
  const _TabItem({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(label, style: const TextStyle(color: Colors.white)),
    );
  }
}

/// Widget cho tiêu đề section
class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
