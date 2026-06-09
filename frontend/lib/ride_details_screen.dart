import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'api_config.dart';

class RideDetailsScreen extends StatelessWidget {
  final Map ride;

  const RideDetailsScreen({
    super.key,
    required this.ride,
  });

  Future<void> requestRide(BuildContext context) async {
    final response = await http.post(
      Uri.parse("${ApiConfig.baseUrl}/api/requests"),
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "rideId": ride["_id"],

        // Rahul's ID for testing
        "passengerId": "6a267a87333f6059220cbd62"
      }),
    );

    if (response.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Ride requested successfully"),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ride Details"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "${ride["source"]} → ${ride["destination"]}",
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            Text("Seats: ${ride["availableSeats"]}"),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () => requestRide(context),
              child: const Text("Request Ride"),
            )
          ],
        ),
      ),
    );
  }
}