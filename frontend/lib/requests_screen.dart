import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'api_config.dart';
import 'current_user.dart';

class RequestsScreen extends StatefulWidget {
  const RequestsScreen({super.key});

  @override
  State<RequestsScreen> createState() => _RequestsScreenState();
}

class _RequestsScreenState extends State<RequestsScreen> {
  List requests = [];
  bool isLoading = true;

  Future<void> fetchRequests() async {
  print("FETCHING REQUESTS");

  try {
    final response = await http.get(
      Uri.parse("${ApiConfig.baseUrl}/api/requests"),
    );

    print("STATUS CODE: ${response.statusCode}");
    print("BODY: ${response.body}");

    if (response.statusCode == 200) {
  if (!mounted) return;

  setState(() {
    requests = jsonDecode(response.body)
    .where((request) =>
        request["status"] == "pending" &&
        request["rideId"] != null &&
        request["rideId"]["driverId"] == currentUser!["_id"])
    .toList();

    isLoading = false;
  });
}
  } catch (e) {
    print("ERROR:");
    print(e);

    if (!mounted) return;

setState(() {
  isLoading = false;
});
  }
}
  Future<void> updateRequestStatus(
  String requestId,
  String status,
) async {
  final response = await http.patch(
    Uri.parse(
      "${ApiConfig.baseUrl}/api/requests/$requestId",
    ),
    headers: {
      "Content-Type": "application/json",
    },
    body: jsonEncode({
      "status": status,
    }),
  );

  if (response.statusCode == 200) {
    fetchRequests();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          status == "approved"
              ? "Request Approved"
              : "Request Rejected",
        ),
      ),
    );
    Navigator.pop(context, true); 
  }
}

  @override
  void initState() {
    super.initState();
    fetchRequests();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ride Requests"),
      ),
      body: isLoading
    ? const Center(
        child: CircularProgressIndicator(),
      )
    : requests.isEmpty
        ? const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.people_outline,
                  size: 80,
                ),
                SizedBox(height: 16),
                Text(
                  "No pending requests",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          )
        : ListView.builder(
          
              itemCount: requests.length,
              itemBuilder: (context, index) {
                final request = requests[index];

                return Card(
  margin: const EdgeInsets.symmetric(
    horizontal: 12,
    vertical: 8,
  ),
  elevation: 4,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(12),
  ),
  child: Padding(
    padding: const EdgeInsets.all(12),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "👤 ${request["passengerId"]["name"]}",
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 8),

        Text(
          "📍 ${request["rideId"]["source"]} → ${request["rideId"]["destination"]}",
        ),

        const SizedBox(height: 4),

        Text(
          "Status: ${request["status"]}",
        ),

        const SizedBox(height: 12),

        if (request["status"] == "pending")
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    updateRequestStatus(
                      request["_id"],
                      "approved",
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text("Approve"),
                ),
              ),

              const SizedBox(width: 10),

              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    updateRequestStatus(
                      request["_id"],
                      "rejected",
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text("Reject"),
                ),
              ),
            ],
          ),
      ],
    ),
  ),
);
              },
            ),
    );
  }
}