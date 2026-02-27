import 'package:event_scanner_app/features/scanner/presentation/widgets/event_card.dart';
import 'package:event_scanner_app/models/event.dart';
import 'package:flutter/material.dart';

class EventsList extends StatelessWidget {
  final List<Event> events;

  const EventsList({super.key, required this.events});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: events.length,
      itemBuilder: (context, index) {
        return EventCard(event: events[index]);
      },
    );
  }
}