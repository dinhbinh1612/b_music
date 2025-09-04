import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify_b/blocs/profile/profile_cubit.dart';
import 'package:spotify_b/presentation/screens/hometabbottom/home/widget/profile_body.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isAvatarUpdated = false;

  void _onAvatarUpdated() {
    setState(() {
      _isAvatarUpdated = true;
    });
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
          onPressed: () => Navigator.pop(context, _isAvatarUpdated),
        ),
      ),
      backgroundColor: Colors.black,
      body: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, state) {
          if (state is ProfileLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ProfileLoaded) {
            return ProfileBody(
              profile: state.profile,
              avatarVersion: state.avatarVersion,
              onAvatarUpdated: _onAvatarUpdated,
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
}
