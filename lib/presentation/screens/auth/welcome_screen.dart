import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:spotify_b/core/assets/app_images.dart';
import 'package:spotify_b/core/configs/app_routes.dart';
import 'package:spotify_b/presentation/widgets/icon_button_filled.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 32.sp),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF393939), Color(0xFF121212)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: ScrollConfiguration(
          behavior: ScrollBehavior().copyWith(
            overscroll: false,
            scrollbars: false,
          ),
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height,
              ),
              child: IntrinsicHeight(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Spacer(),
                    Image.asset(AppImage.logoWhite, height: 80.sp),
                    SizedBox(height: 16.sp),
                    Text(
                      'Hàng triệu bài hát.\nMiễn phí trên Spotify.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24.sp,
                        fontWeight: FontWeight.bold,
                        height: 1.4,
                      ),
                    ),
                    Spacer(),
                    IconButtonFilled(
                      label: 'Đăng ký miễn phí',
                      icon: null,
                      onPressed: () {
                        Navigator.pushNamed(context, AppRoutes.signUpOptions);
                      },
                      backgroundColor: Color(0xFF1ED760),
                      foregroundColor: Colors.black,
                    ),
                    SizedBox(height: 10),
                    IconButtonFilled(
                      label: 'Đăng nhập',
                      icon: null,
                      onPressed: () {
                        Navigator.pushNamed(context, AppRoutes.signInOptions);
                      },
                      backgroundColor: Colors.transparent,
                      foregroundColor: Colors.white,
                      boder: Colors.grey,
                    ),
                    SizedBox(height: 48),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
