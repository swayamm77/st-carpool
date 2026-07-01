import 'package:flutter/material.dart';

import 'app_card.dart';
import 'info_tile.dart';

class DriverCard extends StatelessWidget {
  final Map driver;

  const DriverCard({super.key, required this.driver});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Driver",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 20),

          InfoTile(
            icon: Icons.person,
            title: "Driver Name",
            value: driver["name"],
          ),

          InfoTile(
            icon: Icons.directions_car,
            title: "Vehicle",
            value: driver["vehicleModel"],
          ),

          InfoTile(
            icon: Icons.confirmation_number,
            title: "Vehicle Number",
            value: driver["vehicleNumber"],
          ),
        ],
      ),
    );
  }
}
