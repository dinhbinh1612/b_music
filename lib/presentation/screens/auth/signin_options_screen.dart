import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:spotify_b/core/assets/app_icons.dart';
import 'package:spotify_b/core/assets/app_images.dart';
import 'package:spotify_b/core/configs/app_routes.dart';
import 'package:spotify_b/presentation/widgets/icon_button_filled.dart';

class SigninOptionsScreenPage extends StatelessWidget {
  const SigninOptionsScreenPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: Color(0xFF121212),
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 32.sp),
        child: Center(child: _buildContent(context)),
      ),
    );
  }

  Widget _buildContent(context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(height: 100.sp),
        Image.asset(AppImage.logoWhite, height: 80.sp),
        SizedBox(height: 16.sp),
        Text(
          'Đăng nhập vào\n Spotify',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 30.sp,
            fontWeight: FontWeight.bold,
            height: 1.4,
          ),
        ),
        SizedBox(height: 100.sp),
        IconButtonFilled(
          backgroundColor: Color(0xFF1ED760),
          label: 'Tiếp tục với email',
          icon: Icon(Icons.email_outlined, size: 24.sp),
          foregroundColor: Colors.black,
          onPressed: () {
            Navigator.pushNamed(context, AppRoutes.loginEmail);
          },
        ),
        SizedBox(height: 16.sp),
        IconButtonFilled(
          backgroundColor: Color(0xFF121212),
          label: 'Tiếp tục bằng số điện thoại',
          icon: Icon(Icons.phone_android_outlined, size: 24.sp),
          foregroundColor: Colors.white,
          onPressed: () {},
          boder: Colors.grey,
        ),
        SizedBox(height: 16.sp),
        IconButtonFilled(
          backgroundColor: Color(0xFF121212),
          label: 'Tiếp tục bằng google',
          icon: Image.asset(AppIcons.google, height: 24.sp),
          foregroundColor: Colors.white,
          onPressed: () {},
          boder: Colors.grey,
        ),
        SizedBox(height: 32.sp),
        Text(
          'Bạn đã có tài khoản?',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        TextButton(
          style: ButtonStyle(
            overlayColor: WidgetStateProperty.all(Colors.transparent),
            splashFactory: NoSplash.splashFactory,
          ),
          onPressed: () {
            Navigator.pushReplacementNamed(context, AppRoutes.signUpOptions);
          },
          child: Text(
            'Đăng ký',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
