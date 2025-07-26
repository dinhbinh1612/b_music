import 'package:flutter/material.dart';

class CommonAuthScaffold extends StatelessWidget {
  final Widget body;
  final bool showCloseIcon;

  const CommonAuthScaffold({
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
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Tạo tài khoản',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: body,
    );
  }
}
