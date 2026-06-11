import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'api_config.dart';
import 'current_user.dart';
import 'package:intl/intl.dart';

class RideDetailsScreen extends StatelessWidget {
  final Map ride;

  const RideDetailsScreen({
    super.key,
    required this.ride,
  });

  Future<void> deleteRide(BuildContext context) async {
  final response = await http.delete(
    Uri.parse(
      "${ApiConfig.baseUrl}/api/rides/${ride["_id"]}",
    ),
  );

  if (response.statusCode == 200) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Ride deleted"),
      ),
    );

    Navigator.pop(context, true);
  }
}

  Future<void> requestRide(BuildContext context) async {
    final response = await http.post(
      Uri.parse("${ApiConfig.baseUrl}/api/requests"),
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "rideId": ride["_id"],

        // Rahul's ID for testing
        "passengerId": currentUser!["_id"]
      }),
    );

    print("STATUS CODE: ${response.statusCode}");
    print("BODY: ${response.body}");

    if (response.statusCode == 201) {
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      content: Text("Ride requested successfully"),
    ),
  );
} else {
  final data = jsonDecode(response.body);

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(data["message"]),
    ),
  );
}
  }

  @override
  Widget build(BuildContext context) {
    final departureTime = DateTime.parse(
  ride["departureTime"],
);

final formattedTime =
    DateFormat("hh:mm a").format(departureTime);

    final formattedDate =
    DateFormat("dd MMM yyyy")
        .format(departureTime);
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

            Text(
  "📅 Date: $formattedDate",
  style: const TextStyle(
    fontSize: 16,
  ),
),

const SizedBox(height: 10),

Text(
  "🕒 Departure: $formattedTime",
  style: const TextStyle(
    fontSize: 16,
  ),
),

const SizedBox(height: 10),

Text(
  "💺 Seats Available: ${ride["availableSeats"]}",
  style: const TextStyle(
    fontSize: 16,
  ),
),

            const SizedBox(height: 20),

if (ride["driverId"]["_id"] == currentUser!["_id"])
  SizedBox(
    width: double.infinity,
    child: ElevatedButton(
      onPressed: () async {
  final confirm = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text("Delete Ride"),
      content: const Text(
        "Are you sure you want to delete this ride?",
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context, false);
          },
          child: const Text("Cancel"),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context, true);
          },
          child: const Text("Delete"),
        ),
      ],
    ),
  );

  if (confirm == true) {
    deleteRide(context);
  }
},
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
      ),
      child: const Text("Delete Ride"),
    ),
  ),

            const SizedBox(height: 20),

            if (ride["driverId"]["_id"] != currentUser!["_id"])
  SizedBox(
    width: double.infinity,
    child: ElevatedButton(
      onPressed: () => requestRide(context),
      child: const Text("Request Ride"),
    ),
  )
else
  const Text(
    "This is your ride",
    style: TextStyle(
      fontWeight: FontWeight.bold,
    ),
  ),
          ],
        ),
      ),
    );
  }
}