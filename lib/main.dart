import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:spotify_b/blocs/register/register_bloc.dart';
import 'package:spotify_b/blocs/register/register_data_cubit.dart';
import 'package:spotify_b/core/configs/app_router.dart';
import 'package:spotify_b/core/configs/app_routes.dart';
import 'package:spotify_b/data/providers/auth_provider.dart';

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
          ],
          child: MaterialApp(
            title: 'Flutter Demo',
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
                  systemNavigationBarColor: Color(0xFF121212),
                  systemNavigationBarIconBrightness: Brightness.light,
                ),
              );
              return child ?? const SizedBox.shrink();
            },
            initialRoute: AppRoutes.welcome,
            onGenerateRoute: generateRoute,
            debugShowCheckedModeBanner: false,
          ),
        );
      },
    );
  }
}
