import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify_b/blocs/profile/profile_cubit.dart';
import 'package:spotify_b/core/configs/app_routes.dart';
import 'package:spotify_b/data/providers/auth_provider.dart';
import 'package:spotify_b/presentation/screens/auth/login/login_email.dart';
import 'package:spotify_b/presentation/screens/auth/register/birthdate_put_screen.dart';
import 'package:spotify_b/presentation/screens/auth/register/choose_gender_screen.dart';
import 'package:spotify_b/presentation/screens/auth/register/email_put_screen.dart';
import 'package:spotify_b/presentation/screens/auth/register/name_input_screen.dart';
import 'package:spotify_b/presentation/screens/auth/register/password_put_screen.dart';
import 'package:spotify_b/presentation/screens/auth/signin_options_screen.dart';
import 'package:spotify_b/presentation/screens/auth/signup_options_screen.dart';
import 'package:spotify_b/presentation/screens/auth/welcome_screen.dart';
import 'package:spotify_b/presentation/screens/hometabbottom/home/account_screen.dart';
import 'package:spotify_b/presentation/screens/hometabbottom/home/home_screen.dart';
import 'package:spotify_b/presentation/screens/hometabbottom/home/profile_screen.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    // sign-in and sign-up options
    case AppRoutes.welcome:
      return MaterialPageRoute(builder: (_) => const WelcomeScreen());
    case AppRoutes.signInOptions:
      return MaterialPageRoute(builder: (_) => const SigninOptionsScreenPage());
    case AppRoutes.signUpOptions:
      return MaterialPageRoute(builder: (_) => const SignupOptionsScreenPage());
    // Register flow
    case AppRoutes.emailPut:
      return MaterialPageRoute(builder: (_) => const EmailPutScreen());
    case AppRoutes.passwordPut:
      return MaterialPageRoute(builder: (_) => const PasswordPutScreen());
    case AppRoutes.nameInput:
      return MaterialPageRoute(builder: (_) => const NameInputScreen());
    case AppRoutes.birthDatePut:
      return MaterialPageRoute(builder: (_) => const BirthdatePutScreen());
    case AppRoutes.chooseGender:
      return MaterialPageRoute(builder: (_) => const ChooseGenderScreen());
    // Login with email
    case AppRoutes.loginEmail:
      return MaterialPageRoute(builder: (_) => const LoginEmailScreen());

    // main- home
    case AppRoutes.home:
      return MaterialPageRoute(builder: (_) => const HomeScreen());
    case AppRoutes.account:
      return MaterialPageRoute(
        builder:
            (_) => BlocProvider(
              create: (_) => ProfileCubit(AuthProvider())..getProfile(),
              child: const AccountScreen(),
            ),
      );
    case AppRoutes.profile:
      return MaterialPageRoute(
        builder:
            (_) => BlocProvider(
              create: (_) => ProfileCubit(AuthProvider())..getProfile(),
              child: const ProfileScreen(),
            ),
      );

    default:
      return MaterialPageRoute(
        builder:
            (_) => const Scaffold(
              body: Center(child: Text("Route không tồn tại")),
            ),
      );
  }
}
