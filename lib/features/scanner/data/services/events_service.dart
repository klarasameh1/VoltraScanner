import 'dart:convert';
import 'package:event_scanner_app/core/utils/api_response.dart';
import 'package:event_scanner_app/features/scanner/data/models/event.dart';
import 'package:http/http.dart' as http;

class EventsService {
  Future<ApiResponse<List<Event>>> getUpcomingEvents() async {
    try {
      // محاكاة API
      await Future.delayed(const Duration(seconds: 2));

      // بيانات تجريبية
      final List events = [
        {
          "id": 1,
          "name": "BMB Event",
          "date": "2026-02-28",
          "time": "4:00 pm",
          "checkedInCount": 15
        },
        {
          "id": 2,
          "name": "Find your Fit",
          "date": "2026-03-15",
          "time": "5:00 pm",
          "checkedInCount": 0
        },
      ];

      return ApiResponse.success(
        events.map((e) => Event.fromJson(e)).toList(),
      );

      /// REAL Code with API
      /*
      final response = await http.get(
        Uri.parse("https://your-api.com/events/upcoming"),
        headers: {
          'Content-Type': 'application/json',
          // 'Authorization': 'Bearer $token', // إذا احتجت توثيق
        },
      );

      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body);
        return ApiResponse.success(
          data.map((event) => Event.fromJson(event)).toList(),
        );
      } else {
        return ApiResponse.error(
          'Server error: ${response.statusCode}',
        );
      }
      */
    } catch (e) {
      return ApiResponse.error(
        'Network error: ${e.toString()}',
      );
    }
  }
}