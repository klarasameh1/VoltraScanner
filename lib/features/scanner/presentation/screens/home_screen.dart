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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CustomAppBar(userName: 'Voltra Scanner'),
            const SizedBox(height: 24),

            // Today Section "fixed"
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Consumer<EventProvider>(
                builder: (context, provider, _) {
                  if (provider.isLoading) {
                    return const Center(
                      child: CircularProgressIndicator(color: AppColors.primary),
                    );
                  }

                  final todayEvents = provider.todayEvents;

                  if (todayEvents.isEmpty) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Center(
                        child: Text(
                          "No events today ...",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                    );
                  }

                  return EventCard(
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
                  );
                },
              ),
            ),

            const SizedBox(height: 24),

            // Coming Events Header
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Coming Events',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ),
            const SizedBox(height: 5),
            Container(
              height: 4,
              color: AppColors.accentGreen,
              margin: const EdgeInsets.symmetric(horizontal: 16),
            ),
            const SizedBox(height: 12),

            // Coming Events List (scrollable + refreshable)
            Expanded(
              child: RefreshIndicator(
                notificationPredicate: (notification) => notification.depth == 0,
                onRefresh: _refreshEvents,
                color: AppColors.primary,
                backgroundColor: Colors.white,
                strokeWidth: 3,
                displacement: 60,
                edgeOffset: 10,


                child: Consumer<EventProvider>(
                  builder: (context, provider, _) {
                    final futureEvents = provider.futureEvents;

                    if (futureEvents.isEmpty) {
                      return ListView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        children: const [
                          SizedBox(height: 200),
                          Center(
                            child: Text(
                              "No upcoming events",
                              style: TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      );
                    }

                    return ListView.builder(
                      physics: const AlwaysScrollableScrollPhysics(), // مهم

                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      itemCount: futureEvents.length,
                      itemBuilder: (context, index) {
                        final event = futureEvents[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: EventCard(
                            event: event,
                            isToday: false,
                            onScan: null,
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        )
      ),
    );
  }
}