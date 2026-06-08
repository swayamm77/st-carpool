import 'create_ride_screen.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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
    try {
      final response = await http.get(
        Uri.parse("http://172.19.144.54:5000/api/rides"),
      );

      if (response.statusCode == 200) {
        setState(() {
          rides = jsonDecode(response.body);
          isLoading = false;
        });
      }
    } catch (e) {
      print(e);
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
                  ),
                );
              },
            ),
    );
  }
}