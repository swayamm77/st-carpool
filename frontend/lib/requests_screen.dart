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
  Future<void> approveRequest(String requestId) async {
  final response = await http.patch(
    Uri.parse(
      "${ApiConfig.baseUrl}/api/requests/$requestId",
    ),
    headers: {
      "Content-Type": "application/json",
    },
    body: jsonEncode({
      "status": "approved",
    }),
  );

  print("STATUS CODE: ${response.statusCode}");
  print("BODY: ${response.body}");

  if (response.statusCode == 200) {
    fetchRequests();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Request Approved"),
      ),
    );

    Navigator.pop(context, true);
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(response.body),
      ),
    );
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
          : ListView.builder(
              itemCount: requests.length,
              itemBuilder: (context, index) {
                final request = requests[index];

                return Card(
                  margin: const EdgeInsets.all(10),
                  child: ListTile(
                    title: Text(
                      request["passengerId"]["name"],
                    ),
                    subtitle: Text(
                      "${request["rideId"]["source"]} → "
                      "${request["rideId"]["destination"]}\n"
                      "Status: ${request["status"]}",
                    ),
                    trailing: request["status"] == "pending"
                        ? ElevatedButton(
                            onPressed: () {
                              approveRequest(
                                request["_id"],
                              );
                            },
                            child: const Text("Approve"),
                          )
                        : const Text("Approved"),
                  ),
                );
              },
            ),
    );
  }
}