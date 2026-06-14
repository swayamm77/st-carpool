import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'api_config.dart';
import 'current_user.dart';

class VehicleRegistrationScreen
    extends StatefulWidget {
  const VehicleRegistrationScreen({
    super.key,
  });

  @override
  State<VehicleRegistrationScreen>
      createState() =>
          _VehicleRegistrationScreenState();
}

class _VehicleRegistrationScreenState
    extends State<
        VehicleRegistrationScreen> {

  final vehicleNumberController =
      TextEditingController();

  final vehicleModelController =
      TextEditingController();

  final seatController =
      TextEditingController();

  Future<void> saveVehicle() async {
    final response = await http.patch(
      Uri.parse(
        "${ApiConfig.baseUrl}/api/users/${currentUser!["_id"]}/vehicle",
      ),
      headers: {
        "Content-Type":
            "application/json",
      },
      body: jsonEncode({
        "vehicleNumber":
            vehicleNumberController.text,
        "vehicleModel":
            vehicleModelController.text,
        "vehicleSeats":
            int.parse(
              seatController.text,
            ),
      }),
    );

    if (response.statusCode == 200) {
      currentUser =
          jsonDecode(response.body);

      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            "Vehicle registered successfully",
          ),
        ),
      );

      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
final hasVehicle =
    currentUser!["vehicleRegistered"] == true;
    return Scaffold(
      appBar: AppBar(
        title:
            const Text("My Vehicle"),
      ),
      body: hasVehicle
    ? Padding(
        padding: const EdgeInsets.all(16),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                const Text(
                  "Vehicle Details",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 20),

                Text(
                  "🚘 Model: ${currentUser!["vehicleModel"]}",
                ),

                const SizedBox(height: 10),

                Text(
                  "🔢 Number: ${currentUser!["vehicleNumber"]}",
                ),

                const SizedBox(height: 10),

                Text(
                  "💺 Seats: ${currentUser!["vehicleSeats"]}",
                ),
              ],
            ),
          ),
        ),
      )

          : Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller:
                  vehicleNumberController,
              decoration:
                  const InputDecoration(
                labelText:
                    "Vehicle Number",
              ),
            ),

            const SizedBox(height: 16),

            TextField(
              controller:
                  vehicleModelController,
              decoration:
                  const InputDecoration(
                labelText:
                    "Vehicle Model",
              ),
            ),

            const SizedBox(height: 16),

            TextField(
              controller: seatController,
              keyboardType:
                  TextInputType.number,
              decoration:
                  const InputDecoration(
                labelText:
                    "Seat Capacity",
              ),
            ),

            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: saveVehicle,
                child: const Text(
                  "Add Vehicle",
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}