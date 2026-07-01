import 'package:flutter/material.dart';
import '../theme.dart';

class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onTap;

  const AppCard({super.key, required this.child, this.padding, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(22),
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: padding ?? const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: AppTheme.cardColor,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: Colors.white10),
          boxShadow: const [
            BoxShadow(
              color: Colors.black54,
              blurRadius: 10,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: child,
      ),
    );
  }
}
