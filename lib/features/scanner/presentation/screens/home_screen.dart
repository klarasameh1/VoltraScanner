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
        child: RefreshIndicator(
          onRefresh: _refreshEvents,
          color: AppColors.primary,
          backgroundColor: Colors.white,
          strokeWidth: 3,
          displacement: 60,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CustomAppBar(userName: 'Voltra Scanner'),
                const SizedBox(height: 24),

                // Today Events Section - الهيدر دايماً موجود
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Today's Events",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        height: 4,
                        color: AppColors.accentGreen,
                      ),
                      const SizedBox(height: 12),

                      // محتوى أحداث اليوم
                      Consumer<EventProvider>(
                        builder: (context, provider, _) {
                          if (provider.isLoading && provider.events.isEmpty) {
                            return const Center(
                              child: Padding(
                                padding: EdgeInsets.all(20),
                                child: CircularProgressIndicator(color: AppColors.primary),
                              ),
                            );
                          }

                          final todayEvents = provider.todayEvents;

                          if (todayEvents.isEmpty) {
                            return const Padding(
                              padding: EdgeInsets.symmetric(vertical: 16),
                              child: Center(
                                child: Text(
                                  "No events today",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ),
                            );
                          }

                          return Column(
                            children: todayEvents.map((event) => Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: EventCard(
                                event: event,
                                isToday: true,
                                onScan: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => ScannerScreen(event: event),
                                    ),
                                  );
                                },
                              ),
                            )).toList(),
                          );
                        },
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Coming Events Section - الهيدر دايماً موجود
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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

                      // محتوى الأحداث القادمة
                      Consumer<EventProvider>(
                        builder: (context, provider, _) {
                          final futureEvents = provider.futureEvents;

                          if (provider.isLoading) {
                            return const Center(
                              child: Padding(
                                padding: EdgeInsets.all(20),
                                child: CircularProgressIndicator(color: AppColors.primary),
                              ),
                            );
                          }

                          if (futureEvents.isEmpty) {
                            return const Padding(
                              padding: EdgeInsets.symmetric(vertical: 16),
                              child: Center(
                                child: Text(
                                  "No upcoming events",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ),
                            );
                          }

                          return Column(
                            children: futureEvents.map((event) => Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: EventCard(
                                event: event,
                                isToday: false,
                                onScan: null,
                              ),
                            )).toList(),
                          );
                        },
                      ),

                      const SizedBox(height: 20), // مسافة في النهاية
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}