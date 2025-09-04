import 'package:flutter/material.dart';
import 'package:spotify_b/core/constants/api_constants.dart';
import 'package:spotify_b/data/models/profile_model.dart';
import 'package:spotify_b/presentation/screens/hometabbottom/home/widget/profile_avatar.dart';
import 'package:spotify_b/presentation/screens/hometabbottom/home/widget/profile_info_tile.dart';

class ProfileBody extends StatelessWidget {
  final Profile profile;
  final int avatarVersion;
  final VoidCallback onAvatarUpdated;

  const ProfileBody({
    super.key,
    required this.profile,
    required this.avatarVersion,
    required this.onAvatarUpdated,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ProfileAvatar(
            avatarUrl: profile.avatar.isNotEmpty
                ? "${ApiConstants.baseUrl}${profile.avatar}?v=$avatarVersion"
                : null,
            onAvatarUpdated: onAvatarUpdated,
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
          const SizedBox(height: 3),
          Text(
            profile.email,
            style: const TextStyle(fontSize: 14, color: Colors.grey),
          ),
          const SizedBox(height: 24),
          ProfileInfoTile(
            icon: Icons.person,
            title: "Tên tài khoản",
            value: profile.username,
          ),
          ProfileInfoTile(
            icon: Icons.calendar_today,
            title: "Ngày sinh",
            value: profile.birthdate != null
                ? _formatDate(profile.birthdate!)
                : "Không có",
          ),
          ProfileInfoTile(
            icon: Icons.wc,
            title: "Giới tính",
            value: profile.gender ?? "Không có",
          ),
        ],
      ),
    );
  }

  String _formatDate(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      return "${date.day.toString().padLeft(2, '0')}/"
          "${date.month.toString().padLeft(2, '0')}/"
          "${date.year}";
    } catch (e) {
      return dateStr;
    }
  }
}
