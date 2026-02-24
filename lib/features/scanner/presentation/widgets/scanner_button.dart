import 'package:flutter/material.dart';
import '../scanner_screen.dart';

class ScannerButton extends StatefulWidget {
  const ScannerButton({super.key});
  @override
  State<ScannerButton> createState() => _ScannerButtonState();
}

class _ScannerButtonState extends State<ScannerButton> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const QRScannerScreen()),
        );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0x800053C8),
        foregroundColor: Colors.white,
        shadowColor: Colors.black,
        elevation: 10,
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
      child: const Column(
        children: [
          Icon(Icons.qr_code_scanner , size: 35,),
          Text(
            "Open Scanner",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
