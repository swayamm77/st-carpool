import 'package:flutter/material.dart';
import '../current_user.dart';
import 'package:intl/intl.dart';

import '../services/ride_service.dart';
import '../services/request_service.dart';
import '../services/address_service.dart';

import '../widgets/route_card.dart';
import '../widgets/driver_card.dart';
import '../widgets/ride_info_card.dart';
import '../widgets/primary_button.dart';
import '../widgets/status_button.dart';
import '../widgets/address_picker_dialog.dart';

class RideDetailsScreen extends StatefulWidget {
  final Map ride;

  const RideDetailsScreen({super.key, required this.ride});

  @override
  State<RideDetailsScreen> createState() => _RideDetailsScreenState();
}

class _RideDetailsScreenState extends State<RideDetailsScreen> {
  String? requestStatus;
  List addresses = [];
  Map? selectedAddress;

  Future<void> showAddressDialog() async {
    final address = await showDialog<Map>(
      context: context,
      builder: (_) => AddressPickerDialog(addresses: addresses),
    );

    if (address == null) return;

    selectedAddress = address;

    await sendRideRequest();
  }

  Future<void> loadAddresses() async {
    try {
      final result = await AddressService.getAddresses(currentUser!["_id"]);

      if (!mounted) return;

      setState(() {
        addresses = result;
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> loadRequestStatus() async {
    try {
      requestStatus = await RequestService.checkRequestStatus(
        rideId: widget.ride["_id"],
        passengerId: currentUser!["_id"],
      );

      if (mounted) {
        setState(() {});
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> deleteCurrentRide() async {
    try {
      await RideService.deleteRide(widget.ride["_id"]);

      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Ride deleted")));

      Navigator.pop(context, true);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> completeCurrentRide() async {
    try {
      await RideService.completeRide(widget.ride["_id"]);

      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Ride completed")));

      Navigator.pop(context, true);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> sendRideRequest() async {
    try {
      await RequestService.requestRide(
        rideId: widget.ride["_id"],
        passengerId: currentUser!["_id"],
        pickupAddress: selectedAddress!["address"],
        pickupLat: selectedAddress!["lat"],
        pickupLng: selectedAddress!["lng"],
      );

      if (!mounted) return;

      setState(() {
        requestStatus = "pending";
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Ride requested successfully")),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString().replaceFirst("Exception: ", ""))),
      );
    }
  }

  @override
  void initState() {
    super.initState();

    if (widget.ride["driverId"]["_id"] != currentUser!["_id"]) {
      loadRequestStatus();

      loadAddresses();
    }
  }

  @override
  Widget build(BuildContext context) {
    final departureTime = DateTime.parse(widget.ride["departureTime"]);

    final formattedTime = DateFormat("hh:mm a").format(departureTime);

    final formattedDate = DateFormat("dd MMM yyyy").format(departureTime);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Ride Details",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 26),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            RouteCard(
              source: widget.ride["source"],
              destination: widget.ride["destination"],
            ),

            const SizedBox(height: 18),

            DriverCard(driver: widget.ride["driverId"]),

            const SizedBox(height: 18),

            RideInfoCard(
              date: formattedDate,
              time: formattedTime,
              seats: widget.ride["availableSeats"],
            ),

            const SizedBox(height: 24),

            if (widget.ride["driverId"]["_id"] == currentUser!["_id"])
              Column(
                children: [
                  PrimaryButton(
                    text: "Complete Ride",
                    onPressed: widget.ride["status"] == "completed"
                        ? null
                        : completeCurrentRide,
                  ),

                  const SizedBox(height: 14),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        final confirm = await showDialog<bool>(
                          context: context,
                          builder: (_) => AlertDialog(
                            title: const Text("Delete Ride"),
                            content: const Text("Are you sure?"),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context, false);
                                },
                                child: const Text("Cancel"),
                              ),

                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context, true);
                                },
                                child: const Text("Delete"),
                              ),
                            ],
                          ),
                        );

                        if (confirm == true) {
                          deleteCurrentRide();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                      child: const Text("Delete Ride"),
                    ),
                  ),
                ],
              )
            else
              StatusButton(
                status: requestStatus,
                onPressed: () async {
                  if (addresses.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Please add an address first"),
                      ),
                    );

                    return;
                  }

                  await showAddressDialog();
                },
              ),
          ],
        ),
      ),
    );
  }
}
