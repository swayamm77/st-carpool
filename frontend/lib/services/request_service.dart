import 'dart:convert';

import 'package:http/http.dart' as http;

import '../api_config.dart';

class RequestService {
  /// Request a ride
  static Future<void> requestRide({
    required String rideId,
    required String passengerId,
    required String pickupAddress,
    required double pickupLat,
    required double pickupLng,
  }) async {
    final response = await http.post(
      Uri.parse("${ApiConfig.baseUrl}/api/requests"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "rideId": rideId,
        "passengerId": passengerId,
        "pickupAddress": pickupAddress,
        "pickupLat": pickupLat,
        "pickupLng": pickupLng,
      }),
    );

    if (response.statusCode != 201) {
      final data = jsonDecode(response.body);
      throw Exception(data["message"]);
    }
  }

  /// Check current user's request status
  static Future<String?> checkRequestStatus({
    required String rideId,
    required String passengerId,
  }) async {
    final response = await http.get(
      Uri.parse("${ApiConfig.baseUrl}/api/requests/check/$rideId/$passengerId"),
    );

    if (response.statusCode != 200) {
      return null;
    }

    final data = jsonDecode(response.body);

    return data["status"];
  }

  /// Approve / Reject a request
  static Future<void> updateRequestStatus({
    required String requestId,
    required String status,
  }) async {
    final response = await http.patch(
      Uri.parse("${ApiConfig.baseUrl}/api/requests/$requestId"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"status": status}),
    );

    if (response.statusCode != 200) {
      throw Exception("Failed to update request");
    }
  }

  /// Requests received by a driver
  static Future<List> getDriverRequests(String driverId) async {
    final response = await http.get(
      Uri.parse("${ApiConfig.baseUrl}/api/requests"),
    );

    if (response.statusCode != 200) {
      throw Exception("Failed to fetch requests");
    }

    final requests = jsonDecode(response.body);

    return requests.where((request) {
      return request["rideId"] != null &&
          request["rideId"]["driverId"] != null &&
          request["rideId"]["driverId"]["_id"] == driverId;
    }).toList();
  }

  /// Requests sent by a passenger
  /// Passenger's requests
  static Future<List> getPassengerRequests(String passengerId) async {
    final response = await http.get(
      Uri.parse("${ApiConfig.baseUrl}/api/requests"),
    );

    if (response.statusCode != 200) {
      throw Exception("Failed to fetch requests");
    }

    final requests = jsonDecode(response.body);

    return requests.where((request) {
      return request["passengerId"] != null &&
          request["rideId"] != null &&
          request["passengerId"]["_id"] == passengerId;
    }).toList();
  }
}
