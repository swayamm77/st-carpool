import 'dart:convert';

import 'package:http/http.dart' as http;

import '../api_config.dart';

class RideService {
  /// Fetch all active rides with available seats
  static Future<List> getAvailableRides() async {
    final response = await http.get(
      Uri.parse("${ApiConfig.baseUrl}/api/rides"),
    );

    if (response.statusCode != 200) {
      throw Exception("Failed to fetch rides");
    }

    final rides = jsonDecode(response.body);

    return rides.where((ride) {
      return ride["status"] == "active" && ride["availableSeats"] > 0;
    }).toList();
  }

  /// Fetch rides created by a specific driver
  static Future<List> getMyRides(String driverId) async {
    final response = await http.get(
      Uri.parse("${ApiConfig.baseUrl}/api/rides"),
    );

    if (response.statusCode != 200) {
      throw Exception("Failed to fetch rides");
    }

    final rides = jsonDecode(response.body);

    return rides.where((ride) {
      return ride["driverId"]["_id"] == driverId;
    }).toList();
  }

  /// Delete a ride
  static Future<void> deleteRide(String rideId) async {
    final response = await http.delete(
      Uri.parse("${ApiConfig.baseUrl}/api/rides/$rideId"),
    );

    if (response.statusCode != 200) {
      throw Exception("Failed to delete ride");
    }
  }

  /// Mark a ride as completed
  static Future<void> completeRide(String rideId) async {
    final response = await http.patch(
      Uri.parse("${ApiConfig.baseUrl}/api/rides/$rideId/complete"),
    );

    if (response.statusCode != 200) {
      throw Exception("Failed to complete ride");
    }
  }
}
