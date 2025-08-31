import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify_b/core/utils/auth_manager.dart';
import '../../data/models/user_login_model.dart';
import '../../data/providers/auth_provider.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final AuthProvider authProvider;

  LoginCubit(this.authProvider) : super(LoginInitial());

  Future<void> login(String email, String password) async {
    emit(LoginLoading());
    try {
      final result = await authProvider.login(
        UserLoginModel(email: email, password: password),
      );

      if (result['data'] == null) {
        throw Exception("Không có data trong response: $result");
      }

      final token = result['data']['token'];
      if (token == null || token.isEmpty) {
        throw Exception("Token không tồn tại hoặc rỗng");
      }

      await AuthManager.saveToken(token);
      await AuthManager.setLoggedIn(true);

      // print('Token đã lưu: ${token.substring(0, 20)}...');

      emit(LoginSuccess(userData: result));
    } catch (e) {
      // print('Lỗi login: $e');
      emit(LoginFailure(errorMessage: e.toString()));
    }
  }
}
