import 'create_ride_screen.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'ride_details_screen.dart';
import 'requests_screen.dart';
import 'api_config.dart';
import 'login_screen.dart';   
import 'current_user.dart';
import 'package:intl/intl.dart';
import 'my_rides_screen.dart';
import 'my_requests_screen.dart';

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
                  builder: (_) =>
                      const CreateRideScreen(),
                ),
              );

              if (result == true) {
                fetchRides();
              }
            },
            child: const Icon(Icons.add),
          )
        : null,

  drawer: Drawer(
    child: ListView(
      padding: EdgeInsets.zero,
      children: [
        UserAccountsDrawerHeader(
          accountName: Text(
            currentUser!["name"],
          ),
          accountEmail: Text(
            currentUser!["email"] ?? "",
          ),
          currentAccountPicture:
              const CircleAvatar(
            child: Icon(Icons.person),
          ),
        ),

        ListTile(
          leading: const Icon(Icons.home),
          title: const Text("Home"),
          onTap: () {
            Navigator.pop(context);
          },
        ),

        ListTile(
          leading: const Icon(
            Icons.directions_car,
          ),
          title: const Text("My Rides"),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) =>
                    const MyRidesScreen(),
              ),
            );
          },
        ),

        ListTile(
          leading: const Icon(
            Icons.assignment,
          ),
          title: const Text("My Requests"),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) =>
                    const MyRequestsScreen(),
              ),
            );
          },
        ),

        if (currentUser!["isDriver"] == true)
          ListTile(
            leading: const Icon(
              Icons.people,
            ),
            title: const Text(
              "Ride Requests",
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      const RequestsScreen(),
                ),
              );
            },
          ),

        const Divider(),

        ListTile(
          leading: const Icon(
            Icons.logout,
          ),
          title: const Text("Logout"),
          onTap: () {
            currentUser = null;

            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) =>
                    const LoginScreen(),
              ),
            );
          },
        ),
      ],
    ),
  ),

  appBar: AppBar(
  title: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text(
        "Welcome",
        style: TextStyle(fontSize: 12),
      ),
      Text(
        currentUser!["name"],
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    ],
  ),
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
        : RefreshIndicator(
    onRefresh: fetchRides,
    child: ListView.builder(
      itemCount: rides.length,
      itemBuilder: (context, index) {
                final ride = rides[index];

                final departureTime = DateTime.parse(
  ride["departureTime"],
);

final formattedTime =
    DateFormat("hh:mm a").format(departureTime);
    final formattedDate =
    DateFormat("dd MMM yyyy")
        .format(departureTime);

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
  "📅 $formattedDate",
),

const SizedBox(height: 4),

Text(
  "🕒 $formattedTime",
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
    fetchRides();
  }
},
  ),
);
              },
            ),
        ),
    );
  }
}