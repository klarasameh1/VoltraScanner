import 'package:event_scanner_app/features/scanner/presentation/widgets/app_bar.dart';
import 'package:event_scanner_app/features/scanner/presentation/widgets/eventsList.dart';
import 'package:event_scanner_app/features/scanner/presentation/widgets/scanner_button.dart';
import 'package:event_scanner_app/models/event.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
   HomeScreen({super.key});

/// Dummy Data till Api is ready
  List<Event> upcomingEvents = [
    Event(id: 1, name: 'BMB Event', date: '2026-03-10', time: '4:00 pm'),
    Event(id: 2, name: 'Find your Fit', date: '2026-03-15', time: '5:00 pm'),
    Event(id: 3, name: 'Coding Competition', date: '2026-03-20', time: '6:30 pm'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF101922),
      body: Column(
        children: [
          const CustomAppBar(userName: 'Voltra Scanner'),
          const SizedBox(height: 40),
          ScannerButton(),
          const SizedBox(height: 40),

          // Title
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Upcoming Events',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: EventsList(events: upcomingEvents)
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}