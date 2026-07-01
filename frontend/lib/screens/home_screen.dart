import 'package:flutter/material.dart';

import '../current_user.dart';
import '../theme.dart';

import '../widgets/empty_state.dart';
import '../widgets/app_drawer.dart';
import '../widgets/ride_card.dart';
import '../widgets/section_title.dart';

import '../services/ride_service.dart';

import '../constants/app_text.dart';

import 'create_ride_screen.dart';
import 'ride_details_screen.dart';

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
      final availableRides = await RideService.getAvailableRides();

      if (!mounted) return;

      setState(() {
        rides = availableRides;
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
    fetchRides();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: currentUser!["vehicleRegistered"] == true
          ? FloatingActionButton(
              backgroundColor: AppTheme.primaryPurple,
              foregroundColor: Colors.white,
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const CreateRideScreen()),
                );

                if (result == true) {
                  fetchRides();
                }
              },
              child: const Icon(Icons.add),
            )
          : null,

      drawer: const AppDrawer(),
      appBar: AppBar(
        toolbarHeight: 90,
        automaticallyImplyLeading: true,
        titleSpacing: 20,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Welcome back,",
              style: TextStyle(
                color: Colors.white.withOpacity(.65),
                fontSize: 14,
              ),
            ),

            const SizedBox(height: 4),

            Text(currentUser!["name"], style: AppText.pageTitle),
          ],
        ),

        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 18),
            child: CircleAvatar(
              radius: 22,
              backgroundColor: AppTheme.primaryPurple,
              child: Text(
                currentUser!["name"][0],
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),

      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : rides.isEmpty
          ? const EmptyState(icon: Icons.route, text: "No rides available")
          : Column(
              children: [
                const SectionTitle(
                  title: "Available Rides",
                  subtitle: "Find a ride that matches your journey.",
                ),

                Expanded(
                  child: RefreshIndicator(
                    onRefresh: fetchRides,
                    child: ListView.separated(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 6,
                      ),
                      itemCount: rides.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 14),
                      itemBuilder: (context, index) {
                        final ride = rides[index];

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
                              fetchRides();
                            }
                          },
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
