import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify_b/blocs/profile/profile_cubit.dart';
import 'package:spotify_b/core/configs/app_routes.dart';
import 'package:spotify_b/core/constants/api_constants.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: const Text("Tài khoản", style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
      ),
      body: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, state) {
          if (state is ProfileLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ProfileLoaded) {
            final profile = state.profile;
            return ListView(
              children: [
                const SizedBox(height: 20),
                // Avatar + tên tài khoản
                Center(
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundImage: profile.avatar.isNotEmpty
                            ? NetworkImage("${ApiConstants.baseUrl}${profile.avatar}")
                            : null,
                        backgroundColor: Colors.white24,
                        child: profile.avatar.isEmpty
                            ? const Icon(Icons.account_circle, size: 60, color: Colors.white)
                            : null,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        profile.username,
                        style: const TextStyle(
                            color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        profile.email,
                        style: const TextStyle(color: Colors.grey, fontSize: 14),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                _AccountTile(icon: Icons.person, label: "Thông tin cá nhân",
                onTap: (){
                  Navigator.pushNamed(context, AppRoutes.profile);
                },
    ),
                const _AccountTile(icon: Icons.settings, label: "Cài đặt"),
                const _AccountTile(icon: Icons.history, label: "Lịch sử nghe nhạc"),
                const _AccountTile(icon: Icons.favorite, label: "Bài hát yêu thích"),
                const _AccountTile(icon: Icons.playlist_play, label: "Playlist của tôi"),
                const _AccountTile(icon: Icons.logout, label: "Đăng xuất"),
              ],
            );
          } else if (state is ProfileUnauthorized) {
            return Center(child: Text(state.message, style: const TextStyle(color: Colors.red)));
          } else if (state is ProfileError) {
            return Center(child: Text("Lỗi: ${state.message}", style: const TextStyle(color: Colors.red)));
          }
          return const Center(child: Text("Chưa có dữ liệu", style: TextStyle(color: Colors.white)));
        },
      ),
    );
  }
}


class _AccountTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  const _AccountTile({required this.icon, required this.label, this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(label, style: const TextStyle(color: Colors.white)),
      onTap: onTap,
      splashColor: Colors.transparent, // tắt hiệu ứng sóng nước
    );
  }
}
