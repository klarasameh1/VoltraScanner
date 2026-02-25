import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class ScannerScreen extends StatefulWidget {
  const ScannerScreen({super.key});

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {
  bool scanned = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("QR Scanner")),
      body: MobileScanner(
        controller: MobileScannerController(
          detectionSpeed: DetectionSpeed.normal,
        ),
        onDetect: (capture) {
          if (scanned) return;

          final barcode = capture.barcodes.first;
          final String? code = barcode.rawValue;

          if (code != null) {
            scanned = true;
            Navigator.pop(context, code);
          }
        },
      ),
    );
  }
}