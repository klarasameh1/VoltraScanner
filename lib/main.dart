import 'package:event_scanner_app/core/theme/app_colors.dart';
import 'package:event_scanner_app/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'features/scanner/presentation/screens/home_screen.dart';
import 'providers/event_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => EventProvider()),
      ],
      child: MaterialApp(
        theme: ThemeData(
          primaryColor: AppColors.primary,
          scaffoldBackgroundColor: AppColors.background,
          fontFamily: 'Lexend',
        ),
        debugShowCheckedModeBanner: false,
        title: 'ALX Scanner',
        home: const HomeScreen(),
      ),
    );
  }
}