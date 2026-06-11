import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'api_config.dart';
import 'current_user.dart';
import 'package:intl/intl.dart';

class CreateRideScreen extends StatefulWidget {
  const CreateRideScreen({super.key});

  @override
  State<CreateRideScreen> createState() => _CreateRideScreenState();
}

class _CreateRideScreenState extends State<CreateRideScreen> {
  final sourceController = TextEditingController();
  final seatsController = TextEditingController();

  TimeOfDay? selectedTime;
  DateTime? selectedDate;

  Future<void> pickDate() async {
  final date = await showDatePicker(
    context: context,
    initialDate: DateTime.now(),
    firstDate: DateTime.now(),
    lastDate: DateTime.now().add(
      const Duration(days: 30),
    ),
  );

  if (date != null) {
    setState(() {
      selectedDate = date;
    });
  }
}

  Future<void> pickTime() async {
  final time = await showTimePicker(
    context: context,
    initialTime: TimeOfDay.now(),
  );

  if (time != null) {
    setState(() {
      selectedTime = time;
    });
  }
}

  Future<void> createRide() async {
    if (selectedDate == null) {
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      content: Text("Please select a travel date"),
    ),
  );
  return;
}
    if (selectedTime == null) {
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      content: Text("Please select a departure time"),
    ),
  );
  return;
}
    final response = await http.post(
      Uri.parse("${ApiConfig.baseUrl}/api/rides"),
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "driverId": currentUser!["_id"],
        "source": sourceController.text,
        "destination": "ST Greater Noida",
        "departureTime": DateTime(
  selectedDate!.year,
  selectedDate!.month,
  selectedDate!.day,
  selectedTime!.hour,
  selectedTime!.minute,
).toIso8601String(),
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

            InkWell(
  onTap: pickDate,
  child: Container(
    width: double.infinity,
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      border: Border.all(color: Colors.grey),
      borderRadius: BorderRadius.circular(8),
    ),
    child: Row(
      children: [
        const Icon(Icons.calendar_month),

        const SizedBox(width: 10),

        Text(
          selectedDate == null
              ? "Select Travel Date"
              : DateFormat(
                  "dd MMM yyyy",
                ).format(selectedDate!),
        ),
      ],
    ),
  ),
),

const SizedBox(height: 16),

            InkWell(
  onTap: pickTime,
  child: Container(
    width: double.infinity,
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      border: Border.all(color: Colors.grey),
      borderRadius: BorderRadius.circular(8),
    ),
    child: Row(
      children: [
        const Icon(Icons.access_time),

        const SizedBox(width: 10),

        Text(
          selectedTime == null
              ? "Select Departure Time"
              : selectedTime!.format(context),
        ),
      ],
    ),
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