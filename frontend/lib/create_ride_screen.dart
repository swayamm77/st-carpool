import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CreateRideScreen extends StatefulWidget {
  const CreateRideScreen({super.key});

  @override
  State<CreateRideScreen> createState() => _CreateRideScreenState();
}

class _CreateRideScreenState extends State<CreateRideScreen> {
  final sourceController = TextEditingController();
  final destinationController = TextEditingController();
  final seatsController = TextEditingController();

  Future<void> createRide() async {
    final response = await http.post(
      Uri.parse("http://172.19.144.54:5000/api/rides"),
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "driverId": "6a26530dc6b8712a70c76458",
        "source": sourceController.text,
        "destination": destinationController.text,
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
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: sourceController,
              decoration: const InputDecoration(
                labelText: "Source",
              ),
            ),

            const SizedBox(height: 16),

            TextField(
              controller: destinationController,
              decoration: const InputDecoration(
                labelText: "Destination",
              ),
            ),

            const SizedBox(height: 16),

            TextField(
              controller: seatsController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Available Seats",
              ),
            ),

            const SizedBox(height: 24),

            ElevatedButton(
              onPressed: createRide,
              child: const Text("Create Ride"),
            )
          ],
        ),
      ),
    );
  }
}