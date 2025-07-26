import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify_b/blocs/register/register_data_cubit.dart';
import 'package:spotify_b/core/configs/app_routes.dart';
import 'package:spotify_b/presentation/widgets/next_button.dart';
import '../../../widgets/common_auth_scaffold.dart';

class EmailPutScreen extends StatefulWidget {
  const EmailPutScreen({super.key});

  @override
  State<EmailPutScreen> createState() => _EmailPutScreenState();
}

class _EmailPutScreenState extends State<EmailPutScreen> {
  final TextEditingController _emailController = TextEditingController();
  bool isValid = false;

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_validateEmail);
  }

  void _validateEmail() {
    final email = _emailController.text.trim();
    final emailRegex = RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$');
    final isEmailValid = emailRegex.hasMatch(email);
    if (isValid != isEmailValid) {
      setState(() {
        isValid = isEmailValid;
      });
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
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
              "Email của bạn là gì?",
              style: TextStyle(
                color: Colors.white,
                fontSize: 27,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            EmailInputFiel(emailController: _emailController),
            SizedBox(height: 16),
            Text(
              'Bạn cần xác nhận email này sau.',
              style: TextStyle(color: Colors.white, fontSize: 14),
            ),
            SizedBox(height: 20),
            Center(
              child: NextButton(
                isEnabled: isValid,
                onPressed: () {
                  if (isValid) {
                    final email = _emailController.text.trim();
                    context.read<RegisterDataCubit>().updateEmail(email);

                    Navigator.pushNamed(context, AppRoutes.passwordPut);
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

class EmailInputFiel extends StatelessWidget {
  const EmailInputFiel({
    super.key,
    required TextEditingController emailController,
  }) : _emailController = emailController;

  final TextEditingController _emailController;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _emailController,
      decoration: InputDecoration(
        filled: true,
        fillColor: Color(0xFF1E1E1E),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          borderSide: BorderSide.none,
        ),
        hintText: "Nhập email của bạn",
        hintStyle: TextStyle(color: Colors.grey),
      ),
      style: TextStyle(color: Colors.white),
    );
  }
}
