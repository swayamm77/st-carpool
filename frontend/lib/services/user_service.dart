import 'dart:convert';

import 'package:http/http.dart' as http;

import '../api_config.dart';

class UserService {
  static Future<Map<String, dynamic>> login(String email) async {
    final response = await http.get(
      Uri.parse("${ApiConfig.baseUrl}/api/users/email/${email.trim()}"),
    );

    if (response.statusCode != 200) {
      throw Exception("User not found");
    }

    return jsonDecode(response.body);
  }

  static Future<Map<String, dynamic>> updateVehicle({
    required String userId,
    required String vehicleNumber,
    required String vehicleModel,
    required int vehicleSeats,
  }) async {
    final response = await http.patch(
      Uri.parse("${ApiConfig.baseUrl}/api/users/$userId/vehicle"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "vehicleNumber": vehicleNumber,
        "vehicleModel": vehicleModel,
        "vehicleSeats": vehicleSeats,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception("Failed to update vehicle");
    }

    return jsonDecode(response.body);
  }
}
