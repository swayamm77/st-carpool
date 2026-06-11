import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'api_config.dart';
import 'current_user.dart';
import 'package:intl/intl.dart';

class RideDetailsScreen extends StatefulWidget {
  final Map ride;

  const RideDetailsScreen({
    super.key,
    required this.ride,
  });

  @override
  State<RideDetailsScreen> createState() =>
      _RideDetailsScreenState();
}

class _RideDetailsScreenState
    extends State<RideDetailsScreen> {

      String? requestStatus;

  Future<void> deleteRide(BuildContext context) async {
  final response = await http.delete(
    Uri.parse(
      "${ApiConfig.baseUrl}/api/rides/${widget.ride["_id"]}",
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

Future<void> fetchRequestStatus() async {
  final response = await http.get(
    Uri.parse(
      "${ApiConfig.baseUrl}/api/requests/check/${widget.ride["_id"]}/${currentUser!["_id"]}",
    ),
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);

    setState(() {
      requestStatus = data["status"];
    });
  }
}

  Future<void> requestRide(BuildContext context) async {
    final response = await http.post(
      Uri.parse("${ApiConfig.baseUrl}/api/requests"),
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "rideId": widget.ride["_id"],

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

  setState(() {
    requestStatus = "pending";
  });
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
void initState() {
  super.initState();

  if (widget.ride["driverId"]["_id"] !=
      currentUser!["_id"]) {
    fetchRequestStatus();
  }
}

  @override
  Widget build(BuildContext context) {
    final departureTime = DateTime.parse(
  widget.ride["departureTime"],
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
              "${widget.ride["source"]} → ${widget.ride["destination"]}",
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
  "💺 Seats Available: ${widget.ride["availableSeats"]}",
  style: const TextStyle(
    fontSize: 16,
  ),
),

            const SizedBox(height: 20),

if (widget.ride["driverId"]["_id"] == currentUser!["_id"])
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

            if (widget.ride["driverId"]["_id"] != currentUser!["_id"])
  SizedBox(
    width: double.infinity,
    child: ElevatedButton(
      onPressed:
          requestStatus == null
              ? () => requestRide(context)
              : null,
      style: ElevatedButton.styleFrom(
  backgroundColor:
      requestStatus == null
          ? Colors.blue
          : requestStatus == "pending"
              ? Colors.orange
              : requestStatus == "approved"
                  ? Colors.green
                  : Colors.red,

  disabledBackgroundColor:
      requestStatus == "pending"
          ? Colors.orange
          : requestStatus == "approved"
              ? Colors.green
              : requestStatus == "rejected"
                  ? Colors.red
                  : Colors.blue,

  foregroundColor: Colors.white,
  disabledForegroundColor: Colors.white,
),  
      child: Text(
        requestStatus == null
            ? "Request Ride"
            : requestStatus == "pending"
                ? "Requested"
                : requestStatus == "approved"
                    ? "Approved"
                    : "Rejected",
      ),
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