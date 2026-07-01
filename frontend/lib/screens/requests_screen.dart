import 'package:flutter/material.dart';
import '../current_user.dart';
import 'route_preview_screen.dart';

import '../services/request_service.dart';

import '../widgets/app_card.dart';
import '../widgets/info_tile.dart';
import '../widgets/primary_button.dart';
import '../widgets/empty_state.dart';

class RequestsScreen extends StatefulWidget {
  const RequestsScreen({super.key});

  @override
  State<RequestsScreen> createState() => _RequestsScreenState();
}

class _RequestsScreenState extends State<RequestsScreen> {
  List requests = [];
  bool isLoading = true;

  Future<void> fetchRequests() async {
    try {
      final driverRequests = await RequestService.getDriverRequests(
        currentUser!["_id"],
      );

      if (!mounted) return;

      setState(() {
        requests = driverRequests;
        isLoading = false;
      });
    } catch (e) {
      debugPrint(e.toString());

      if (!mounted) return;

      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> updateRequestStatus(String requestId, String status) async {
    try {
      await RequestService.updateRequestStatus(
        requestId: requestId,
        status: status,
      );

      await fetchRequests();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            status == "approved" ? "Request Approved" : "Request Rejected",
          ),
        ),
      );
    } catch (e) {
      debugPrint(e.toString());
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
      appBar: AppBar(title: const Text("Ride Requests")),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : requests.isEmpty
          ? const EmptyState(
              icon: Icons.people_outline,
              text: "No pending requests",
            )
          : ListView.builder(
              padding: const EdgeInsets.only(top: 8, bottom: 16),
              itemCount: requests.length,
              itemBuilder: (context, index) {
                final request = requests[index];

                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: AppCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InfoTile(
                          icon: Icons.person,
                          title: "Passenger",
                          value: request["passengerId"]["name"],
                        ),

                        InfoTile(
                          icon: Icons.email,
                          title: "Email",
                          value: request["passengerId"]["email"],
                        ),

                        InfoTile(
                          icon: Icons.route,
                          title: "Route",
                          value:
                              "${request["rideId"]["source"]} → ${request["rideId"]["destination"]}",
                        ),

                        InfoTile(
                          icon: Icons.location_on,
                          title: "Pickup",
                          value: request["pickupAddress"] ?? "Not Provided",
                        ),

                        const SizedBox(height: 12),

                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => RoutePreviewScreen(
                                    sourceLat: request["rideId"]["sourceLat"],
                                    sourceLng: request["rideId"]["sourceLng"],
                                    pickupLat: request["pickupLat"],
                                    pickupLng: request["pickupLng"],
                                    passengerName:
                                        request["passengerId"]["name"],
                                    pickupAddress:
                                        request["pickupAddress"] ??
                                        "Address not available",
                                    sourceName: request["rideId"]["source"],
                                  ),
                                ),
                              );
                            },
                            child: const Text("View Route"),
                          ),
                        ),

                        const SizedBox(height: 12),

                        Chip(
                          label: Text(
                            request["status"].toUpperCase(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          backgroundColor: request["status"] == "approved"
                              ? Colors.green
                              : request["status"] == "rejected"
                              ? Colors.red
                              : Colors.orange,
                        ),

                        const SizedBox(height: 16),

                        if (request["status"] == "pending")
                          Row(
                            children: [
                              Expanded(
                                child: PrimaryButton(
                                  text: "Approve",
                                  onPressed: () {
                                    updateRequestStatus(
                                      request["_id"],
                                      "approved",
                                    );
                                  },
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
