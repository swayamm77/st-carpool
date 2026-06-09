import 'create_ride_screen.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'ride_details_screen.dart';
import 'requests_screen.dart';
import 'api_config.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: RideListScreen(),
    );
  }
}

class RideListScreen extends StatefulWidget {
  const RideListScreen({super.key});

  @override
  State<RideListScreen> createState() => _RideListScreenState();
}

class _RideListScreenState extends State<RideListScreen> {
  List rides = [];
  bool isLoading = true;

  Future<void> fetchRides() async {
  print("STARTING FETCH");

  try {
    final response = await http.get(
      Uri.parse("${ApiConfig.baseUrl}/api/rides"),
    );

    print("STATUS: ${response.statusCode}");
    print(response.body);

    if (!mounted) return;

    setState(() {
      rides = jsonDecode(response.body)
          .where((ride) =>
              ride["status"] == "active" &&
              ride["availableSeats"] > 0)
          .toList();

      isLoading = false;
    });
  } catch (e) {
    print("ERROR:");
    print(e);

    if (!mounted) return;

    setState(() {
      isLoading = false;
    });
  }
}
  @override
  void initState() {
    super.initState();
    fetchRides();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const CreateRideScreen(),
            ),
          );

          if (result == true) {
            fetchRides();
          }
        },
        child: const Icon(Icons.add),
    ),
      appBar: AppBar(
        title: const Text("ST Carpool"),
        actions: [
          IconButton(
            icon: const Icon(Icons.people),
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const RequestsScreen(),
                ),
              );

              if (result == true) {
                fetchRides();
              }
            },
          ),
        ],
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: rides.length,
              itemBuilder: (context, index) {
                final ride = rides[index];

                return Card(
                  margin: const EdgeInsets.all(10),
                  child: ListTile(
                    title: Text(
                      "${ride["source"]} → ${ride["destination"]}",
                    ),
                    subtitle: Text(
                      "Seats: ${ride["availableSeats"]}",
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => RideDetailsScreen(
                            ride: ride,
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}