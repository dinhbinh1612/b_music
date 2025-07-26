import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify_b/blocs/register/register_data_cubit.dart';
import 'package:spotify_b/core/configs/app_routes.dart';
import 'package:spotify_b/presentation/widgets/common_auth_scaffold.dart';
import 'package:spotify_b/presentation/widgets/next_button.dart';

class PasswordPutScreen extends StatefulWidget {
  const PasswordPutScreen({super.key});

  @override
  State<PasswordPutScreen> createState() => _PasswordPutScreenState();
}

class _PasswordPutScreenState extends State<PasswordPutScreen> {
  final TextEditingController _passwordController = TextEditingController();
  bool isValid = false;

  @override
  void initState() {
    super.initState();
    _passwordController.addListener(_validatePassword);
  }

  void _validatePassword() {
    final password = _passwordController.text;
    final isValidNow = password.length >= 8;

    if (isValid != isValidNow) {
      setState(() {
        isValid = isValidNow;
      });
    }
  }

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CommonAuthScaffold(
      body: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 30),
            Text(
              "Tạo một mật khẩu",
              style: TextStyle(
                color: Colors.white,
                fontSize: 27,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            PasswordInputField(passwordController: _passwordController),
            SizedBox(height: 16),
            Text(
              'Sử dụng ít nhất 8 ký tự.',
              style: TextStyle(color: Colors.white, fontSize: 14),
            ),
            SizedBox(height: 20),
            Center(
              child: NextButton(
                isEnabled: isValid,
                onPressed: () {
                  if (isValid) {
                    final password = _passwordController.text.trim();
                    context.read<RegisterDataCubit>().updatePassword(password);

                    Navigator.pushNamed(context, AppRoutes.birthDatePut);
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PasswordInputField extends StatelessWidget {
  const PasswordInputField({super.key, required this.passwordController});

  final TextEditingController passwordController;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: passwordController,
      obscureText: true,
      decoration: const InputDecoration(
        filled: true,
        fillColor: Color(0xFF1E1E1E),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          borderSide: BorderSide.none,
        ),
        hintText: "Nhập mật khẩu của bạn",
        hintStyle: TextStyle(color: Colors.grey),
      ),
      style: const TextStyle(color: Colors.white),
    );
  }
}
