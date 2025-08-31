import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:spotify_b/blocs/profile/profile_cubit.dart';
import 'package:spotify_b/core/constants/api_constants.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isAvatarUpdated = false;

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
      setState(() {
        _isAvatarUpdated = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Hồ sơ cá nhân",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          // Truyền kết quả khi nhấn nút back
          onPressed: () => Navigator.pop(context, _isAvatarUpdated),
        ),
      ),
      backgroundColor: Colors.black,
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
                  // Avatar + nút edit
                  Center(
                    child: Stack(
                      children: [
                        CircleAvatar(
                          radius: 60,
                          backgroundImage:
                              profile.avatar.isNotEmpty
                                  ? NetworkImage(
                                    "${ApiConstants.baseUrl}${profile.avatar}?v=${state.avatarVersion}",
                                  )
                                  : null,
                          backgroundColor: Colors.white24,
                          child:
                              profile.avatar.isEmpty
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
                                // ignore: deprecated_member_use
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

                  _buildInfoTile(
                    Icons.person,
                    "Tên tài khoản",
                    profile.username,
                  ),
                  _buildInfoTile(
                    Icons.calendar_today,
                    "Ngày sinh",
                    profile.birthdate != null
                        ? _formatDate(profile.birthdate!)
                        : "Không có",
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
