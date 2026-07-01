import 'package:flutter/material.dart';
import '../theme.dart';

class AppButton extends StatelessWidget {
  final String text;
  final IconData? icon;
  final VoidCallback onPressed;

  const AppButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 58,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: icon != null ? Icon(icon) : const SizedBox.shrink(),
        label: Text(
          text,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.primaryPurple,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
      ),
    );
  }
}
