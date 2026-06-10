import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'api_config.dart';
import 'current_user.dart';

class CreateRideScreen extends StatefulWidget {
  const CreateRideScreen({super.key});

  @override
  State<CreateRideScreen> createState() => _CreateRideScreenState();
}

class _CreateRideScreenState extends State<CreateRideScreen> {
  final sourceController = TextEditingController();
  final seatsController = TextEditingController();

  Future<void> createRide() async {
    final response = await http.post(
      Uri.parse("${ApiConfig.baseUrl}/api/rides"),
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "driverId": currentUser!["_id"],
        "source": sourceController.text,
        "destination": "ST Greater Noida",
        "departureTime": DateTime.now().toIso8601String(),
        "availableSeats": int.parse(seatsController.text),
        "notes": ""
      }),
    );

    if (response.statusCode == 201) {
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Ride"),
      ),
      body: Center(
  child: SingleChildScrollView(
    child: Padding(
      padding: const EdgeInsets.all(20),
      child: Card(
        elevation: 6,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
  Icons.directions_car,
  size: 60,
),

const SizedBox(height: 12),

const Text(
  "Create Ride",
  style: TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
  ),
),

const SizedBox(height: 24),
            TextField(
  controller: sourceController,
  decoration: const InputDecoration(
    labelText: "Pickup Location",
    border: OutlineInputBorder(),
    prefixIcon: Icon(Icons.location_on),
  ),
),

            const SizedBox(height: 16),


Container(
  width: double.infinity,
  padding: const EdgeInsets.all(14),
  decoration: BoxDecoration(
    color: Colors.blue.shade50,
    borderRadius: BorderRadius.circular(10),
  ),
  child: const Row(
    children: [
      Icon(Icons.flag),

      SizedBox(width: 10),

      Expanded(
        child: Text(
          "Destination: ST Greater Noida",
          style: TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    ],
  ),
),

            const SizedBox(height: 16),

            TextField(
  controller: seatsController,
  keyboardType: TextInputType.number,
  decoration: const InputDecoration(
    labelText: "Available Seats",
    border: OutlineInputBorder(),
    prefixIcon: Icon(Icons.event_seat),
  ),
),

            const SizedBox(height: 24),

            SizedBox(
  width: double.infinity,
  child: ElevatedButton(
    onPressed: createRide,
    child: const Text("Create Ride"),
  ),
),

            ],
          ),
        ),
      ),
    ),
  ),
),
    );
  }
}