import 'package:flutter/material.dart';

import '../current_user.dart';
import '../services/request_service.dart';

import '../widgets/app_card.dart';
import '../widgets/empty_state.dart';
import '../widgets/info_tile.dart';

class MyRequestsScreen extends StatefulWidget {
  const MyRequestsScreen({super.key});

  @override
  State<MyRequestsScreen> createState() => _MyRequestsScreenState();
}

class _MyRequestsScreenState extends State<MyRequestsScreen> {
  List requests = [];
  bool isLoading = true;

  Future<void> fetchRequests() async {
    try {
      final myRequests = await RequestService.getPassengerRequests(
        currentUser!["_id"],
      );

      if (!mounted) return;

      setState(() {
        requests = myRequests;
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
      appBar: AppBar(title: const Text("My Requests")),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : requests.isEmpty
          ? const EmptyState(icon: Icons.assignment, text: "No requests found")
          : RefreshIndicator(
              onRefresh: fetchRequests,
              child: ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: requests.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final request = requests[index];

                  return AppCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InfoTile(
                          icon: Icons.route,
                          title: "Route",
                          value:
                              "${request["rideId"]["source"]} → ${request["rideId"]["destination"]}",
                        ),

                        InfoTile(
                          icon: Icons.person,
                          title: "Driver",
                          value: request["rideId"]["driverId"]["name"],
                        ),

                        InfoTile(
                          icon: Icons.directions_car,
                          title: "Vehicle",
                          value:
                              "${request["rideId"]["driverId"]["vehicleModel"]} (${request["rideId"]["driverId"]["vehicleNumber"]})",
                        ),

                        InfoTile(
                          icon: Icons.event_seat,
                          title: "Seats",
                          value: "${request["rideId"]["availableSeats"]}",
                        ),

                        const SizedBox(height: 12),

                        Align(
                          alignment: Alignment.centerLeft,
                          child: Chip(
                            label: Text(
                              request["status"].toUpperCase(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            backgroundColor: getStatusColor(request["status"]),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
    );
  }
}
