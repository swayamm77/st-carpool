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
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Rides"),
      ),
      body: isLoading
          ? const Center(
              child:
                  CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: rides.length,
              itemBuilder:
                  (context, index) {

                final ride = rides[index];

                return Card(
                  margin:
                      const EdgeInsets.all(
                    10,
                  ),
                  child: ListTile(
                    title: Text(
  "${ride["source"]} → ${ride["destination"]}",
),

subtitle: Text(
  "Seats: ${ride["availableSeats"]}",
),

onTap: () async {
  final result = await Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => RideDetailsScreen(
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
            ),
    );
  }
}