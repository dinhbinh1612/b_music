import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify_b/blocs/login/login_cubit.dart';
import 'package:spotify_b/core/configs/app_routes.dart';
import 'package:spotify_b/data/providers/auth_provider.dart';
import 'package:spotify_b/presentation/widgets/common_auth_email_scaffold.dart';
import 'package:spotify_b/presentation/widgets/custom_loading_dialog.dart';
import 'package:spotify_b/presentation/widgets/custom_snackbar.dart';

class LoginEmailScreen extends StatefulWidget {
  const LoginEmailScreen({super.key});

  @override
  State<LoginEmailScreen> createState() => _LoginEmailScreenState();
}

class _LoginEmailScreenState extends State<LoginEmailScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool isEmailValid = false;
  bool isPasswordValid = false;
  bool isPasswordObscured = true;

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_validate);
    _passwordController.addListener(_validate);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _validate() {
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    final emailRegex = RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$');
    setState(() {
      isEmailValid = emailRegex.hasMatch(email);
      isPasswordValid = password.length >= 8;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LoginCubit(AuthProvider()),
      child: Builder(
        builder:
            (newContext) => BlocListener<LoginCubit, LoginState>(
              listener: (newContext, state) {
                if (state is LoginLoading) {
                  // Hiển thị dialog loading khi trạng thái là LoginLoading
                  showCustomLoadingDialog(context: context);
                } else if (state is LoginSuccess) {
                  Navigator.pushNamedAndRemoveUntil(
                    newContext,
                    AppRoutes.main,
                    (route) => false,
                  );
                } else if (state is LoginFailure) {
                  final error = state.errorMessage;

                  final errorMessage =
                      error.contains('Invalid credentials')
                          ? 'Email hoặc mật khẩu không hợp lệ'
                          : 'Đã xảy ra lỗi, vui lòng thử lại';

                  showCustomSnackBar(context: context, message: errorMessage);
                }
              },
              child: loginEmailView(newContext),
            ),
      ),
    );
  }

  CommonAuthScaffoldSignin loginEmailView(BuildContext context) {
    return CommonAuthScaffoldSignin(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 36),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Đăng nhập bằng email",
              style: TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 36),

            /// Email Input
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              autofillHints: const [AutofillHints.email],
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color(0xFF1E1E1E),
                hintText: 'Email của bạn',
                hintStyle: const TextStyle(color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 16),

            /// Password Input
            TextField(
              controller: _passwordController,
              obscureText: isPasswordObscured,
              autofillHints: const [AutofillHints.password],
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color(0xFF1E1E1E),
                hintText: 'Mật khẩu',
                hintStyle: const TextStyle(color: Colors.grey),
                suffixIcon: IconButton(
                  icon: Icon(
                    isPasswordObscured
                        ? Icons.visibility_off
                        : Icons.visibility,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    setState(() {
                      isPasswordObscured = !isPasswordObscured;
                    });
                  },
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 0),

            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {},
                child: const Text(
                  "Quên mật khẩu?",
                  style: TextStyle(color: Colors.white70),
                ),
              ),
            ),

            const SizedBox(height: 24),

            Center(
              child: ElevatedButton(
                onPressed:
                    (isEmailValid && isPasswordValid)
                        ? () {
                          FocusScope.of(context).unfocus();

                          final email = _emailController.text.trim();
                          final password = _passwordController.text;
                          context.read<LoginCubit>().login(email, password);
                        }
                        : null, // disable khi chưa hợp lệ
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 14,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                child: const Text(
                  'Đăng nhập',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
