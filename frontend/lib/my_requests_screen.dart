import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'api_config.dart';
import 'current_user.dart';

class MyRequestsScreen extends StatefulWidget {
  const MyRequestsScreen({super.key});

  @override
  State<MyRequestsScreen> createState() =>
      _MyRequestsScreenState();
}

class _MyRequestsScreenState
    extends State<MyRequestsScreen> {

  List requests = [];
  bool isLoading = true;

  Future<void> fetchRequests() async {
    final response = await http.get(
      Uri.parse(
        "${ApiConfig.baseUrl}/api/requests",
      ),
    );

    if (response.statusCode == 200) {
  print(response.body);

  final allRequests =
      jsonDecode(response.body);

      setState(() {
        requests = allRequests.where(
  (request) =>
      request["passengerId"] != null &&
      request["rideId"] != null &&
      request["passengerId"]["_id"] ==
          currentUser!["_id"],
).toList();

        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchRequests();
  }

  Color getStatusColor(String status) {
    switch (status) {
      case "approved":
        return Colors.green;

      case "rejected":
        return Colors.red;

      default:
        return Colors.orange;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Requests"),
      ),
      body: isLoading
          ? const Center(
              child:
                  CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: requests.length,
              itemBuilder:
                  (context, index) {

                final request =
                    requests[index];

                return Card(
                  margin:
                      const EdgeInsets.all(
                    10,
                  ),
                  child: ListTile(
                    title: Text(
                      request["rideId"]
                          ["source"],
                    ),

                    subtitle: Text(
                      request["status"],
                    ),

                    trailing: Chip(
                      label: Text(
                        request["status"],
                      ),
                      backgroundColor:
                          getStatusColor(
                        request["status"],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}