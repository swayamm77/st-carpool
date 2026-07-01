import 'package:flutter/material.dart';

import '../current_user.dart';
import '../theme.dart';

import '../screens/login_screen.dart';
import '../screens/my_rides_screen.dart';
import '../screens/my_requests_screen.dart';
import '../screens/requests_screen.dart';
import '../screens/vehicle_registration_screen.dart';
import '../screens/add_address_screen.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            decoration: const BoxDecoration(color: AppTheme.primaryPurple),
            accountName: Text(currentUser!["name"]),
            accountEmail: Text(currentUser!["email"] ?? ""),
            currentAccountPicture: const CircleAvatar(
              child: Icon(Icons.person),
            ),
          ),

          ListTile(
            leading: const Icon(Icons.home),
            title: const Text("Home"),
            onTap: () => Navigator.pop(context),
          ),

          ListTile(
            leading: const Icon(Icons.car_rental),
            title: const Text("My Vehicle"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const VehicleRegistrationScreen(),
                ),
              );
            },
          ),

          ListTile(
            leading: const Icon(Icons.location_on),
            title: const Text("My Addresses"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AddAddressScreen()),
              );
            },
          ),

          ListTile(
            leading: const Icon(Icons.directions_car),
            title: const Text("My Rides"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const MyRidesScreen()),
              );
            },
          ),

          ListTile(
            leading: const Icon(Icons.assignment),
            title: const Text("My Requests"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const MyRequestsScreen()),
              );
            },
          ),

          if (currentUser!["vehicleRegistered"] == true)
            ListTile(
              leading: const Icon(Icons.people),
              title: const Text("Ride Requests"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const RequestsScreen()),
                );
              },
            ),

          const Divider(),

          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text("Logout"),
            onTap: () {
              currentUser = null;

              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
                (route) => false,
              );
            },
          ),
        ],
      ),
    );
  }
}
