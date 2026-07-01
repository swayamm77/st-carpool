import 'dart:convert';

import 'package:http/http.dart' as http;

import '../api_config.dart';

class AddressService {
  /// Fetch all saved addresses for a user
  static Future<List> getAddresses(String userId) async {
    final response = await http.get(
      Uri.parse("${ApiConfig.baseUrl}/api/addresses/$userId"),
    );

    if (response.statusCode != 200) {
      throw Exception("Failed to fetch addresses");
    }

    return jsonDecode(response.body);
  }

  /// Add a new address
  static Future<void> addAddress({
    required String userId,
    required String name,
    required String address,
    required double lat,
    required double lng,
  }) async {
    final response = await http.post(
      Uri.parse("${ApiConfig.baseUrl}/api/addresses"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "userId": userId,
        "name": name,
        "address": address,
        "lat": lat,
        "lng": lng,
      }),
    );

    if (response.statusCode != 201) {
      throw Exception("Failed to add address");
    }
  }

  /// Delete an address
  static Future<void> deleteAddress(String addressId) async {
    final response = await http.delete(
      Uri.parse("${ApiConfig.baseUrl}/api/addresses/$addressId"),
    );

    if (response.statusCode != 200) {
      throw Exception("Failed to delete address");
    }
  }
}
