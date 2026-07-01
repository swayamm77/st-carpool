import 'package:flutter/material.dart';

import '../constants/app_text.dart';
import '../theme.dart';

class InfoTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const InfoTile({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: AppTheme.primaryPurple.withOpacity(.15),
            child: Icon(icon, color: AppTheme.primaryPurple),
          ),

          const SizedBox(width: 16),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppText.caption),

                const SizedBox(height: 2),

                Text(value, style: AppText.body),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
