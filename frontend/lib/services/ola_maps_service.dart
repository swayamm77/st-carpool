import 'dart:convert';
import 'package:http/http.dart' as http;

class OlaMapsService {
  static const String apiKey = "2fzOL17m6fZYxNDuoso5CLCDV355QuZ9sVjYzAZ8";

  static Future<Map<String, dynamic>?> getRoute(
    double originLat,
    double originLng,
    double destLat,
    double destLng,
  ) async {
    final response = await http.post(
      Uri.parse(
        "https://api.olamaps.io/routing/v1/directions"
        "?origin=$originLat,$originLng"
        "&destination=$destLat,$destLng"
        "&api_key=$apiKey",
      ),
      headers: {"X-Request-Id": "st-carpool-route"},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }

    return null;
  }

  static Future<List<dynamic>> searchPlaces(String query) async {
    if (query.isEmpty) {
      return [];
    }

    final response = await http.get(
      Uri.parse(
        "https://api.olamaps.io/places/v1/autocomplete"
        "?input=$query"
        "&api_key=$apiKey",
      ),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      return data["predictions"];
    }

    return [];
  }
}
