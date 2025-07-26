import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify_b/blocs/register/register_bloc.dart';
import 'package:spotify_b/blocs/register/register_data_cubit.dart';
import 'package:spotify_b/blocs/register/register_event.dart';
import 'package:spotify_b/blocs/register/register_state.dart';
import 'package:spotify_b/core/configs/app_routes.dart';
import 'package:spotify_b/data/models/user_register_model.dart';
import 'package:spotify_b/presentation/widgets/common_auth_scaffold.dart';
import 'package:spotify_b/presentation/widgets/custom_snackbar.dart';

class NameInputScreen extends StatefulWidget {
  const NameInputScreen({super.key});

  @override
  State<NameInputScreen> createState() => _NameInputScreenState();
}

class _NameInputScreenState extends State<NameInputScreen> {
  final TextEditingController _nameController = TextEditingController();
  final FocusNode _nameFocusNode = FocusNode();
  bool receiveMarketing = false;
  bool shareData = false;

  @override
  void dispose() {
    _nameController.dispose();
    _nameFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<RegisterBloc, RegisterState>(
      listener: (context, state) async {
        if (state is RegisterLoading) {
          _nameFocusNode.unfocus(); // Đóng bàn phím
          showDialog(
            context: context,
            barrierDismissible: false, // Không cho phép đóng khi chạm bên ngoài
            builder:
                (context) => const Center(child: CircularProgressIndicator()),
          );
        } else if (state is RegisterSuccess) {
          Navigator.of(context).pop(); // Đóng dialog loading
          // ScaffoldMessenger.of(context).showSnackBar(
          //   const SnackBar(
          //     behavior: SnackBarBehavior.floating,
          //     margin: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          //     shape: RoundedRectangleBorder(
          //       borderRadius: BorderRadius.all(Radius.circular(30)),
          //     ),
          //     content: Text(
          //       "Đăng ký thành công!",
          //       style: TextStyle(
          //         fontSize: 12,
          //         color: Colors.white70,
          //         fontWeight: FontWeight.w400,
          //       ),
          //       textAlign: TextAlign.center,
          //     ),
          //   ),
          // );
          showCustomSnackBar(context: context, message: "Đăng ký thành công!");
          await Future.delayed(const Duration(milliseconds: 1000));
          if (context.mounted) {
            Navigator.pushNamedAndRemoveUntil(
              context,
              AppRoutes.loginEmail,
              (route) => false,
            );
          }
        } else if (state is RegisterFailure) {
          Navigator.of(context).pop(); // Đóng dialog loading
          // ScaffoldMessenger.of(context).showSnackBar(
          //   SnackBar(
          //     behavior: SnackBarBehavior.floating,
          //     margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          //     shape: RoundedRectangleBorder(
          //       borderRadius: BorderRadius.circular(30),
          //     ),
          //     content: Text(
          //       state.error,
          //       style: const TextStyle(
          //         fontSize: 12,
          //         color: Colors.white70,
          //         fontWeight: FontWeight.w400,
          //       ),
          //       textAlign: TextAlign.center,
          //     ),
          //   ),
          // );
          showCustomSnackBar(
            context: context,
            message: state.error,
          );
          // debugPrint("Register failed: ${state.error}");
        }
      },
      child: CommonAuthScaffold(
        body: SafeArea(
          child: GestureDetector(
            onTap: () {
              _nameFocusNode
                  .unfocus(); // Đóng bàn phím khi chạm ra ngoài TextField
            },
            behavior:
                HitTestBehavior
                    .opaque, // Cho phép GestureDetector nhận sự kiện chạm
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: IntrinsicHeight(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Tên của bạn là gì?",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),
                          TextField(
                            controller: _nameController,
                            focusNode:
                                _nameFocusNode, // Gán FocusNode cho TextField
                            autofocus:
                                false, // Ngăn TextField tự động lấy focus
                            style: const TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: const Color(0xFF1E1E1E),
                              hintText: "Nhập tên của bạn",
                              hintStyle: const TextStyle(color: Colors.grey),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(6),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            "Thông tin này xuất hiện trên hồ sơ Spotify của bạn.",
                            style: TextStyle(color: Colors.grey),
                          ),
                          const SizedBox(height: 24),
                          RichText(
                            text: const TextSpan(
                              children: [
                                TextSpan(
                                  text:
                                      'Bằng việc nhấn vào "Tạo tài khoản", bạn đồng ý với ',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                  ),
                                ),
                                TextSpan(
                                  text: 'Điều khoản sử dụng',
                                  style: TextStyle(
                                    color: Colors.greenAccent,
                                    fontSize: 14,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                                TextSpan(
                                  text: ' của Spotify.',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            "Để tìm hiểu thêm về cách thức Spotify thu thập, sử dụng, chia sẻ và bảo vệ dữ liệu cá nhân của bạn, vui lòng xem Chính sách quyền riêng tư của Spotify.",
                            style: TextStyle(color: Colors.white, fontSize: 14),
                          ),
                          const SizedBox(height: 10),
                          GestureDetector(
                            onTap: () {},
                            child: const Text(
                              "Chính sách quyền riêng tư",
                              style: TextStyle(
                                color: Colors.greenAccent,
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              Checkbox(
                                value: receiveMarketing,
                                activeColor: Colors.greenAccent,
                                onChanged: (val) {
                                  setState(() {
                                    receiveMarketing = val ?? false;
                                  });
                                },
                              ),
                              const Expanded(
                                child: Text(
                                  "Tôi không muốn nhận tin nhắn tiếp thị từ Spotify.",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Checkbox(
                                value: shareData,
                                activeColor: const Color.fromARGB(
                                  255,
                                  0,
                                  171,
                                  6,
                                ),
                                onChanged: (val) {
                                  setState(() {
                                    shareData = val ?? false;
                                  });
                                },
                              ),
                              const Expanded(
                                child: Text(
                                  "Chia sẻ dữ liệu đăng ký của tôi với các nhà cung cấp nội dung Spotify nhằm mục đích tiếp thị.",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 30),
                          buttonRegister(context),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  SizedBox buttonRegister(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed:
            _nameController.text.trim().isEmpty
                ? null
                : () {
                  context.read<RegisterDataCubit>().updateUsername(
                    _nameController.text.trim(),
                  );
                  final data = context.read<RegisterDataCubit>().state;
                  final user = UserRegisterModel(
                    email: data.email,
                    password: data.password,
                    username: data.username,
                    gender: data.gender,
                    birthdate: data.birthdate,
                  );
                  context.read<RegisterBloc>().add(SubmitRegisterEvent(user));
                },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          disabledBackgroundColor: Colors.grey.shade800,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: const Text(
          "Tạo tài khoản",
          style: TextStyle(color: Colors.black, fontSize: 16),
        ),
      ),
    );
  }
}
