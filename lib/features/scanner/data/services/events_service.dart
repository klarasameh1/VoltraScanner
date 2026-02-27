import 'dart:convert';

import 'package:event_scanner_app/models/event.dart';
/// WHEN API READY
// class EventsService {
//   Future<List<Event>> getUpcomingEvents() async {
//     final response = await http.get(
//       Uri.parse("https://your-api.com/events/upcoming"),
//     );
//
//     if (response.statusCode == 200) {
//       final List data = jsonDecode(response.body);
//
//       return data
//           .map((event) => Event.fromJson(event))
//           .toList();
//     } else {
//       throw Exception("Failed to load events");
//     }
//   }
// }