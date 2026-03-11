import 'dart:convert';
import 'package:event_scanner_app/core/utils/api_response.dart';
import 'package:event_scanner_app/features/scanner/data/models/event.dart';
import 'package:http/http.dart' as http;

class EventsService {
  // for testing with dummy data
  final bool useDummyData = true;

  Future<ApiResponse<List<Event>>> getUpcomingEvents() async {

    ///testing ///will be removed
    if (useDummyData) {
      return _getDummyEvents();
    }

    try {
      final response = await http.get(
        Uri.parse("https://node-core-2f9r.vercel.app/api/events/upcoming"),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer YOUR_TOKEN_HERE',
        },
      );

      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body);
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

  /// to return dummy data ///remoooove
  ApiResponse<List<Event>> _getDummyEvents() {
    // simulated delay
    Future.delayed(const Duration(seconds: 1));

    final now = DateTime.now();
    final tomorrow = DateTime(now.year, now.month, now.day + 1);
    final nextWeek = DateTime(now.year, now.month, now.day + 7);

    final dummyEvents = [
      Event(
        id: 1,
        name: "Flutter Workshop",
        date: now,
        time: "10:00 AM - 1:00 PM",
        checkedInCount: 45,
      ),
      Event(
        id: 2,
        name: "Tech Conference 2026",
        date: now,
        time: "2:00 PM - 6:00 PM",
        checkedInCount: 120,
      ),
      Event(
        id: 3,
        name: "AI Summit",
        date: tomorrow,
        time: "9:00 AM - 5:00 PM",
        checkedInCount: 0,
      ),
      Event(
        id: 4,
        name: "Startup Meetup",
        date: nextWeek,
        time: "6:00 PM - 9:00 PM",
        checkedInCount: 0,
      ),
      Event(
        id: 5,
        name: "Web Development Bootcamp",
        date: DateTime(now.year, now.month, now.day + 3),
        time: "11:00 AM - 4:00 PM",
        checkedInCount: 0,
      ),
      Event(
        id: 6,
        name: "UX Design Workshop",
        date: DateTime(now.year, now.month, now.day + 5),
        time: "1:00 PM - 5:00 PM",
        checkedInCount: 0,
      ),
    ];

    return ApiResponse.success(dummyEvents);
  }
}