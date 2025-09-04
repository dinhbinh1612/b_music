import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify_b/blocs/songs/recommended_songs_cubit.dart';
import 'package:spotify_b/data/repositories/song_repository.dart';
import 'package:spotify_b/presentation/screens/hometabbottom/home/widget/home_app_bar.dart';
import 'package:spotify_b/presentation/screens/hometabbottom/home/widget/home_section_title.dart';
import 'package:spotify_b/presentation/screens/hometabbottom/home/widget/home_tab_bar.dart';
import 'package:spotify_b/presentation/screens/hometabbottom/home/widget/recommended_songs.dart';
import 'package:spotify_b/presentation/screens/hometabbottom/home/widget/trending_song.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: const HomeAppBar(),
      body: BlocProvider(
        create:
            (_) =>
                RecommendedSongCubit(SongRepository())..loadRecommendedSongs(),
        child: CustomScrollView(
          slivers: [
            // Tab bar ngang
            const SliverToBoxAdapter(child: HomeTabBar()),

            const SliverToBoxAdapter(
              child: Divider(color: Colors.white24, height: 1),
            ),

            // Dành cho bạn
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    HomeSectionTitle(title: "Dành cho bạn"),
                    SizedBox(height: 12),
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
                  children: const [
                    HomeSectionTitle(title: "Nhạc Hot"),
                    SizedBox(height: 12),
                    TrendingSongsSection(),
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
