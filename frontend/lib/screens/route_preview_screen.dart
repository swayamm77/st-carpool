import 'package:flutter/material.dart';
import '../services/ola_maps_service.dart';
import 'package:url_launcher/url_launcher.dart';

import '../widgets/app_card.dart';
import '../widgets/info_tile.dart';
import '../widgets/primary_button.dart';
import '../widgets/stat_chip.dart';
import '../widgets/empty_state.dart';

class RoutePreviewScreen extends StatefulWidget {
  final double sourceLat;
  final double sourceLng;

  final double pickupLat;
  final double pickupLng;

  final String sourceName;
  final String passengerName;
  final String pickupAddress;

  const RoutePreviewScreen({
    super.key,
    required this.sourceLat,
    required this.sourceLng,
    required this.pickupLat,
    required this.pickupLng,

    required this.passengerName,
    required this.pickupAddress,
    required this.sourceName,
  });

  @override
  State<RoutePreviewScreen> createState() => _RoutePreviewScreenState();
}

class _RoutePreviewScreenState extends State<RoutePreviewScreen> {
  Map<String, dynamic>? routeData;

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchRoute();
  }

  Future<void> openInMaps() async {
    final url = Uri.parse(
      "https://www.google.com/maps/dir/?api=1"
      "&origin=${widget.sourceLat},${widget.sourceLng}"
      "&destination=${widget.pickupLat},${widget.pickupLng}"
      "&travelmode=driving",
    );

    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> fetchRoute() async {
    final result = await OlaMapsService.getRoute(
      widget.sourceLat,
      widget.sourceLng,
      widget.pickupLat,
      widget.pickupLng,
    );

    setState(() {
      routeData = result;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final leg = routeData?["routes"]?[0]?["legs"]?[0];

    final readableDistance = "${leg?["readable_distance"] ?? "Unknown"} km";

    String readableDuration = leg?["readable_duration"] ?? "Unknown";

    readableDuration = readableDuration
        .replaceAll("0 hours ", "")
        .replaceAll("0 hour ", "")
        .replaceAll("0 hrs ", "")
        .replaceAll("0 hr ", "");

    if (!isLoading &&
        (routeData == null ||
            routeData!["routes"] == null ||
            routeData!["routes"].isEmpty)) {
      return Scaffold(
        appBar: AppBar(title: const Text("Route Preview")),
        body: const EmptyState(icon: Icons.map, text: "Unable to load route"),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Route Preview")),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  AppCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Pickup Route",
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 24),

                        Row(
                          children: [
                            Expanded(
                              child: StatChip(
                                icon: Icons.route,
                                title: "Distance",
                                value: readableDistance,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: StatChip(
                                icon: Icons.schedule,
                                title: "ETA",
                                value: readableDuration,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 28),

                        const Divider(),

                        const SizedBox(height: 28),

                        InfoTile(
                          icon: Icons.flag,
                          title: "Ride Source",
                          value: widget.sourceName,
                        ),

                        const SizedBox(height: 20),

                        InfoTile(
                          icon: Icons.location_on,
                          title: widget.passengerName,
                          value: widget.pickupAddress,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  SizedBox(
                    width: double.infinity,
                    height: 58,
                    child: PrimaryButton(
                      text: "Open in Google Maps",
                      icon: Icons.map,
                      onPressed: openInMaps,
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
