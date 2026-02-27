import 'package:event_scanner_app/features/scanner/presentation/widgets/app_bar.dart';
import 'package:event_scanner_app/features/scanner/presentation/widgets/eventsList.dart';
import 'package:event_scanner_app/features/scanner/presentation/widgets/scanner_button.dart';
import 'package:event_scanner_app/models/event.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  /// Dummy Events
  final List<Event> upcomingEvents = [
    Event(id: 1, name: 'BMB Event', date: '2026-03-10', time: '4:00 pm'),
    Event(id: 2, name: 'Find your Fit', date: '2026-03-15', time: '5:00 pm'),
    Event(id: 3, name: 'Coding Competition', date: '2026-03-20', time: '6:30 pm'),
    Event(id: 4, name: 'BMB Event', date: '2026-03-10', time: '4:00 pm'),
    Event(id: 5, name: 'Find your Fit', date: '2026-03-15', time: '5:00 pm'),
    Event(id: 6, name: 'Coding Competition', date: '2026-03-20', time: '6:30 pm'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        top: false,
        bottom: false,
        child: Column(
          children: [
            const CustomAppBar(userName: 'Voltra Scanner'),
            const SizedBox(height: 24),

            /// Scanner Button
            const ScannerButton(),
            const SizedBox(height: 24),

            /// Upcoming Events Section
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
                        color: Color(0xffffd700),
                      ),
                    ),
                    SizedBox(height: 5,child: Container(color: const Color(0xffffd700),),),
                    Expanded(child: EventsList(events:upcomingEvents))
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}