import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:event_scanner_app/features/scanner/presentation/screens/scanner_screen.dart';
import 'package:event_scanner_app/features/scanner/presentation/widgets/app_bar.dart';
import 'package:event_scanner_app/features/scanner/presentation/widgets/event_card.dart';
import 'package:event_scanner_app/providers/event_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // استدعاء fetchEvents من Provider
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<EventProvider>().fetchEvents();
    });
  }

  Future<void> _refreshEvents() async {
    await context.read<EventProvider>().fetchEvents();
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

            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Our Coming Events',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color(0xffffd700),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Container(height: 4, color: const Color(0xffffd700)),

                    Expanded(
                      child: Consumer<EventProvider>(
                        builder: (context, eventProvider, child) {
                          if (eventProvider.isLoading) {
                            return const Center(
                              child: CircularProgressIndicator(
                                color: Color(0xFF028ECA),
                              ),
                            );
                          }

                          if (eventProvider.errorMessage != null) {
                            return Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    eventProvider.errorMessage!,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      color: Colors.red,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  ElevatedButton(
                                    onPressed: _refreshEvents,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF028ECA),
                                    ),
                                    child: const Text(
                                      'Try Again',
                                      style: TextStyle(color: Color(0xffffd700)),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }

                          if (eventProvider.upcomingEvents.isEmpty) {
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

                          return RefreshIndicator(
                            onRefresh: _refreshEvents,
                            color: const Color(0xFF028ECA),
                            child: ListView.builder(
                              itemCount: eventProvider.upcomingEvents.length,
                              itemBuilder: (context, index) {
                                final event = eventProvider.upcomingEvents[index];

                                return EventCard(
                                  event: event,
                                  onTap: () async {
                                    final updatedCount = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => ScannerScreen(event: event),
                                      ),
                                    );

                                    if (updatedCount != null) {
                                      // تحديث في Provider
                                      eventProvider.updateEventCheckedInCount(
                                        event.id,
                                        updatedCount,
                                      );
                                    }
                                  },
                                );
                              },
                            ),
                          );
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