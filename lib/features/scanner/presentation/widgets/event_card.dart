import 'package:event_scanner_app/core/theme/app_colors.dart';
import 'package:event_scanner_app/features/scanner/data/models/event.dart';
import 'package:flutter/material.dart';

class EventCard extends StatelessWidget {
  final Event event;
  final VoidCallback? onScan;
  final bool isToday;

  const EventCard({
    super.key,
    required this.event,
    this.onScan,
    this.isToday = false,
  });

  @override
  Widget build(BuildContext context) {
    final DateTime eventDate = event.date;
    final DateTime today = DateTime.now();

    // Determine if this event is Today
    bool showToday = isToday ||
        (eventDate.year == today.year &&
            eventDate.month == today.month &&
            eventDate.day == today.day);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Event title + Today indicator
          Row(
            children: [
              Expanded(
                child: Text(
                  event.name,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppColors.white,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              if (showToday)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.accentGreen,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: const Text(
                    "Today !",
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),

          const SizedBox(height: 12),

          // Event date & time (always visible)
          Row(
            children: [
              const Icon(
                Icons.calendar_today,
                size: 18,
                color: AppColors.yellow,
              ),
              const SizedBox(width: 6),
              Text(
                "${eventDate.day}/${eventDate.month}/${eventDate.year}",
                style: const TextStyle(color: Colors.white70),
              ),
              const SizedBox(width: 20),
              const Icon(
                Icons.access_time_rounded,
                size: 18,
                color: AppColors.yellow,
              ),
              const SizedBox(width: 6),
              Text(
                event.time,
                style: const TextStyle(color: Colors.white70),
              ),
            ],
          ),

          // Only show check-in count for Today
          if (showToday) ...[
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Icon(
                  Icons.person,
                  color: AppColors.yellow,
                ),
                const SizedBox(width: 6),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.yellow,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    event.checkedInCount.toString(),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
          ],

          // Scan button for Today only
          if (showToday && onScan != null) ...[
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onScan,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.yellow,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const Text(
                  "Start Scanning",
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    letterSpacing: 0.3,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
