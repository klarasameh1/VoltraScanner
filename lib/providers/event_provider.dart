import 'package:flutter/material.dart';
import '../features/scanner/data/models/event.dart';
import '../features/scanner/data/services/events_service.dart';

class EventProvider extends ChangeNotifier {
  List<Event> _upcomingEvents = [];
  bool _isLoading = false;
  String? _errorMessage;
  final EventsService _eventsService = EventsService();

  List<Event> get upcomingEvents => _upcomingEvents;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchEvents() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // استخدم API حقيقي أو Dummy data
      await Future.delayed(const Duration(seconds: 2)); // محاكاة التحميل

      // Dummy data مؤقتاً
      _upcomingEvents = [
        Event(id: 1, name: 'BMB Event', date: '2026-02-28', time: '4:00 pm', checkedInCount: 15),
        Event(id: 2, name: 'Find your Fit', date: '2026-03-15', time: '5:00 pm', checkedInCount: 0),
        Event(id: 3, name: 'Coding Competition', date: '2026-03-20', time: '6:30 pm', checkedInCount: 0),
        Event(id: 4, name: 'Coding Competition', date: '2026-03-20', time: '6:30 pm', checkedInCount: 0),
        Event(id: 5, name: 'Coding Competition', date: '2026-03-20', time: '6:30 pm', checkedInCount: 0),
        Event(id: 6, name: 'Coding Competition', date: '2026-03-20', time: '6:30 pm', checkedInCount: 0),
      ];

      ///replace with this when api ready
      // _upcomingEvents = await _eventsService.getUpcomingEvents();

    } catch (e) {
      _errorMessage = "Failed to load events. Please check your connection.";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void updateEventCheckedInCount(int eventId, int newCount) {
    final index = _upcomingEvents.indexWhere((event) => event.id == eventId);
    if (index != -1) {
      _upcomingEvents[index] = _upcomingEvents[index].copyWith(checkedInCount: newCount);
      notifyListeners();
    }
  }
}