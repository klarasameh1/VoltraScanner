import 'package:event_scanner_app/features/scanner/data/models/event.dart';
import 'package:event_scanner_app/features/scanner/presentation/widgets/app_bar.dart';
import 'package:event_scanner_app/features/scanner/presentation/widgets/eventsList.dart';
import 'package:event_scanner_app/features/scanner/presentation/widgets/scanner_button.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isLoading = true;
  String? errorMessage;
  List<Event> upcomingEvents = [];

  @override
  void initState() {
    super.initState();
    fetchEvents();
  }

  Future<void> fetchEvents() async {
    try {

      // Dummy data (replace with real API call later)
      await Future.delayed(const Duration(seconds: 2)); // simulate API delay
      final events = [
        Event(id: 1, name: 'BMB Event', date: '2026-03-10', time: '4:00 pm'),
        Event(id: 2, name: 'Find your Fit', date: '2026-03-15', time: '5:00 pm'),
        Event(id: 3, name: 'Coding Competition', date: '2026-03-20', time: '6:30 pm'),
      ];
      /// Replace later with
      //final events = await eventsService.getUpcomingEvents();

      if (!mounted) return;

      setState(() {
        upcomingEvents = events;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        errorMessage = "Failed to load events. Please check your connection.";
        isLoading = false;
      });
    }
  }

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
            const ScannerButton(),
            const SizedBox(height: 24),

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
                    const SizedBox(height: 5),
                    Container(height: 2, color: const Color(0xffffd700)),
                    const SizedBox(height: 16),

                    Expanded(
                      child: Builder(
                        builder: (_) {
                          if (isLoading) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }

                          if (errorMessage != null) {
                            return Center(
                              child: Text(
                                errorMessage!,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: Colors.red,
                                  fontSize: 16,
                                ),
                              ),
                            );
                          }

                          if (upcomingEvents.isEmpty) {
                            return const Center(
                              child: Text(
                                "No upcoming events",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey,
                                ),
                              ),
                            );
                          }

                          return EventsList(events: upcomingEvents);
                        },
                      ),
                    ),
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