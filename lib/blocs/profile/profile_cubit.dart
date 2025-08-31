import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify_b/core/utils/auth_manager.dart';
import 'package:spotify_b/data/models/profile_model.dart';
import 'package:spotify_b/data/providers/auth_provider.dart';
part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final AuthProvider authProvider;
  int _avatarVersion = 0;

  ProfileCubit(this.authProvider) : super(ProfileInitial());

  Future<void> getProfile() async {
    emit(ProfileLoading());
    try {
      final token = await AuthManager.getToken();
      if (token == null) {
        emit(
          ProfileUnauthorized('Token không tồn tại. Vui lòng đăng nhập lại.'),
        );
        return;
      }
      final data = await authProvider.getProfile(token);
      emit(ProfileLoaded(profile: data));
    } catch (e) {
      final msg = e.toString();
      // Nếu backend trả 401 thì có thể emit Unauthorized
      if (msg.contains('401') || msg.toLowerCase().contains('unauthorized')) {
        emit(
          ProfileUnauthorized(
            'Phiên đăng nhập hết hạn. Vui lòng đăng nhập lại.',
          ),
        );
      } else {
        emit(ProfileError(msg));
      }
    }
  }

  // Hàm upload avatar
  Future<void> uploadAvatar(File avatarFile) async {
    try {
      emit(ProfileLoading());
      final token = await AuthManager.getToken();
      if (token == null) {
        emit(
          ProfileUnauthorized('Token không tồn tại. Vui lòng đăng nhập lại.'),
        );
        return;
      }

      await authProvider.uploadAvatar(token, avatarFile);
      _avatarVersion++;

      final data = await authProvider.getProfile(token);

      // Clear cache trước khi emit
      PaintingBinding.instance.imageCache.clear();
      PaintingBinding.instance.imageCache.clearLiveImages();

      emit(ProfileLoaded(profile: data, avatarVersion: _avatarVersion));
    } catch (e) {
      emit(ProfileError("Upload avatar lỗi: ${e.toString()}"));
    }
  }
}
