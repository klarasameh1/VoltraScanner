import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class UniversalQRScanner extends StatefulWidget {
  const UniversalQRScanner({super.key});
  @override
  State<UniversalQRScanner> createState() => _UniversalQRScannerState();
}

class _UniversalQRScannerState extends State<UniversalQRScanner> {
  bool scanned = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("QR Scanner")),
      body: MobileScanner(
        controller: MobileScannerController(detectionSpeed: DetectionSpeed.normal),
        onDetect: (capture) {
          if (scanned) return;
          final barcode = capture.barcodes.first;
          final code = barcode.rawValue;
          if (code != null) {
            scanned = true;
            Navigator.pop(context, code);
          }
        },
      ),
    );
  }
}