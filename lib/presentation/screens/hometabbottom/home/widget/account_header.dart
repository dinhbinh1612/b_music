import 'package:flutter/material.dart';
import 'package:spotify_b/core/constants/api_constants.dart';
import 'package:spotify_b/data/models/profile_model.dart';

class AccountHeader extends StatelessWidget {
  final Profile profile;
  final int avatarVersion;

  const AccountHeader({
    super.key,
    required this.profile,
    required this.avatarVersion,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          CircleAvatar(
            key: ValueKey(avatarVersion),
            radius: 40,
            backgroundImage: profile.avatar.isNotEmpty
                ? NetworkImage("${ApiConstants.baseUrl}${profile.avatar}?v=$avatarVersion")
                : null,
            backgroundColor: Colors.white24,
            child: profile.avatar.isEmpty
                ? const Icon(Icons.account_circle, size: 60, color: Colors.white)
                : null,
          ),
          const SizedBox(height: 12),
          Text(
            profile.username,
            style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(profile.email, style: const TextStyle(color: Colors.grey, fontSize: 14)),
        ],
      ),
    );
  }
}
