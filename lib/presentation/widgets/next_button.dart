import 'package:flutter/material.dart';

class NextButton extends StatelessWidget {
  final bool isEnabled;
  final VoidCallback? onPressed;

  const NextButton({
    super.key,
    required this.isEnabled,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100,
      height: 48,
      child: ElevatedButton(
        onPressed: isEnabled ? onPressed : null,
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.resolveWith<Color>(
            (states) {
              if (states.contains(WidgetState.disabled)) {
                return const Color(0xFF5A5A5A);
              }
              return Colors.white;
            },
          ),
          foregroundColor: WidgetStateProperty.all(Colors.black),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50),
            ),
          ),
          elevation: WidgetStateProperty.resolveWith<double>(
            (states) => states.contains(WidgetState.disabled) ? 0 : 2,
          ),
        ),
        child: const Text(
          'Tiếp',
          style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black),
        ),
      ),
    );
  }
}
