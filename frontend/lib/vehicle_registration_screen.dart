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

          bool isEditing = false;

  final vehicleNumberController =
      TextEditingController();

  final vehicleModelController =
      TextEditingController();

  final seatController =
      TextEditingController();

      @override
void initState() {
  super.initState();

  if (currentUser!["vehicleRegistered"] == true) {
    vehicleNumberController.text =
        currentUser!["vehicleNumber"];

    vehicleModelController.text =
        currentUser!["vehicleModel"];

    seatController.text =
        currentUser!["vehicleSeats"]
            .toString();
  }
}

  Future<void> saveVehicle() async {

    final vehicleNumber =
    vehicleNumberController.text
        .trim()
        .toUpperCase();

final vehicleRegex = RegExp(
  r'^[A-Z]{2}[0-9]{1,2}[A-Z]{1,3}[0-9]{4}$',
);

if (!vehicleRegex.hasMatch(
  vehicleNumber,
)) {
  ScaffoldMessenger.of(context)
      .showSnackBar(
    const SnackBar(
      content: Text(
        "Enter a valid vehicle number",
      ),
    ),
  );
  return;
} 

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
      vehicleNumber,

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
      body: (hasVehicle && !isEditing)
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
                const SizedBox(height: 20),

SizedBox(
  width: double.infinity,
  child: ElevatedButton(
    onPressed: () {
      setState(() {
        isEditing = true;
      });
    },
    child: const Text("Edit Vehicle"),
  ),
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
                child: Text(
  hasVehicle
      ? "Save Changes"
      : "Add Vehicle",
),
              ),
            ),
          ],
        ),
      ),
    );
  }
}