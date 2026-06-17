import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'ride_details_screen.dart';
import 'api_config.dart';
import 'current_user.dart';

class MyRidesScreen extends StatefulWidget {
  const MyRidesScreen({super.key});

  @override
  State<MyRidesScreen> createState() =>
      _MyRidesScreenState();

      
}

class _MyRidesScreenState
    extends State<MyRidesScreen> {

      Widget buildRideList(
  List ridesList,
) {
  if (ridesList.isEmpty) {
    return const Center(
      child: Text(
        "No rides found",
      ),
    );
  }

  return ListView.builder(
    itemCount: ridesList.length,
    itemBuilder: (context, index) {
      final ride = ridesList[index];

      return Card(
        margin: const EdgeInsets.all(10),
        child: ListTile(
          title: Text(
            "${ride["source"]} → ${ride["destination"]}",
          ),

          subtitle: Text(
            "Seats: ${ride["availableSeats"]}",
          ),

          onTap: () async {
            final result =
                await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) =>
                    RideDetailsScreen(
                  ride: ride,
                ),
              ),
            );

            if (result == true) {
              fetchMyRides();
            }
          },
        ),
      );
    },
  );
}

  List rides = [];
  bool isLoading = true;

  Future<void> fetchMyRides() async {
    final response = await http.get(
      Uri.parse(
        "${ApiConfig.baseUrl}/api/rides",
      ),
    );

    if (response.statusCode == 200) {
      final allRides =
          jsonDecode(response.body);

      setState(() {
        rides = allRides.where(
          (ride) =>
              ride["driverId"]["_id"] ==
              currentUser!["_id"],
        ).toList();

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

    final activeRides = rides.where(
  (ride) =>
      ride["status"] == "active" ||
      ride["status"] == "full",
).toList();

final completedRides = rides.where(
  (ride) =>
      ride["status"] == "completed",
).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("My Rides"),
      ),
body: isLoading
    ? const Center(
        child:
            CircularProgressIndicator(),
      )
    : DefaultTabController(
        length: 2,
        child: Column(
          children: [
            const TabBar(
              tabs: [
                Tab(
                  text: "Active",
                ),
                Tab(
                  text: "Completed",
                ),
              ],
            ),

            Expanded(
              child: TabBarView(
                children: [
                  buildRideList(
                    activeRides,
                  ),

                  buildRideList(
                    completedRides,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}