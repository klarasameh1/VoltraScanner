import 'package:event_scanner_app/features/scanner/presentation/scanner_screen.dart';
import 'package:event_scanner_app/features/scanner/presentation/widgets/app_bar.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
            children: [
              const CustomAppBar(userName: 'Voltra Scanner'),
              const SizedBox(height: 100,),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const QRScannerScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF0053C8),
                    foregroundColor: Colors.white,
                    shadowColor: Colors.black,
                    elevation: 5,
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                      side: const BorderSide(color: Colors.white, width: 2),
                    ),
                  ),
                  child: const Text(
                    "Open Scanner",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                )
              ),

            ]
        )
    );
  }
}