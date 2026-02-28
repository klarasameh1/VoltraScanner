import 'package:flutter/material.dart';
import '../../data/models/event.dart';

class EventCard extends StatelessWidget {
  final Event event;
  final VoidCallback onTap;

  const EventCard({
    super.key,
    required this.event,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Determine event status color
    final DateTime eventDate = DateTime.parse(event.date); // assuming event.date is 'YYYY-MM-DD'
    final DateTime today = DateTime.now();
    Color statusColor;
    bool isToday = false ;

    if (eventDate.year == today.year &&
        eventDate.month == today.month &&
        eventDate.day == today.day) {
      statusColor = Color(0xff4fea44); // Today
      isToday=true;
    } else if (eventDate.isAfter(today)) {
      statusColor = Colors.yellow; // Upcoming
    } else {
      statusColor = Colors.grey; // Past events (optional)
    }

    return GestureDetector(
      onTap: onTap,
      child: Card(
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
              Row(
                children: [
                  Expanded(
                    child: Text(
                      event.name,
                      style: const TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  // Status
                  Text(
                    isToday?"Today !":"",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: statusColor,
                    ),
                  ),

                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Icon(
                    Icons.calendar_today,
                    size: 18,
                    color: Color(0xffffd700),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    event.date,
                    style: const TextStyle(color: Colors.white70),
                  ),
                  const SizedBox(width: 20),
                  const Icon(
                    Icons.access_time_rounded,
                    size: 18,
                    color: Color(0xffffd700),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    event.time,
                    style: const TextStyle(color: Colors.white70),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Icon(Icons.person , color:Color(0xffffd700) ,),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xffffd700),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      event.checkedInCount.toString(),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF028ECA),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}