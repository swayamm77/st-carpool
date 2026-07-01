import 'package:flutter/material.dart';

import '../current_user.dart';
import '../services/ride_service.dart';

import '../widgets/ride_card.dart';
import '../widgets/empty_state.dart';

import 'ride_details_screen.dart';

class MyRidesScreen extends StatefulWidget {
  const MyRidesScreen({super.key});

  @override
  State<MyRidesScreen> createState() => _MyRidesScreenState();
}

class _MyRidesScreenState extends State<MyRidesScreen> {
  List rides = [];
  bool isLoading = true;

  Future<void> fetchMyRides() async {
    try {
      final myRides = await RideService.getMyRides(currentUser!["_id"]);

      if (!mounted) return;

      setState(() {
        rides = myRides;
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
    fetchMyRides();
  }

  @override
  Widget build(BuildContext context) {
    final activeRides = rides
        .where((ride) => ride["status"] == "active" || ride["status"] == "full")
        .toList();

    final completedRides = rides
        .where((ride) => ride["status"] == "completed")
        .toList();

    return Scaffold(
      appBar: AppBar(title: const Text("My Rides")),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : DefaultTabController(
              length: 2,
              child: Column(
                children: [
                  const TabBar(
                    tabs: [
                      Tab(text: "Active"),
                      Tab(text: "Completed"),
                    ],
                  ),
                  Expanded(
                    child: TabBarView(
                      children: [
                        _buildRideList(activeRides),
                        _buildRideList(completedRides),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildRideList(List ridesList) {
    if (ridesList.isEmpty) {
      return const EmptyState(
        icon: Icons.directions_car,
        text: "No rides found",
      );
    }

    return RefreshIndicator(
      onRefresh: fetchMyRides,
      child: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: ridesList.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final ride = ridesList[index];

          return RideCard(
            ride: ride,
            onTap: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => RideDetailsScreen(ride: ride),
                ),
              );

              if (result == true) {
                fetchMyRides();
              }
            },
          );
        },
      ),
    );
  }
}
