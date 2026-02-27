import 'package:flutter/material.dart';
import '../../../../models/event.dart';

class EventCard extends StatelessWidget {
  final Event event;

  const EventCard({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFF028ECA),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25),
      ),
      elevation: 8,
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              event.name,
              style: const TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.calendar_today, size: 18, color: Color(0xffffd700)),
                const SizedBox(width: 6),
                Text(
                  event.date,
                  style: const TextStyle(color: Colors.white70),
                ),
                const SizedBox(width: 20),
                const Icon(Icons.access_time_rounded, size: 18, color: Color(0xffffd700)),
                const SizedBox(width: 6),
                Text(
                  event.time,
                  style: const TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}