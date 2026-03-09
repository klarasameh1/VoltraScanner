import 'package:flutter/material.dart';
import '../features/scanner/data/models/event.dart';
import '../features/scanner/data/services/events_service.dart';

class EventProvider extends ChangeNotifier {
  final EventsService _eventsService = EventsService();

  List<Event> _events = [];
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  List<Event> get events => _events;

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

  List<Event> get upcomingEvents => futureEvents;

  /// Fetch events (dummy data for now)
  Future<void> fetchEvents() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Simulate network delay
      await Future.delayed(const Duration(seconds: 2));

      // Dummy data with correct DateTime
      _events = [
        Event(
          id: 1,
          name: 'BMB Event',
          date: DateTime.now(),
          time: '5:00 pm',
          checkedInCount: 15,
        ),
        Event(
          id: 2,
          name: 'Find your Fit',
          date: DateTime(2026, 3, 15),
          time: '5:00 pm',
          checkedInCount: 0,
        ),
        Event(
          id: 3,
          name: 'Coding Competition',
          date: DateTime(2026, 3, 20),
          time: '6:30 pm',
          checkedInCount: 0,
        ),
        Event(
          id: 4,
          name: 'Tech Meetup',
          date: DateTime(2026, 3, 25),
          time: '7:00 pm',
          checkedInCount: 0,
        ),
        Event(
          id: 5,
          name: 'Tech Meetup',
          date: DateTime(2026, 3, 25),
          time: '7:00 pm',
          checkedInCount: 0,
        ),
        Event(
          id: 6,
          name: 'Tech Meetup',
          date: DateTime(2026, 3, 25),
          time: '7:00 pm',
          checkedInCount: 0,
        ),
      ];

      // TODO: Replace with API call
      // _events = await _eventsService.getUpcomingEvents();
    } catch (e) {
      _errorMessage = "Failed to load events. Please check your connection.";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Update checked-in count for an event
  void updateEventCheckedInCount(int eventId, int newCount) {
    final index = _events.indexWhere((event) => event.id == eventId);
    if (index != -1) {
      _events[index] = _events[index].copyWith(checkedInCount: newCount);
      notifyListeners();
    }
  }
}