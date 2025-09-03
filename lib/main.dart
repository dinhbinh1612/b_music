import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:spotify_b/blocs/history_state/history_cubit.dart';
import 'package:spotify_b/blocs/player/player_song_cubit.dart';
import 'package:spotify_b/blocs/profile/profile_cubit.dart';
import 'package:spotify_b/blocs/register/register_bloc.dart';
import 'package:spotify_b/blocs/register/register_data_cubit.dart';
import 'package:spotify_b/blocs/songs/recommended_songs_cubit.dart';
import 'package:spotify_b/blocs/songs/trending_cubit.dart';
import 'package:spotify_b/core/configs/app_router.dart';
import 'package:spotify_b/core/utils/auth_manager.dart';
import 'package:spotify_b/data/providers/auth_provider.dart';
import 'package:spotify_b/data/repositories/song_repository.dart';
import 'package:spotify_b/presentation/screens/auth/welcome_screen.dart';
import 'package:spotify_b/presentation/screens/hometabbottom/main_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MultiBlocProvider(
          providers: [
            BlocProvider(create: (_) => RegisterDataCubit()),
            BlocProvider(create: (_) => RegisterBloc(AuthProvider())),
            BlocProvider(
              create: (context) => ProfileCubit(AuthProvider())..getProfile(),
            ),
            BlocProvider(create: (_) => RecommendedSongCubit(SongRepository())),
            BlocProvider(create: (context) => TrendingCubit()),
            BlocProvider(create: (_) => PlayerSongCubit()),
            BlocProvider(create: (_) => HistoryCubit()),
          ],
          child: MaterialApp(
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
              textSelectionTheme: TextSelectionThemeData(
                cursorColor: Colors.white,
                selectionColor: Colors.white24,
                selectionHandleColor: Colors.white,
              ),
            ),
            builder: (context, child) {
              SystemChrome.setSystemUIOverlayStyle(
                const SystemUiOverlayStyle(
                  statusBarColor: Colors.transparent,
                  statusBarIconBrightness: Brightness.light,
                  systemNavigationBarColor: Color(0xFF1D1D1D),
                  systemNavigationBarIconBrightness: Brightness.light,
                ),
              );
              return child ?? const SizedBox.shrink();
            },
            home: FutureBuilder<bool>(
              future: AuthManager.isLoggedIn(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        // ignore: deprecated_member_use
                        color: Colors.black.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Color(0xFF1DB954),
                        ),
                      ),
                    ),
                  );
                }
                final isLoggedIn = snapshot.data ?? false;
                return isLoggedIn ? MainScreen() : WelcomeScreen();
              },
            ),
            onGenerateRoute: generateRoute,
            debugShowCheckedModeBanner: false,
          ),
        );
      },
    );
  }
}
