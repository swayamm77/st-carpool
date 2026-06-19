import 'dart:convert';
import 'package:http/http.dart' as http;

class OlaMapsService {
  static const String apiKey =
      "2fzOL17m6fZYxNDuoso5CLCDV355QuZ9sVjYzAZ8";

  static Future<List<dynamic>>
      searchPlaces(String query) async {
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

    print(response.statusCode);
    print(response.body);

    if (response.statusCode == 200) {
      final data =
          jsonDecode(response.body);

      return data["predictions"];
    }

    return [];
  }
}