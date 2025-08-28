import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify_b/blocs/profile/profile_cubit.dart';
import 'package:spotify_b/core/constants/api_constants.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Hồ sơ cá nhân",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF121212),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
      ),
      backgroundColor: const Color(0xFF121212),
      body: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, state) {
          if (state is ProfileLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ProfileLoaded) {
            final profile = state.profile;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Avatar + Username
                  Center(
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 40,
                          backgroundImage:
                              profile.avatar.isNotEmpty
                                  ? NetworkImage(
                                    "${ApiConstants.baseUrl}${profile.avatar}",
                                  )
                                  : null,
                          backgroundColor: Colors.white24,
                          child:
                              profile.avatar.isEmpty
                                  ? const Icon(
                                    Icons.account_circle,
                                    size: 60,
                                    color: Colors.white,
                                  )
                                  : null,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          profile.username,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Thông tin chi tiết
                  _buildInfoTile(Icons.email, "Email", profile.email),
                  _buildInfoTile(
                    Icons.person,
                    "Tên tài khoản",
                    profile.username,
                  ),
                  _buildInfoTile(
                    Icons.calendar_today,
                    "Ngày sinh",
                    profile.birthdate ?? "Không có",
                  ),
                  _buildInfoTile(
                    Icons.wc,
                    "Giới tính",
                    profile.gender ?? "Không có",
                  ),
                ],
              ),
            );
          } else if (state is ProfileError) {
            return Center(
              child: Text(
                "Lỗi: ${state.message}",
                style: const TextStyle(color: Colors.redAccent),
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildInfoTile(IconData icon, String title, String value) {
    return Card(
      color: const Color(0xFF1E1E1E),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: Icon(icon, color: Colors.white70),
        title: Text(title, style: const TextStyle(color: Colors.white70)),
        subtitle: Text(value, style: const TextStyle(color: Colors.white)),
      ),
    );
  }
}
