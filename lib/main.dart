import 'package:flutter/material.dart';
import 'features/scanner/presentation/screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      theme: ThemeData(
        fontFamily: 'Lexend',
      ),
      debugShowCheckedModeBanner: false,
      title: 'ALX Scanner',
      home: HomeScreen(),
    );
  }
}

