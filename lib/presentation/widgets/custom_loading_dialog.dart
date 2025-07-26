import 'package:flutter/material.dart';

void showCustomLoadingDialog({
  required BuildContext context,
  String? message,
}) {
  showDialog(
    context: context,
    barrierDismissible: false, // Không cho phép đóng dialog bằng cách nhấn ra ngoài
    builder: (context) => Center(
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          // ignore: deprecated_member_use
          color: Colors.black.withOpacity(0.8),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                Color(0xFF1DB954), // Màu xanh lá Spotify
              ),
            ),
            // if (message != null) ...[
            //   const SizedBox(height: 16),
            //   Text(
            //     message,
            //     style: const TextStyle(
            //       color: Colors.white,
            //       fontSize: 16,
            //       fontWeight: FontWeight.w500,
            //     ),
            //   ),
            // ],
          ],
        ),
      ),
    ),
  );
}