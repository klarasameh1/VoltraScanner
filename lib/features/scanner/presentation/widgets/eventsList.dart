import 'package:flutter/material.dart';

import '../../../../models/event.dart';
import 'event_card.dart';

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