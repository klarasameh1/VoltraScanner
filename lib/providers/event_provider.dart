import 'package:event_scanner_app/features/scanner/data/models/event.dart';
import 'package:flutter/material.dart';
import '../features/scanner/data/services/events_service.dart';
import 'package:event_scanner_app/core/utils/api_response.dart';

class EventProvider extends ChangeNotifier {
  final EventsService _eventsService = EventsService();
  List<Event> _events = [];
  bool _isLoading = false;
  String? _errorMessage;
  final Map<int, int> _checkedInCache = {};

  List<Event> get events => _events.map((e) {
    final cached = _checkedInCache[e.id];
    return cached != null ? e.copyWith(checkedInCount: cached) : e;
  }).toList();

  void updateEventCheckedInCount(int eventId, int newCount) {
    _checkedInCache[eventId] = newCount;
    notifyListeners();
  }
  // Getters
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  /// Today's events
  List<Event> get todayEvents {
    final now = DateTime.now();
    return _events.where((event) {
      final eventDate = event.date;
      return eventDate.year == now.year &&
          eventDate.month == now.month &&
          eventDate.day == now.day;
    }).toList();
  }

  /// Upcoming events after today
  List<Event> get futureEvents {
    final now = DateTime.now();
    final todayEnd = DateTime(now.year, now.month, now.day, 23, 59, 59);

    return _events.where((event) {
      final eventDate = event.date;
      return eventDate.isAfter(todayEnd);
    }).toList();
  }

  /// Fetch events (dummy data for now)
  Future<void> fetchEvents() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _eventsService.getUpcomingEvents();

      if (response.status == Status.success) {
        _events = response.data!;
      } else {
        _errorMessage = response.message;
      }
    } catch (e) {
      _errorMessage = "Failed to load events. Please check your connection.";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}