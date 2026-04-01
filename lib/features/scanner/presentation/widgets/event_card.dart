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
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (event.photos.isNotEmpty) ...[
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                event.photos.first,
                height: 150,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const SizedBox(),
              ),
            ),
            const SizedBox(height: 16),
          ],

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  event.name,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.white,
                  ),
                ),
              ),
              if (showToday)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
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

          //Date and Time
          Row(
            children: [
              const Icon(Icons.calendar_today, size: 18, color: AppColors.yellow),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  "${eventDate.day}/${eventDate.month}/${eventDate.year}",
                  style: const TextStyle(color: Colors.white70),
                ),
              ),
              const SizedBox(width: 20),
              const Icon(Icons.access_time_rounded, size: 18, color: AppColors.yellow),
              const SizedBox(width: 6),
              Text(
                event.time,
                style: const TextStyle(color: Colors.white70),
              ),
            ],
          ),

          const SizedBox(height: 8),

          //Type and Category
          Row(
            children: [
              Icon(event.type == "online" ? Icons.videocam : Icons.location_city,
                  size: 18, color: AppColors.yellow),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  event.type,
                  style: const TextStyle(color: Colors.white70),
                ),
              ),

              const Icon(Icons.people, size: 18, color: AppColors.yellow),
              const SizedBox(width: 6),
              Text(
                event.category,
                style: const TextStyle(color: Colors.white70),
                overflow: TextOverflow.ellipsis,

              ),
            ],
          ),

          const SizedBox(height: 8),





          //Counter and Scanner "only if toady and offline"
          // if (showToday & !(event.type == "online")) ...[
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                  decoration: BoxDecoration(
                    color: AppColors.yellow,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.person, color: AppColors.primary, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        event.checkedInCount.toString(),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 8,),
                if (onScan != null)
                  Expanded(
                    child: ElevatedButton(
                      onPressed: onScan,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.yellow,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
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
            ),
          ],
        // ],
      ),
    );
  }
}