import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/user_login_model.dart';
import '../../data/providers/auth_provider.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final AuthProvider authProvider;

  LoginCubit(this.authProvider) : super(LoginInitial());

  Future<void> login(String email, String password) async {
    emit(LoginLoading());
    try {
      final result = await authProvider.login(UserLoginModel(
        email: email,
        password: password,
      ));
      emit(LoginSuccess(userData: result));
    } catch (e) {
      emit(LoginFailure(errorMessage: e.toString()));
    }
  }
}
