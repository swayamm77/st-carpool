import 'package:flutter/material.dart';

import 'app_card.dart';
import 'info_tile.dart';

class RideInfoCard extends StatelessWidget {
  final String date;
  final String time;
  final int seats;

  const RideInfoCard({
    super.key,
    required this.date,
    required this.time,
    required this.seats,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Ride Information",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 20),

          InfoTile(icon: Icons.calendar_today, title: "Date", value: date),

          InfoTile(icon: Icons.access_time, title: "Departure", value: time),

          InfoTile(
            icon: Icons.event_seat,
            title: "Available Seats",
            value: "$seats",
          ),
        ],
      ),
    );
  }
}
