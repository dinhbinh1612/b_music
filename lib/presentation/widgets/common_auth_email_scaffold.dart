import 'package:flutter/material.dart';
import 'package:spotify_b/core/configs/app_routes.dart';

class CommonAuthScaffoldSignin extends StatelessWidget {
  final Widget body;
  final bool showCloseIcon;

  const CommonAuthScaffoldSignin({
    super.key,
    required this.body,
    this.showCloseIcon = false,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: Color(0xFF121212),
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
          onPressed: () {
            Navigator.pushNamedAndRemoveUntil(
              context,
              AppRoutes.signInOptions,
              (route) => false,
            );
          },
        ),
        title: const Text('Đăng Nhập', style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: body,
    );
  }
}
