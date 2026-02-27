import 'package:flutter/material.dart';

class ScanResultScreen extends StatelessWidget {
  final bool success;
  final String message;

  const ScanResultScreen({
    super.key,
    required this.success,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: success ? Colors.green : Colors.red,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              success ? Icons.check_circle : Icons.cancel,
              size: 120,
              color: Colors.white,
            ),
            const SizedBox(height: 30),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: success ? Colors.green : Colors.red,
              ),
              onPressed: () => Navigator.pop(context),
              child: const Text("Scan Again"),
            )
          ],
        ),
      ),
    );
  }
}