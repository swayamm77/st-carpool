import 'package:flutter/material.dart';

import '../current_user.dart';

import '../constants/app_spacing.dart';

import '../services/user_service.dart';

import '../widgets/app_card.dart';
import '../widgets/info_tile.dart';
import '../widgets/primary_button.dart';

class VehicleRegistrationScreen extends StatefulWidget {
  const VehicleRegistrationScreen({super.key});

  @override
  State<VehicleRegistrationScreen> createState() =>
      _VehicleRegistrationScreenState();
}

class _VehicleRegistrationScreenState extends State<VehicleRegistrationScreen> {
  bool isEditing = false;

  final vehicleNumberController = TextEditingController();

  final vehicleModelController = TextEditingController();

  final seatController = TextEditingController();

  @override
  void initState() {
    super.initState();

    if (currentUser!["vehicleRegistered"] == true) {
      vehicleNumberController.text = currentUser!["vehicleNumber"];

      vehicleModelController.text = currentUser!["vehicleModel"];

      seatController.text = currentUser!["vehicleSeats"].toString();
    }
  }

  Future<void> saveVehicle() async {
    final vehicleNumber = vehicleNumberController.text.trim().toUpperCase();

    final vehicleRegex = RegExp(r'^[A-Z]{2}[0-9]{1,2}[A-Z]{1,3}[0-9]{4}$');

    if (!vehicleRegex.hasMatch(vehicleNumber)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Enter a valid vehicle number")),
      );
      return;
    }

    try {
      currentUser = await UserService.updateVehicle(
        userId: currentUser!["_id"],
        vehicleNumber: vehicleNumber,
        vehicleModel: vehicleModelController.text.trim(),
        vehicleSeats: int.parse(seatController.text),
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Vehicle saved successfully")),
      );

      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString().replaceFirst("Exception: ", ""))),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasVehicle = currentUser!["vehicleRegistered"] == true;
    return Scaffold(
      appBar: AppBar(title: const Text("My Vehicle")),
      body: (hasVehicle && !isEditing)
          ? Padding(
              padding: const EdgeInsets.all(16),
              child: AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Vehicle Details",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 20),

                    InfoTile(
                      icon: Icons.directions_car,
                      title: "Model",
                      value: currentUser!["vehicleModel"],
                    ),

                    InfoTile(
                      icon: Icons.confirmation_number,
                      title: "Number",
                      value: currentUser!["vehicleNumber"],
                    ),

                    InfoTile(
                      icon: Icons.event_seat,
                      title: "Seats",
                      value: currentUser!["vehicleSeats"].toString(),
                    ),

                    const SizedBox(height: 20),

                    PrimaryButton(
                      text: "Edit Vehicle",
                      onPressed: () {
                        setState(() {
                          isEditing = true;
                        });
                      },
                    ),
                  ],
                ),
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  TextField(
                    controller: vehicleNumberController,
                    decoration: const InputDecoration(
                      labelText: "Vehicle Number",
                    ),
                  ),

                  AppSpacing.md,

                  TextField(
                    controller: vehicleModelController,
                    decoration: const InputDecoration(
                      labelText: "Vehicle Model",
                    ),
                  ),

                  AppSpacing.md,

                  TextField(
                    controller: seatController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: "Seat Capacity",
                    ),
                  ),

                  const SizedBox(height: 24),

                  PrimaryButton(
                    text: hasVehicle ? "Save Changes" : "Add Vehicle",
                    onPressed: saveVehicle,
                  ),
                ],
              ),
            ),
    );
  }
}
