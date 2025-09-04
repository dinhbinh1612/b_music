import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:spotify_b/blocs/profile/profile_cubit.dart';

class ProfileAvatar extends StatelessWidget {
  final String? avatarUrl;
  final VoidCallback onAvatarUpdated;

  const ProfileAvatar({
    super.key,
    this.avatarUrl,
    required this.onAvatarUpdated,
  });

  Future<void> _pickAndUploadAvatar(BuildContext context) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (pickedFile != null) {
      final file = File(pickedFile.path);
      // ignore: use_build_context_synchronously
      context.read<ProfileCubit>().uploadAvatar(file);
      onAvatarUpdated();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        children: [
          CircleAvatar(
            radius: 60,
            backgroundImage: avatarUrl != null ? NetworkImage(avatarUrl!) : null,
            backgroundColor: Colors.white24,
            child: avatarUrl == null
                ? const Icon(
                    Icons.account_circle,
                    size: 100,
                    color: Colors.white,
                  )
                : null,
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: InkWell(
              onTap: () => _pickAndUploadAvatar(context),
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey.withOpacity(0.3),
                ),
                padding: const EdgeInsets.all(5),
                child: const Icon(
                  Icons.edit,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
