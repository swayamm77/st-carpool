import 'package:flutter/material.dart';

import '../theme.dart';
import '../constants/app_text.dart';
import 'app_card.dart';

class RouteCard extends StatelessWidget {
  final String source;
  final String destination;

  const RouteCard({super.key, required this.source, required this.destination});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: const [
              Icon(Icons.radio_button_checked, color: Colors.green, size: 16),
              SizedBox(height: 6),
              SizedBox(
                height: 45,
                child: VerticalDivider(thickness: 2, color: Colors.white24),
              ),
              Icon(Icons.location_on, color: AppTheme.primaryPurple, size: 20),
            ],
          ),

          const SizedBox(width: 18),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Source", style: AppText.caption),

                const SizedBox(height: 4),

                Text(source, style: AppText.cardTitle),

                const SizedBox(height: 24),

                Text("Destination", style: AppText.caption),

                const SizedBox(height: 4),

                Text(destination, style: AppText.cardTitle),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
