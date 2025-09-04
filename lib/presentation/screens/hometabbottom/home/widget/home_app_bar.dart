import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify_b/blocs/profile/profile_cubit.dart';
import 'package:spotify_b/core/configs/app_routes.dart';
import 'package:spotify_b/core/constants/api_constants.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.black,
      elevation: 0,
      title: const Text(
        "Music BKL",
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.search, color: Colors.white),
          onPressed: () {
            Navigator.pushNamed(context, AppRoutes.search);
          },
        ),
        const SizedBox(width: 12),
        BlocConsumer<ProfileCubit, ProfileState>(
          listener: (context, state) {},
          builder: (context, state) {
            String avatarUrl = "";
            bool hasAvatar = false;

            if (state is ProfileLoaded) {
              avatarUrl = state.profile.avatar;
              hasAvatar = avatarUrl.isNotEmpty;
            }

            return GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, AppRoutes.account);
              },
              child: hasAvatar
                  ? CircleAvatar(
                      radius: 16,
                      backgroundImage: NetworkImage(
                        "${ApiConstants.baseUrl}$avatarUrl",
                      ),
                    )
                  : const Icon(
                      Icons.account_circle,
                      color: Colors.white,
                      size: 28,
                    ),
            );
          },
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
