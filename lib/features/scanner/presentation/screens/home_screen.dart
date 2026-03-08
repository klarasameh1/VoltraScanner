import 'package:event_scanner_app/core/theme/app_colors.dart';
import 'package:event_scanner_app/features/scanner/presentation/widgets/app_bar.dart';
import 'package:event_scanner_app/features/scanner/presentation/screens/scanner_screen.dart';
import 'package:event_scanner_app/providers/event_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/event_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
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
      backgroundColor: AppColors.background,
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

                    // Today Section
                    Consumer<EventProvider>(
                      builder: (context, provider, _) {
                        final todayEvents = provider.todayEvents;

                        if (todayEvents.isEmpty) return const SizedBox();

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 6,
                                  height: 24,
                                  decoration: BoxDecoration(
                                    color: AppColors.accentGreen,
                                    borderRadius: BorderRadius.circular(3),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                const Text(
                                  'Today!',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primary,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            EventCard(
                              event: todayEvents.first,
                              isToday: true,
                              onScan: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => ScannerScreen(event: todayEvents.first),
                                  ),
                                );
                              },
                            ),
                          ],
                        );
                      },
                    ),

                    const SizedBox(height: 24),

                    // Coming Events Header
                    const Text(
                      'Coming Events',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Container(
                      height: 4,
                      color: AppColors.accentGreen,
                    ),
                    const SizedBox(height: 12),

                    // Event List
                    Expanded(
                      child: RefreshIndicator(
                        onRefresh: _refreshEvents,
                        color: AppColors.accentGreen,
                        child: Consumer<EventProvider>(
                          builder: (context, provider, _) {
                            if (provider.isLoading) {
                              return const Center(
                                child: CircularProgressIndicator(color: AppColors.teal),
                              );
                            }

                            final futureEvents = provider.futureEvents;

                            if (futureEvents.isEmpty) {
                              return const Center(
                                child: Text(
                                  "No upcoming events",
                                  style: TextStyle(
                                    color: AppColors.textSecondary,
                                    fontSize: 16,
                                  ),
                                ),
                              );
                            }

                            return ListView.builder(
                              padding: const EdgeInsets.only(top: 8),
                              itemCount: futureEvents.length,
                              itemBuilder: (context, index) {
                                final event = futureEvents[index];
                                return EventCard(
                                  event: event,
                                  isToday: false,
                                  onScan: null,
                                );
                              },
                            );
                          },
                        ),
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