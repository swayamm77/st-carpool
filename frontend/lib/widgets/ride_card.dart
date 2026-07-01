import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../theme.dart';
import 'app_card.dart';

import '../constants/app_text.dart';

class RideCard extends StatelessWidget {
  final Map ride;
  final VoidCallback onTap;

  const RideCard({super.key, required this.ride, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final departureTime = DateTime.parse(ride["departureTime"]);

    final formattedDate = DateFormat("dd MMM yyyy").format(departureTime);

    final formattedTime = DateFormat("hh:mm a").format(departureTime);
    return AppCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Route
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    decoration: const BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                    ),
                  ),

                  Container(width: 2, height: 38, color: Colors.white24),

                  const Icon(
                    Icons.location_on,
                    color: AppTheme.primaryPurple,
                    size: 20,
                  ),
                ],
              ),

              const SizedBox(width: 16),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(ride["source"], style: AppText.cardTitle),

                    const SizedBox(height: 24),

                    Text(
                      ride["destination"],
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          const Divider(),

          const SizedBox(height: 18),

          /// Driver & Vehicle
          Row(
            children: [
              const Icon(Icons.person_outline, size: 18, color: Colors.white70),

              const SizedBox(width: 6),

              Expanded(
                child: Text(
                  ride["driverId"]["name"],
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ),

              const Icon(
                Icons.directions_car_outlined,
                size: 18,
                color: Colors.white70,
              ),

              const SizedBox(width: 6),

              Flexible(
                child: Text(
                  ride["driverId"]["vehicleModel"],
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          /// Date & Time
          Row(
            children: [
              const Icon(
                Icons.calendar_today_outlined,
                size: 16,
                color: Colors.white60,
              ),

              const SizedBox(width: 6),

              Text(formattedDate),

              const SizedBox(width: 20),

              const Icon(Icons.access_time, size: 16, color: Colors.white60),

              const SizedBox(width: 6),

              Text(formattedTime),
            ],
          ),

          const SizedBox(height: 20),

          /// Bottom Row
          Row(
            children: [
              Icon(Icons.event_seat, color: Colors.green.shade400, size: 18),

              const SizedBox(width: 8),

              Text(
                "${ride["availableSeats"]} Seats Available",
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),

              const Spacer(),

              const Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Colors.white54,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
