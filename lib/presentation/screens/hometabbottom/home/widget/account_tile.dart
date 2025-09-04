import 'package:flutter/material.dart';

class AccountTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  const AccountTile({super.key, required this.icon, required this.label, this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(label, style: const TextStyle(color: Colors.white)),
      onTap: onTap,
      splashColor: Colors.transparent,
    );
  }
}
