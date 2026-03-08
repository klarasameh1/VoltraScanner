import 'package:flutter/material.dart';
import '../features/scanner/data/models/event.dart';
import '../features/scanner/data/services/events_service.dart';

class EventProvider extends ChangeNotifier {

  final EventsService _eventsService = EventsService();

  List<Event> _events = [];
  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  ///all events
  List<Event> get events => _events;

  /// Today's events
  List<Event> get todayEvents {
    final now = DateTime.now();

    return _events.where((event) {
      final eventDate = DateTime.parse(event.date);

      return eventDate.year == now.year &&
          eventDate.month == now.month &&
          eventDate.day == now.day;
    }).toList();
  }

  ///upcoming after today
  List<Event> get futureEvents {
    final now = DateTime.now();

    return _events.where((event) {
      final eventDate = DateTime.parse(event.date);

      return eventDate.isAfter(
        DateTime(now.year, now.month, now.day),
      );
    }).toList();
  }

  List<Event> get upcomingEvents => futureEvents;

  Future<void> fetchEvents() async {

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {

      await Future.delayed(const Duration(seconds: 2));

      /// Dummy data
      _events = [
        Event(
          id: 1,
          name: 'BMB Event',
          date: '2026-03-08',
          time: '4:00 pm',
          checkedInCount: 15,
        ),
        Event(
          id: 2,
          name: 'Find your Fit',
          date: '2026-03-15',
          time: '5:00 pm',
          checkedInCount: 0,
        ),
        Event(
          id: 3,
          name: 'Coding Competition',
          date: '2026-03-20',
          time: '6:30 pm',
          checkedInCount: 0,
        ),
        Event(
          id: 4,
          name: 'Tech Meetup',
          date: '2026-03-25',
          time: '7:00 pm',
          checkedInCount: 0,
        ),Event(
          id: 5,
          name: 'Tech Meetup',
          date: '2026-03-25',
          time: '7:00 pm',
          checkedInCount: 0,
        ),Event(
          id: 6,
          name: 'Tech Meetup',
          date: '2026-03-25',
          time: '7:00 pm',
          checkedInCount: 0,
        ),
      ];

///TO DO: when api come ready
      // _events = await _eventsService.getUpcomingEvents();

    } catch (e) {

      _errorMessage =
      "Failed to load events. Please check your connection.";

    } finally {

      _isLoading = false;
      notifyListeners();

    }
  }

  void updateEventCheckedInCount(int eventId, int newCount) {

    final index = _events.indexWhere((event) => event.id == eventId);

    if (index != -1) {
      _events[index] =
          _events[index].copyWith(checkedInCount: newCount);

      notifyListeners();
    }
  }
}