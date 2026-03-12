import 'dart:convert';
import 'package:event_scanner_app/core/utils/api_response.dart';
import 'package:event_scanner_app/features/scanner/data/models/event.dart';
import 'package:http/http.dart' as http;

class EventsService {

  Future<ApiResponse<List<Event>>> getUpcomingEvents() async {

    try {
      final response = await http.get(
        Uri.parse("https://node-core-1qx9.vercel.app/api/events/upcoming"),
      );

      //debug
      // print("Status Code: ${response.statusCode}");
      // print("Response Body: ${response.body}");

      if (response.statusCode == 200) {

        final Map<String, dynamic> json = jsonDecode(response.body);

        final List data = json["data"];

        return ApiResponse.success(
          data.map((event) => Event.fromJson(event)).toList(),
        );

      } else {
        return ApiResponse.error('Server error: ${response.statusCode}');
      }
    } catch (e) {
      return ApiResponse.error('Network error: ${e.toString()}');
    }
  }
}