import 'package:event_scanner_app/features/scanner/data/models/event.dart';
import 'package:flutter/material.dart';
import '../features/scanner/data/services/events_service.dart';
import 'package:event_scanner_app/core/utils/api_response.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EventProvider extends ChangeNotifier {
  final EventsService _eventsService = EventsService();
  SharedPreferences? _prefs;

  List<Event> _events = [];
  bool _isLoading = false;
  String? _errorMessage;

  EventProvider() {
    _initPrefs();
  }

  Future<void> _initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
    // بعد ما الـ prefs يجهز، جيب الأحداث
    fetchEvents();
  }

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  List<Event> get events {
    if (_prefs == null) return _events;

    return _events.map((event) {
      final savedCount = _prefs!.getInt('checked_${event.id}');
      if (savedCount != null) {
        event.checkedInCount = savedCount;
      }
      return event;
    }).toList();
  }

  List<Event> get todayEvents {
    final now = DateTime.now();
    return events.where((event) {
      final eventDate = event.date;
      return eventDate.year == now.year &&
          eventDate.month == now.month &&
          eventDate.day == now.day;
    }).toList();
  }

  List<Event> get futureEvents {
    final now = DateTime.now();
    final todayEnd = DateTime(now.year, now.month, now.day, 23, 59, 59);
    return events.where((event) {
      final eventDate = event.date;
      return eventDate.isAfter(todayEnd);
    }).toList();
  }

  Future<void> fetchEvents() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _eventsService.getUpcomingEvents();

      if (response.status == Status.success) {
        _events = response.data!;

        if (_prefs != null) {
          for (var event in _events) {
            final savedCount = _prefs!.getInt('checked_${event.id}');
            if (savedCount != null) {
              event.checkedInCount = savedCount;
            }
          }
        }

        notifyListeners();
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

  void updateEventCheckedInCount(int eventId, int newCount) async {
    if (_prefs == null) return;

    await _prefs!.setInt('checked_$eventId', newCount);

    final index = _events.indexWhere((event) => event.id == eventId);
    if (index != -1) {
      _events[index].checkedInCount = newCount;
    }

    notifyListeners();
  }
}