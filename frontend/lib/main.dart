import 'create_ride_screen.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'ride_details_screen.dart';
import 'requests_screen.dart';
import 'api_config.dart';
import 'login_screen.dart';   
import 'current_user.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: const LoginScreen(),
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
      floatingActionButton:
    currentUser!["isDriver"] == true
        ? FloatingActionButton(
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
          )
        : null,
        
      appBar: AppBar(
  title: Text(
    "ST Carpool - ${currentUser!["name"]}",
  ),
  actions: [
    if (currentUser!["isDriver"] == true)
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

    IconButton(
      icon: const Icon(Icons.logout),
      onPressed: () {
        currentUser = null;

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => const LoginScreen(),
          ),
        );
      },
    ),
  ],
),
        
      body: isLoading
    ? const Center(
        child: CircularProgressIndicator(),
      )
    : rides.isEmpty
        ? const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.directions_car_outlined,
                  size: 80,
                ),
                SizedBox(height: 16),
                Text(
                  "No rides available",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          )
        : ListView.builder(
          
              itemCount: rides.length,
              itemBuilder: (context, index) {
                final ride = rides[index];

                return Card(
  margin: const EdgeInsets.symmetric(
    horizontal: 12,
    vertical: 8,
  ),
  elevation: 4,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(12),
  ),
  child: ListTile(
    contentPadding: const EdgeInsets.all(16),

    title: Text(
      ride["source"],
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    ),

    subtitle: Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "📍 ${ride["destination"]}",
          ),

          const SizedBox(height: 4),

          Text(
            "💺 ${ride["availableSeats"]} Seats Available",
          ),
        ],
      ),
    ),

    trailing: const Icon(
      Icons.arrow_forward_ios,
      size: 18,
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